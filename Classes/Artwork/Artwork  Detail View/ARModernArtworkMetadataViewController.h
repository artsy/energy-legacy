

@interface ARModernArtworkMetadataViewController : UIViewController

/// Artwork to present metadata for
@property (readwrite, nonatomic, strong) Artwork *artwork;

/// Switches between long and short layouts
@property (readwrite, nonatomic, assign, getter=hasConstrainedHorizontalSpace) BOOL constrainedHorizontalSpace;

/// Switches between a maximum of 4 and infinte labels in the information section
@property (readwrite, nonatomic, assign, getter=hasConstraintVerticalSpace) BOOL constrainedVerticalSpace;

/// Suppress showing the more info arrow
@property (readwrite, nonatomic, assign) BOOL hideIndicator;

@end
