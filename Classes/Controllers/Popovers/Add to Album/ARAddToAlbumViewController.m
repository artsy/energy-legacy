

#import "ARAddToAlbumViewController.h"
#import "ARTableViewCell.h"
#import "ARSansSerifTextField.h"
#import "ARFlatButton.h"
#import "ARNavigationController.h"
#import "ARTickedTableViewCell.h"


@interface ARAddToAlbumViewController ()
@property (readonly, nonatomic, assign) BOOL showTextField;
@property (readonly, nonatomic, strong) UIButton *createAlbumButton;
@property (readonly, nonatomic, strong) UITextField *createAlbumTextField;
@property (readonly, nonatomic, strong) NSManagedObjectContext *context;
@end


@implementation ARAddToAlbumViewController

static const CGFloat ARTableViewCellSize = 44;
static const CGSize ARNewAlbumButtonSize = {.height = 42};
static const CGSize ARNewAlbumButtonInset = {.height = 15, .width = 15};
static const CGSize ARNewAlbumTextFieldInset = {.height = 10, .width = 16};

static const NSInteger AmountOfCellsToShowBeforeScrollingOnAdd = 6;

static const CGFloat ARSyncMessageHeight = 44;

- (void)dealloc
{
    if (self.showTextField) {
        [self.createAlbumTextField removeFromSuperview];
    }
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;

    _albums = [Album editableAlbumsByLastUpdateInContext:context];
    _context = context;

    return self;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger albumCount = [self.albums count];
    BOOL rowHasButton = (indexPath.row == albumCount && !self.showTextField) || indexPath.row > albumCount;

    if (rowHasButton) {
        CGFloat buttonHeight = ARNewAlbumButtonSize.height + (ARNewAlbumButtonInset.height * 2);
        return buttonHeight;
    } else {
        return ARTableViewCellSize;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.showTextField) {
        return [self.albums count] + 2;
    } else {
        return [self.albums count] + 1;
    }
}

- (ARSansSerifTextField *)createTextFieldWithFrame:(CGRect)textFieldFrame
{
    ARSansSerifTextField *textField = [[ARSansSerifTextField alloc] initWithFrame:textFieldFrame];
    textField.text = @"";
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    textField.font = [UIFont serifFontWithSize:ARFontSerif];
    textField.textAlignment = NSTextAlignmentNatural;
    textField.tintColor = [UIColor blackColor];
    return textField;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTableViewCell *cell = nil;
    NSInteger albumCount = [self.albums count];
    BOOL rowHasTextfield = indexPath.row == albumCount && self.showTextField;
    BOOL rowHasButton = (indexPath.row == albumCount && !self.showTextField) || indexPath.row > albumCount;

    NSString *cellIdentifier = @"ARArtworkActionViewCell";
    if (rowHasButton) {
        cellIdentifier = @"ARArtworkActionButtonCell";
    }
    if (rowHasTextfield) {
        cellIdentifier = @"ARArtworkActionTextfieldCell";
    }

    cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ARTickedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellIdentifier];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);

    if (indexPath.row < albumCount) {
        Album *rowAlbum = self.albums[indexPath.row];
        NSSet *rowAlbumArtworks = rowAlbum.artworks;

        NSString *labelString = [NSString stringWithFormat:@"%@ ( %@ )", rowAlbum.name, @(rowAlbumArtworks.count)];
        cell.textLabel.text = labelString;

        BOOL showTick = NO;
        if (rowAlbumArtworks.count >= _artworks.count) {
            showTick = ([[NSSet setWithArray:_artworks] isSubsetOfSet:rowAlbumArtworks]);
        }
        [(ARTickedTableViewCell *)cell setTickSelected:showTick animated:NO];
    }

    else if (rowHasTextfield) {
        CGRect textFieldFrame = CGRectMake(ARNewAlbumTextFieldInset.width, 4, cell.contentView.frame.size.width - (ARNewAlbumTextFieldInset.width * 2), ARNewAlbumButtonSize.height);
        _createAlbumTextField = [self createTextFieldWithFrame:textFieldFrame];

        cell.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];

        [cell.contentView addSubview:self.createAlbumTextField];
        [self.createAlbumTextField becomeFirstResponder];

        if (self.albums.count >= AmountOfCellsToShowBeforeScrollingOnAdd) {
            NSIndexPath *lastCellPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [aTableView scrollToRowAtIndexPath:lastCellPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }

    else if (rowHasButton) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];

        _createAlbumButton = [self createNewAlbumButton];
        [cell.contentView addSubview:self.createAlbumButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}


- (ARFlatButton *)createNewAlbumButton
{
    ARFlatButton *button = [ARFlatButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"NEW ALBUM" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(createNewAlbum) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor artsyGrayMedium];
    [button setBackgroundColor:UIColor.blackColor forState:UIControlStateHighlighted];
    button.frame = CGRectMake(ARNewAlbumButtonInset.height, ARNewAlbumButtonInset.width, CGRectGetWidth(self.tableView.frame) - (ARNewAlbumButtonInset.width * 2), ARNewAlbumButtonSize.height);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    return button;
}

- (CGSize)preferredContentSize
{
    // we need to take into account the lost "All Artworks" album,

    NSInteger offset = self.showTextField ? 1 : 0;
    CGFloat buttonHeight = ARNewAlbumButtonSize.height + (ARNewAlbumButtonInset.height * 2);

    CGFloat height = ((self.albums.count + offset) * ARTableViewCellSize) + buttonHeight;
    return CGSizeMake(320, height);
}

#pragma mark deal with creation of new album

- (void)createNewAlbum
{
    if (self.showTextField) {
        [self textFieldShouldReturn:self.createAlbumTextField];

    } else {
        _showTextField = YES;
        NSMutableArray *paths = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:self.albums.count inSection:0]];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.albums.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

        [self.createAlbumButton setTitle:@"DONE" forState:UIControlStateNormal];
        self.createAlbumButton.enabled = NO;
        self.createAlbumButton.alpha = .3;
        [self.createAlbumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];

        if (self.albums.count < AmountOfCellsToShowBeforeScrollingOnAdd) {
            self.container.popoverContentSize = self.preferredContentSize;
        }
    }
}

#pragma mark TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) return NO;

    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) return;

    Album *album = [Album objectInContext:self.context];
    album.slug = textField.text;
    album.name = textField.text;
    [album commitEditToArtworks:self.artworks];

    _albums = [Album editableAlbumsByLastUpdateInContext:album.managedObjectContext];
    _showTextField = NO;

    [self.createAlbumButton setTitle:@"NEW ALBUM" forState:UIControlStateNormal];
    [[self tableView] reloadData];

    [textField removeFromSuperview];

    [ARAnalytics event:ARNewAlbumEvent withProperties:@{
        @"from" : [ARNavigationController pageID],
        @"artworks" : @([self.artworks count])
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger length = textField.text.length + string.length - range.length;

    if (length == 0) {
        self.createAlbumButton.enabled = NO;
        self.createAlbumButton.alpha = 0.3;
    } else {
        self.createAlbumButton.enabled = YES;
        self.createAlbumButton.alpha = 1;
    }
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.albums count]) {
        Album *selectedAlbum = ((Album *)self.albums[indexPath.row]);
        ARTickedTableViewCell *cell = (ARTickedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

        NSString *event = [cell isSelected] ? ARRemoveFromAlbumEvent : ARAddToAlbumEvent;
        [ARAnalytics event:event withProperties:@{
            @"artworks" : @(self.artworks.count),
            @"from" : [ARNavigationController pageID]
        }];

        NSMutableSet *newArtworks = [NSMutableSet setWithSet:selectedAlbum.artworks];
        if ([cell isSelected]) {
            [newArtworks minusSet:[NSSet setWithArray:self.artworks]];

            if (self.documents) {
                [selectedAlbum removeDocuments:[NSSet setWithArray:_documents]];
            }

        } else {
            [newArtworks addObjectsFromArray:self.artworks];

            if (self.documents) {
                [selectedAlbum addDocuments:[NSSet setWithArray:_documents]];
            }
        }

        [cell setTickSelected:![cell isSelected] animated:YES];

        [selectedAlbum commitEditToArtworks:newArtworks.allObjects];

        NSString *labelString = [NSString stringWithFormat:@"%@ ( %@ )", selectedAlbum.name, @(selectedAlbum.artworks.count)];
        cell.textLabel.text = labelString;
    }
}

@end
