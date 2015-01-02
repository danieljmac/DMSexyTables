//
//  DMSexyTable.m
//  DMSexyTablesExample
//
//  Created by Daniel McCarthy on 1/1/15.
//  Copyright (c) 2015 Daniel McCarthy. All rights reserved.
//

#import "DMSexyTable.h"
#import "UIImage+ImageEffects.h"

@implementation DMSexyTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)bgImage {
    self = [super initWithFrame:frame];
    if (self) {
        _bgImage = bgImage;
        _bgBlurImage = [bgImage applyBlurWithRadius:DEFAULT_BLUR_RADIUS tintColor:DEFAULT_BLUR_TINT_COLOR saturationDeltaFactor:DEFAULT_BLUR_DELTA_FACTOR maskImage:nil];
        self.backgroundColor = [UIColor clearColor];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self setupTheBackgroundView];
    }
    return self;
}

- (CALayer *)createTopMaskWithSize:(CGSize)size startFadeAt:(CGFloat)top endAt:(CGFloat)bottom topColor:(UIColor *)topColor botColor:(UIColor *)botColor
{
    top = top/size.height;
    bottom = bottom/size.height;
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.anchorPoint = CGPointZero;
    maskLayer.startPoint = CGPointMake(0.5f, 0.0f);
    maskLayer.endPoint = CGPointMake(0.5f, 1.0f);
    
    //an array of colors that dictatates the gradient(s)
    maskLayer.colors = @[(id)topColor.CGColor, (id)topColor.CGColor, (id)botColor.CGColor, (id)botColor.CGColor];
    maskLayer.locations = @[@0.0, @(top), @(bottom), @1.0f];
    maskLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    return maskLayer;
}

- (void)setTheBackgroundImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    _bgBlurImage = [bgImage applyBlurWithRadius:DEFAULT_BLUR_RADIUS tintColor:DEFAULT_BLUR_TINT_COLOR saturationDeltaFactor:DEFAULT_BLUR_DELTA_FACTOR maskImage:nil];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self setupTheBackgroundView];
}

- (void)setupTheBackgroundView {
    UIView *masterContainer = [[UIView alloc] initWithFrame:self.frame];
    masterContainer.backgroundColor = [UIColor clearColor];
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [_bgScrollView setUserInteractionEnabled:NO];
    [_bgScrollView setContentSize:CGSizeMake(self.frame.size.width + 2*DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, self.frame.size.height)];
    [masterContainer addSubview:_bgScrollView];
    self.backgroundView = masterContainer;
    
    _constraintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width + 2*DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, self.frame.size.height + DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    [_bgScrollView addSubview:_constraintView];
    
    _bgImgView = [[UIImageView alloc] initWithImage:_bgImage];
    [_bgImgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_bgImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_constraintView addSubview:_bgImgView];
    
    _bgBlurImgView = [[UIImageView alloc] initWithImage:_bgBlurImage];
    [_bgBlurImgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_bgBlurImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_bgBlurImgView setAlpha:0];
    [_constraintView addSubview:_bgBlurImgView];
    
    [_constraintView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bgImgView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgImgView)]];
    [_constraintView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bgImgView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgImgView)]];
    [_constraintView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bgBlurImgView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgBlurImgView)]];
    [_constraintView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bgBlurImgView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgBlurImgView)]];
    [self scrollHorizontalRatio:0];
}

- (void)scrollHorizontalRatio:(CGFloat)ratio
{
    [_bgScrollView setContentOffset:CGPointMake(DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL + ratio * DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, _bgScrollView.contentOffset.y)];
}

- (void)scrollVerticallyToOffset:(CGFloat)offsetY
{
    [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY)];
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //translate into ratio to height
    CGFloat ratio = scrollView.contentOffset.y*0.01f;
    ratio = ratio<0?0:ratio;
    ratio = ratio>1?1:ratio;
    
    //set background scroll
    [_bgScrollView setContentOffset:CGPointMake(DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL, ratio * DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL)];
    
    //set alpha
    [_bgBlurImgView setAlpha:ratio];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint point = *targetContentOffset;
    CGFloat ratio = (point.y + self.contentInset.top)/(self.frame.size.height - self.contentInset.top);
    
    //it cannot be inbetween 0 to 1 so if it is >.5 it is one, otherwise 0
    if (ratio > 0 && ratio < 1) {
        if (velocity.y == 0) {
            ratio = ratio > .5?1:0;
        }else if(velocity.y > 0){
            ratio = ratio > .1?1:0;
        }else{
            ratio = ratio > .9?1:0;
        }
        targetContentOffset->y = ratio * self.frame.origin.y - self.contentInset.top;
    }
    
}


@end
