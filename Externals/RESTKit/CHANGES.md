Changes from [RestKit 0.9.3](https://github.com/RestKit/RestKit/tree/0.9.3)

Added:

  + (id)objectInContext:(NSManagedObjectContext *)context;

Changed:
  
  + (NSArray *)propertiesNamed:(NSArray *)properties ->
  + (NSArray *)propertiesNamed:(NSArray *)properties inContext:(NSManagedObjectContext *)context;
  
Removed:

  + (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
  + (NSManagedObjectContext*)currentContext;
  

Also removed: Everything except:
  NSManagedObject+ActiveRecord.h
  NSManagedObject+ActiveRecord.m