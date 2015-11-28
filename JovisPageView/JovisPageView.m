//
//  JovisPageView.m
//  JovisPageViewDemo
//
//  Created by Jovi on 15/11/21.
//  Copyright © 2015年 Jovistudio. All rights reserved.
//

#import "JovisPageView.h"

@interface JovisPageView () <UIScrollViewDelegate, JovisTopTabBarDelegate>

@end

@implementation JovisPageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initConfig{
    _pages = [NSMutableArray array];
    _showTabBar = YES;
}

- (void)initUI{
    [self initConfig];
    if (!_pagesView) {
        _pagesView = [[UIScrollView alloc]init];
        [self addSubview:_pagesView];
    }
    [_pagesView setDirectionalLockEnabled:YES];
    [_pagesView setPagingEnabled:YES];
    [_pagesView setBackgroundColor:[UIColor clearColor]];
    [_pagesView setShowsHorizontalScrollIndicator:NO];
    [_pagesView setShowsVerticalScrollIndicator:NO];
    [_pagesView setDelegate:self];
    
    if (_showTabBar) {
        if (!_tabBar) {
            _tabBar = [[JovisTopTabBar alloc]init];
            [self addSubview:_tabBar];
        }
        [_tabBar setDelegate:self];
    }else{
        if (_tabBar) {
            [_tabBar removeFromSuperview];
        }
    }
    
    [self layoutUI];
}

- (void)updatePagesView{
    if (CGSizeEqualToSize(_pageSize, CGSizeZero)) {
        _pageSize = _pagesView.frame.size;
    }
    NSInteger pagesCount = _pages.count;
    [_pagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < pagesCount; i++) {
        UIView *page = [_pages objectAtIndex:i];
        CGRect pageFrame = page.frame;
        pageFrame.origin = CGPointMake(_pageSize.width * (CGFloat)i, 0);
        pageFrame.size = _pageSize;
        [page setFrame:pageFrame];
        [_pagesView addSubview:page];
    }
    [_pagesView setContentSize:CGSizeMake(_pageSize.width * (CGFloat)pagesCount, _pageSize.height)];
    CGFloat insetTB = (CGRectGetHeight(_pagesView.frame) - _pageSize.height) / 2.0;
    CGFloat insetLR = (CGRectGetWidth(_pagesView.frame) - _pageSize.width) / 2.0;
    [_pagesView setContentInset:UIEdgeInsetsMake(insetTB, insetLR, insetTB, insetLR)];
    
}

- (void)layoutUI{
    if (_showTabBar) {
        [_tabBar setFrame:CGRectMake(0, 0, self.frame.size.width, _tabBarHeight)];
        [_pagesView setFrame:CGRectMake(0, _tabBarHeight, self.frame.size.width, self.frame.size.height - _tabBarHeight)];
    }else{
        [_pagesView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layoutUI];
}

- (void)insertPage:(UIView *)page atIndex:(NSInteger)index{
    [_pages insertObject:page atIndex:index];
    [self updatePagesView];
}

- (void)addPages:(NSArray<UIView *> *)pages{
    [_pages addObjectsFromArray:pages];
    [self updatePagesView];
}

- (void)scrollToPage:(NSInteger)pageIndex animated:(BOOL)animated{
    if (pageIndex >= _pages.count) {
        pageIndex = _pages.count - 1;
    }
    CGFloat targetX = _pageSize.width * (CGFloat)pageIndex;
    [_pagesView setContentOffset:CGPointMake(targetX, 0) animated:animated];
    _currentPageIndex = pageIndex;
    
    if (_tabBar && _tabBar.selectedTabIndex != _currentPageIndex) {
        [_tabBar selectTabWithIndex:_currentPageIndex];
    }
}

- (void)setTabBarTitles:(NSArray<NSString *> *)tabBarTitles{
    _tabBarTitles = tabBarTitles;
    [_tabBar setTitleArray:[NSMutableArray arrayWithArray:tabBarTitles]];
    [_tabBar initializeUI];
    if (tabBarTitles.count) {
        [_tabBar selectTabWithIndex:0];
    }
}

- (void)setShowTabBar:(BOOL)showTabBar{
    _showTabBar = showTabBar;
    [self layoutUI];
}

- (void)setTabBarHeight:(CGFloat)tabBarHeight{
    _tabBarHeight = tabBarHeight;
    [self layoutUI];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _pagesView) {
        NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        _currentPageIndex = index;
        if (_tabBar) {
            [_tabBar selectTabWithIndex:index];
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(pageView:didSelectedPage:)]) {
                [_delegate pageView:self didSelectedPage:_currentPageIndex];
            }
        }
    }
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//    if (_delegate && [_delegate respondsToSelector:@selector(pageView:didSelectedPage:)]) {
//        [_delegate pageView:self didSelectedPage:_currentPageIndex];
//    }
//}

#pragma mark JovisTopTabBarDelegate

- (void)topTabBar:(JovisTopTabBar *)topTabBar didSelectTabIndex:(NSInteger)index{
    if (index != _currentPageIndex) {
        [self scrollToPage:index animated:YES];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(pageView:didSelectedPage:)]) {
        [_delegate pageView:self didSelectedPage:_currentPageIndex];
    }
}

@end
