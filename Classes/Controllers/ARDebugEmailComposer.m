#import "ARAppDelegate.h"
#import <GRMustache/GRMustache.h>
#import "ARFileUtils+FolioAdditions.h"
#import "ARDiagnostics.h"


@implementation ARDebugEmailComposer

+ (void)createEmailWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
{
    if ([MFMailComposeViewController canSendMail]) {
        NSMutableDictionary *issues = [NSMutableDictionary dictionary];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {

            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = delegate;

            // Send the sqlite database with the email
            NSString *coreDataStorePath = [ARFileUtils coreDataStorePath];
            NSString *coreDataStoreFileName = [ARFileUtils coreDataStoreFileName];

            NSData *fileData = [NSData dataWithContentsOfFile:coreDataStorePath];
            if (fileData) {
                [mailController addAttachmentData:fileData mimeType:@"application/x-sqlite3" fileName:coreDataStoreFileName];
            }

            NSData *syncLogData = [NSData dataWithContentsOfFile:ARSyncLogPath()];
            if (syncLogData) {
                [mailController addAttachmentData:syncLogData mimeType:@"text" fileName:@"synclog.txt"];
            }

            issues[@"core_data"] = [self coreDataIssues];
            issues[@"defaults"] = [self defaultsAsStringArray];

            NSString *body = [self bodyFromTemplateWithParam:issues];

            dispatch_async(dispatch_get_main_queue(), ^(void) {

                [mailController setMessageBody:body isHTML:YES];
                [mailController setSubject:@"Folio Debug Details"];

                NSMutableArray *recipients = [NSMutableArray arrayWithObject:@"foliosupport@artsymail.com"];
                if ([[Partner currentPartner] representativeEmail]) {
                    [recipients addObject:[[Partner currentPartner] representativeEmail]];
                }
                [mailController setToRecipients:recipients];

                ARAppDelegate *delegate = (ARAppDelegate *)
                [UIApplication sharedApplication].delegate;
                [[delegate rootViewController] presentModalViewController:mailController animated:YES];
            });
        });
    }
}

+ (NSString *)bodyFromTemplateWithParam:(NSDictionary *)params
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"debug_email_template" ofType:@"html"];
    NSError *error = nil;
    NSString *body = [GRMustacheTemplate renderObject:params fromContentsOfFile:filePath error:&error];
    if (error) {
        [ARAnalytics event:@" Email Composer Error in Mustache" withProperties:@{ @"error" : error.localizedDescription }];
        return @"";
    }
    return body;
}

+ (NSArray *)coreDataIssues
{
    NSMutableArray *issues = [NSMutableArray array];
    NSFileManager *manager = [NSFileManager defaultManager];

    for (Image *image in [Image allObjects]) {
        if (image.needsTiles) {
            // Check for tiles by looking at the firs tone that would be downloaded normally
            NSString *tilePath = [image imagePathForTileForLevel:11 atX:1 andY:1];
            if (![manager fileExistsAtPath:tilePath]) {
                NSString *errorString = [NSString stringWithFormat:@"No tiles found locally for <a href='http://artsy.net/%@'>%@</a>.", image.artwork.slug, image.artwork];
                [issues addObject:errorString];
            }

            // Check for the detail images
            for (NSString *formatType in [Image imageFormatsToDownload]) {
                NSString *imagePath = [image imagePathWithFormatName:formatType];
                if (![manager fileExistsAtPath:imagePath]) {
                    NSString *errorString = [NSString stringWithFormat:@"No %@ image found locally for %@", formatType, image.artwork];
                    [issues addObject:errorString];
                }
            }
        }
    }

    for (Document *document in [Document allObjects]) {
        if (![manager fileExistsAtPath:document.filePath]) {
            NSString *errorString = [NSString stringWithFormat:@"No document file found locally for %@", document];
            [issues addObject:errorString];
        }
    }

    return issues;
}

+ (NSArray *)defaultsAsStringArray
{
    NSDictionary *allDefaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSMutableArray *defaults = [NSMutableArray array];

    for (id key in allDefaults.allKeys) {
        // Lets not email their key.
        if ([key isEqualToString:AROAuthToken]) continue;

        NSString *defaultsString = [NSString stringWithFormat:@"<i>%@</i> : %@", key, allDefaults[key]];
        [defaults addObject:defaultsString];
    }

    return defaults;
}

@end
