#define itRecordsViewControllerWithDevicesAndColorStates(name, ...) _itTestsWithDevicesAndColorStateRecording(self, __LINE__, __FILE__, YES, name, (__VA_ARGS__))
#define itHasSnapshotsForViewControllerWithDevicesAndColorStates(name, ...) _itTestsWithDevicesAndColorStateRecording(self, __LINE__, __FILE__, NO, name, (__VA_ARGS__))

void _itTestsWithDevicesAndColorStateRecording(id self, int lineNumber, const char *fileName, BOOL record, NSString *name, id (^block)());


#define itRecordsSnapshotsForDevices(name, ...) _itTestsWithDevicesRecording(self, __LINE__, __FILE__, YES, name, (__VA_ARGS__))
#define itHasSnapshotsForDevices(name, ...) _itTestsWithDevicesRecording(self, __LINE__, __FILE__, NO, name, (__VA_ARGS__))

void _itTestsWithDevicesRecording(id self, int lineNumber, const char *fileName, BOOL record, NSString *name, id (^block)());
