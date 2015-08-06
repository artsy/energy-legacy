@protocol ARArtworkMetadataViewable <NSObject>

@property (readwrite, nonatomic, assign) BOOL needsIndicator;
@property (readwrite, nonatomic, assign) CGFloat additionalImages;

- (void)setStrings:(NSArray *)strings;

@end
