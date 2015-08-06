#import <UIKit/UIKit.h>
#import "Artwork.h"
#import "Image.h"

NS_ENUM(NSInteger, ARViewInRoomRoomSize){
    ARViewInRoomRoomSizeSmall,
    ARViewInRoomRoomSizeLarge,
    ARViewInRoomRoomSizeXLarge,
    ARViewInRoomRoomSizeTooBig // this should never happen
};


@interface ARViewInRoomView : UIView {
    UIImageView *backgroundImageView;
    UIImageView *artworkImageView;
    Artwork *artwork;
    enum ARViewInRoomRoomSize roomSize;
}

+ (BOOL)canShowArtwork:(Artwork *)artwork;

@property (nonatomic) Artwork *artwork;
@property (assign) UIInterfaceOrientation roomOrientation;

@end
