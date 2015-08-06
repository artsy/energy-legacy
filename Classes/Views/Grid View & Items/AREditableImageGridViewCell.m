#import "AREditableImageGridViewCell.h"
#import "ARImageGridViewItem.h"
#import "ARSansSerifTextField.h"
#import "ARDashedHighlightView.h"
#import "ARDateLabel.h"

static CGSize EditableTextFieldFrameDelta = {.width = -6.0, .height = -6.0};


@interface ARGridViewCell ()
@property (readonly) UILabel *titleLabel;
@property (readonly) ARDateLabel *subtitleLabel;
@end


@implementation AREditableImageGridViewCell {
    UITextField *_titleChangeTextField;
    UIButton *_deleteButton;

    BOOL _isEditing;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self removeTextField];
    [self removeDeleteButtonAnimated:NO];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _titleChangeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped:)];
    [self.titleLabel addGestureRecognizer:_titleChangeTapGesture];

    return self;
}

- (void)setItem:(id<ARGridViewItem>)item
{
    [super setItem:item];

    BOOL isEditable = NO;

    // Not all albums are editable. Let's take this into account.
    if ([item respondsToSelector:@selector(editable)]) {
        isEditable = [(id)item editable].boolValue;
    }

    [self setEditingEnabled:isEditable];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.editingEnabled) {
        _isEditing = editing;

        if ([self.item isMemberOfClass:[Album class]] && [(Album *)self.item editable].boolValue == YES) {
            if (editing) {
                [ARDashedHighlight highlightView:self.titleLabel animated:animated];

            } else {
                [ARDashedHighlight removeHighlight:self.titleLabel animated:animated];
                if (_titleChangeTextField) {
                    [self textFieldShouldReturn:_titleChangeTextField];
                }
            }

            [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
                self.subtitleLabel.alpha = !editing;
            }];
        }

        if (editing) {
            [self addDeleteButtonAnimated:animated];
        } else {
            [self removeDeleteButtonAnimated:animated];
        }

        [self setNeedsLayout];
        [self layoutSubviews];

    } else if (![self.item isKindOfClass:ARImageGridViewItem.class]) {
        CGFloat opacity = editing ? 0.5 : 1;
        [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
            self.contentView.alpha = opacity;
        }];
    }
}

#pragma mark -
#pragma mark Delete button

- (void)addDeleteButtonAnimated:(BOOL)animated
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(-6, -2, 44, 44);
        [_deleteButton setImage:[UIImage imageNamed:@"DeleteButton"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"DeleteButtonActive"] forState:UIControlStateHighlighted];
        [_deleteButton addTarget:self action:@selector(deleteAlbum:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.accessibilityLabel = @"Album Delete Button";
        _deleteButton.isAccessibilityElement = YES;

        [self.contentView addSubview:_deleteButton andFadeInForDuration:ARAnimationQuickDuration if:animated];
    }
}

- (void)removeDeleteButtonAnimated:(BOOL)animated
{
    [_deleteButton removeFromSuperviewAndFadeOutWithDuration:ARAnimationQuickDuration if:animated];
    _deleteButton = nil;
}

- (void)deleteAlbum:(UIButton *)sender
{
    NSDictionary *details = @{ARAlbumItemKey : self.item};
    [[NSNotificationCenter defaultCenter] postNotificationName:ARAlbumRemoveAlbumNotification object:nil userInfo:details];
}

//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//
//    if (!self.isSelectable && self.userInteractionEnabled) {
//        if (!selected && !_editingEnabled) {
//            [self removeTextField];
//        }
//    }
//}

#pragma mark -
#pragma mark Editing TextField

- (void)titleTapped:(id)sender
{
    if (_isEditing && !_titleChangeTextField && [self.item isMemberOfClass:[Album class]]) {
        UICollectionView *gridView = (UICollectionView *)[self superview];
        [gridView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        [self performSelector:@selector(addTextField:) withObject:nil afterDelay:0.1];
    }
}

- (void)addTextField:(id)object
{
    CGSize insets = EditableTextFieldFrameDelta;
    CGRect textFieldRect = CGRectInset(self.titleLabel.frame, insets.width, insets.height);

    _titleChangeTextField = [[ARSansSerifTextField alloc] initWithFrame:textFieldRect];
    _titleChangeTextField.text = [self.titleLabel.text isEqualToString:@"NEW ALBUM"] ? @"" : self.title;
    _titleChangeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    _titleChangeTextField.leftViewMode = UITextFieldViewModeAlways;
    _titleChangeTextField.delegate = self;
    _titleChangeTextField.returnKeyType = UIReturnKeyDone;
    _titleChangeTextField.keyboardAppearance = UIKeyboardAppearanceDark;

    [self.contentView addSubview:_titleChangeTextField];
    [_titleChangeTextField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self removeTextField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self.item isKindOfClass:[Album class]]) {
        [NSException exceptionWithName:@"Editing the name of something other than an album" reason:@"We don't support that yet" userInfo:nil];

    } else if (self.editingEnabled &&
               [self.item respondsToSelector:@selector(setName:)] &&
               !([textField.text length] == 0)) {
        // why beat around the bush?
        Album *item = (Album *)self.item;
        CGRect titleLabelFrame = self.titleLabel.frame;
        NSString *newName = textField.text;
        if ([newName isEqualToString:item.name]) {
            [self removeTextField];
            return YES;
        }

        item.name = newName;
        [self removeTextField];
        [self setTitle:newName];
        self.titleLabel.frame = titleLabelFrame;

        [item saveManagedObjectContextLoggingErrors];
        [[NSNotificationCenter defaultCenter] postNotificationName:ARAlbumDataChanged object:self.item];
        [ARAnalytics event:ARRenameAlbumEvent];
    }
    return YES;
}

- (void)removeTextField
{
    if (_titleChangeTextField) {
        [_titleChangeTextField resignFirstResponder];
        [_titleChangeTextField removeFromSuperview];
        _titleChangeTextField = nil;
    }
}

@end
