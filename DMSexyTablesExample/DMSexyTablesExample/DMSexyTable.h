//
//  DMSexyTable.h
//  DMSexyTablesExample
//
//  Created by Daniel McCarthy on 1/1/15.
//  Copyright (c) 2015 Daniel McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_BLUR_RADIUS 14
#define DEFAULT_BLUR_TINT_COLOR [UIColor colorWithWhite:0 alpha:.2]
#define DEFAULT_BLUR_DELTA_FACTOR 1.4
//how much the background moves when scroll
#define DEFAULT_MAX_BACKGROUND_MOVEMENT_VERTICAL 30
#define DEFAULT_MAX_BACKGROUND_MOVEMENT_HORIZONTAL 150

@interface DMSexyTable : UITableView

@property (strong, nonatomic) UIImage *bgImage;
@property (strong, nonatomic) UIImageView *bgImgView;
@property (strong, nonatomic) UIImage *bgBlurImage;
@property (strong, nonatomic) UIImageView *bgBlurImgView;
@property (strong, nonatomic) UIScrollView *bgScrollView;
@property (strong, nonatomic) UIView *constraintView;

- (id)initWithFrame:(CGRect)frame andBackgroundImage:(UIImage *)bgImage;
- (void)setTheBackgroundImage:(UIImage *)bgImage;
- (void)scrollHorizontalRatio:(CGFloat)ratio;//from -1 to 1
- (void)scrollVerticallyToOffset:(CGFloat)offsetY;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

@end
