//
//  DMTableSwiperView.h
//  Perq
//
//  Created by Daniel McCarthy on 1/23/14.
//  Copyright (c) 2014 Daniel McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (currentPage)
- (int)currentPage;
@end

@interface DMTableSwiperView : UIScrollView

@property (strong, nonatomic) NSMutableArray *tableArray;

- (id)initWithTableViews:(NSArray *)tableViewsArr tableFrame:(CGRect)tableFrame inViewController:(UIViewController *)viewController;

@end
