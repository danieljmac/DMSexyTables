//
//  DMTableSwiperView.m
//  Perq
//
//  Created by Daniel McCarthy on 1/23/14.
//  Copyright (c) 2014 Daniel McCarthy. All rights reserved.
//

#import "DMTableSwiperView.h"
#import "DMSexyTable.h"

@implementation UIScrollView (currentPage)

- (int)currentPage {
    //CGFloat pageWidth = self.frame.size.width;
    //return floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return round(self.contentOffset.x / self.frame.size.width);
}
@end

@interface DMTableSwiperView () {
    CGFloat containerWidth;
}

@end

@implementation DMTableSwiperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTableViews:(NSArray *)tableViewsArr tableFrame:(CGRect)tableFrame inViewController:(UIViewController *)viewController {
    self = [super initWithFrame:CGRectMake(0, 0, tableFrame.size.width + 4, tableFrame.size.height)];
    if (self) {
        if (tableViewsArr != nil) {
            [self setupSwiperWithTableViews:tableViewsArr withTableFrame:tableFrame inViewController:viewController];
        }
    }
    return self;
}

- (void)setupSwiperWithTableViews:(NSArray *)tableViewsArr withTableFrame:(CGRect)tableFrame inViewController:(UIViewController *)viewController {

    self.tableArray = [NSMutableArray new];
    self.tableArray = [tableViewsArr mutableCopy];
    
    id vcSelf = viewController;
    self.delegate = vcSelf;
    containerWidth = tableViewsArr.count*self.frame.size.width;
    self.pagingEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.contentSize = CGSizeMake(containerWidth, self.frame.size.height);
    
    [viewController.view addSubview:self];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    int i = 0;
    for (DMSexyTable *tblView in tableViewsArr) {
        [tblView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        UIView *tableContainer = [[UIView alloc] initWithFrame:tblView.frame];
        [self addSubview:tableContainer];
        [tableContainer addSubview:tblView];
        tableContainer.frame = CGRectMake(self.frame.size.width*i, 0, tblView.frame.size.width, tblView.frame.size.height);
        //tableContainer.layer.mask = [self createTopMaskWithSize:CGSizeMake(tableContainer.frame.size.width, tableContainer.frame.size.height) startFadeAt:60 endAt:67 topColor:[UIColor colorWithWhite:1.0 alpha:0.0] botColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        
        UIView *dupView = (UIView *)tblView.backgroundView;
        UIScrollView *bgvw = [self newDuplicateOfView:dupView withFrame:tableContainer.frame];
        [self insertSubview:bgvw atIndex:0];
        i++;
    }
    
}

- (UIScrollView*)newDuplicateOfView:(UIView *)originalView withFrame:(CGRect)theFrame {
    UIScrollView *v = [[UIScrollView alloc] initWithFrame:theFrame];
    v.autoresizingMask = originalView.autoresizingMask;
    
    for (UIScrollView *v1 in originalView.subviews) {
        UIScrollView *v2 = [[UIScrollView alloc] initWithFrame:v1.frame];
        v2.autoresizingMask = v1.autoresizingMask;
        [v2 addSubview:v1];
        [v addSubview:v2];
    }
    
    return v;
}

/*- (CALayer *)createTopMaskWithSize:(CGSize)size startFadeAt:(CGFloat)top endAt:(CGFloat)bottom topColor:(UIColor *)topColor botColor:(UIColor *)botColor
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
}*/

#pragma mark - scrollMethods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if ([object isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = object;
            if ([object isKindOfClass:[DMSexyTable class]]) {
                [self handleVerticalScrollWithScrollView:scrollView];
            }
            else if ([object isKindOfClass:[self class]]) {
                [self handleHorrizontalScrollWithScrollView:scrollView];
            }
        }
    }
    /*else if ([keyPath isEqualToString:@"pan.state"]) {
        if ([object isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = object;
            if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
                if (lastDraggingOffset.y <= 0) {
                    [self handleRefreshReleased];
                }
            }
        }
    }*/
}

- (void)handleVerticalScrollWithScrollView:(UIScrollView *)scrollView {
    //handle vertical glass
    DMSexyTable *tableView = (DMSexyTable *)scrollView;
    [tableView scrollViewDidScroll:scrollView];
}

- (void)handleHorrizontalScrollWithScrollView:(UIScrollView *)scrollView {
    //handle vertical glass
    CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    int index = 0;
    for (DMSexyTable *tableView in self.tableArray) {
        if (ratio > index - 1 && ratio < index + 1) {
            [tableView scrollHorizontalRatio:-ratio + index];
        }
        index++;
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
    for (id tableView in self.tableArray) {
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}


//handle vertical glass
/*CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
 if (scrollView == self.tblViewPerqs)
 [self.tblViewPerqs scrollViewDidScroll:scrollView];
 else if (scrollView == self.tblViewPoints)
 [self.tblViewPoints scrollViewDidScroll:scrollView];
 else if (scrollView == self.tblViewVouchers)
 [self.tblViewVouchers scrollViewDidScroll:scrollView];
 
 //handle horrizontal glass
 if (scrollView == self.tableSwiper) {
 if (ratio > -1 && ratio < 1)
 [self.tblViewPerqs scrollHorizontalRatio:-ratio];
 if (ratio > 0 && ratio < 2)
 [self.tblViewPoints scrollHorizontalRatio:-ratio + 1];
 if (ratio > 1 && ratio < 3)
 [self.tblViewVouchers scrollHorizontalRatio:-ratio + 2];
 }*/

@end
