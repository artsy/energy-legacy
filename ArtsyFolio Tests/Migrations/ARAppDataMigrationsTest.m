NSManagedObjectContext *ARContextWithVersionString(NSString *string);

SpecBegin(ARAppDataMigrations);

__block NSManagedObjectContext *context;

it(@"migrates from 1.3", ^{
    expect(^{
        context = ARContextWithVersionString(@"1.3");
    }).toNot.raise(nil);
    expect(context).to.beTruthy();
    expect([Artwork countInContext:context error:nil]).to.beGreaterThan(0);
});

it(@"migrates from  1.3.5", ^{
    expect(^{
        context = ARContextWithVersionString(@"1.3.5");
    }).toNot.raise(nil);
    expect(context).to.beTruthy();
    expect([Artwork countInContext:context error:nil]).to.beGreaterThan(0);
});

it(@"migrates from  1.4", ^{
    expect(^{
        context = ARContextWithVersionString(@"1.4");
    }).toNot.raise(nil);
    expect(context).to.beTruthy();
    expect([Artwork countInContext:context error:nil]).to.beGreaterThan(0);
});

it(@"migrates from  2.0", ^{
    expect(^{
        context = ARContextWithVersionString(@"2.0");
    }).toNot.raise(nil);
    expect(context).to.beTruthy();
    expect([Artwork countInContext:context error:nil]).to.beGreaterThan(0);
});

SpecEnd

    NSManagedObjectContext *
    ARContextWithVersionString(NSString *string)
{
    // Allow it to migrate
    NSDictionary *options = @{
        NSMigratePersistentStoresAutomaticallyOption : @YES,
        NSInferMappingModelAutomaticallyOption : @YES
    };

    // Open up the the _current_ managed object model
    NSError *error = nil;
    NSManagedObjectModel *model = [CoreDataManager managedObjectModel];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    // Get an older Core Data file from fixtures
    NSString *storeName = [NSString stringWithFormat:@"ArtsyPartner_%@", string];
    NSURL *storeURL = [[NSBundle bundleForClass:ARAppDataMigrationsSpec.class] URLForResource:storeName withExtension:@"sqlite"];

    // Set the persistent store to be the fixture data
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Error creating persistant store: %@", error.localizedDescription);
        @throw @"Bad store";
        return nil;
    }

    // Create a stubbed context, check give it the old data, and it will update itself
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = persistentStoreCoordinator;
    return context;
}
