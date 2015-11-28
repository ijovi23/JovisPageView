//
//  JovisPageView.h
//  JovisPageViewDemo
//
//  Created by Jovi on 15/11/21.
//  Copyright © 2015年 Jovistudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JovisTopTabBar.h"

@class JovisPageView;

@protocol JovisPageViewDelegate <NSObject>

@optional
- (void)pageView:(JovisPageView *)pageView didSelectedPage:(NSInteger)pageIndex;

@end

@interface JovisPageView : UIView

@property (strong, nonatomic) UIScrollView *pagesView;
@property (assign, nonatomic) CGSize pageSize;
@property (strong, nonatomic) NSMutableArray<UIView*> *pages;
@property (assign, nonatomic) NSInteger currentPageIndex;

@property (assign, nonatomic) BOOL showTabBar;
@property (strong, nonatomic) JovisTopTabBar *tabBar;
@property (strong, nonatomic) NSArray<NSString *> *tabBarTitles;
@property (assign, nonatomic) CGFloat tabBarHeight;

@property (weak, nonatomic) id<JovisPageViewDelegate> delegate;

- (void)insertPage:(UIView *)page atIndex:(NSInteger)index;
- (void)addPages:(NSArray<UIView *> *)pages;
- (void)updatePagesView;
- (void)scrollToPage:(NSInteger)pageIndex animated:(BOOL)animated;

@end
