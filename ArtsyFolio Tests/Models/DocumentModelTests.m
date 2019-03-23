SpecBegin(DocumentModelTests);

__block NSManagedObjectContext *context;

describe(@"model behavior", ^{
    it(@"de-encodes paths for file name", ^{
        Document *document = [Document stubbedModelFromJSON:@{ @"id" : @"",
                                                               @"filename" : @"name%2thing%2actual_name" }];
        expect(document.presentableFileName).to.equal(@"actual name");
    });

    it(@"prioritises title for presentable name", ^{
        Document *document = [Document stubbedModelFromJSON:@{ @"id" : @"",
                                                               @"filename" : @"name",
                                                               @"title" : @"title" }];
        expect(document.presentableFileName).to.equal(@"title");
    });

    it(@"has a filename you'd expect", ^{
        Document *document = [Document stubbedModelFromJSON:@{ @"id" : @"",
                                                               @"filename" : @"name%2thing%2actual_name.jpg" }];
        expect(document.emailableFileName).to.equal(@"actual_name.jpg");
    });

});

describe(@"thumbnailing", ^{
    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];
    });

    it(@"shows a generic image for unknown filetypes", ^{
        Document *document = [Document modelFromJSON:@{
            ARFeedDocumentFileName : @"file.ort"
        } inContext:context];

        expect(document.thumbnailFilePath).to.equal(document.genericDocumentFilePath);
    });

    it(@"shows a generic image for known un-renderable files", ^{
        Document *document = [Document modelFromJSON:@{
            ARFeedDocumentFileName : @"file.docx"
        } inContext:context];

        expect(document.thumbnailFilePath).to.equal(document.genericTextDocumentFilePath);
    });

    pending(@"subclasses", ^{
        it(@"returns the right filepath if the file exists", ^{
            ShowDocument *document = [ShowDocument modelFromJSON:@{
                ARFeedDocumentFileName : @"file.pdf"
            } inContext:context];

            id mock = OCMPartialMock(document);
            OCMStub([mock canGenerateThumbnail]).andReturn(YES);
            expect([mock thumbnailFilePath]).toNot.equal(document.genericTextDocumentFilePath);
        });

        it(@"returns a thumbnail if the file doesn't exist and it is a thumbnailable icon", ^{
            ArtistDocument *document = [ArtistDocument modelFromJSON:@{
                ARFeedDocumentFileName : @"file.srd"
            } inContext:context];

            id mock = OCMPartialMock(document);
            OCMStub([mock canGenerateThumbnail]).andReturn(NO);
            expect([mock thumbnailFilePath]).toNot.equal(document.genericDocumentFilePath);
        });
    });

});

SpecEnd
