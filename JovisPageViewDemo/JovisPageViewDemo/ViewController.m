//
//  ViewController.m
//  JovisPageViewDemo
//
//  Created by Jovi on 15/11/20.
//  Copyright © 2015年 Jovistudio. All rights reserved.
//

#import "ViewController.h"
#import "JovisPageView.h"

@interface ViewController () <JovisPageViewDelegate>

@end

@implementation ViewController{
    JovisPageView *textPageView;
    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    
    label = [[UILabel alloc]init];
    [label setFrame:CGRectMake(80, 460, 300, 20)];
    [self.view addSubview:label];
    
    textPageView = [[JovisPageView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 400)];
    [textPageView setDelegate:self];
    [textPageView setBackgroundColor:[UIColor whiteColor]];
    
    // tab bar
    [textPageView setShowTabBar:YES];
    [textPageView setTabBarHeight:30];
    [textPageView.tabBar setIndicatorLineHeight:1.0];
    [textPageView.tabBar setIndicatorLineColor:[UIColor blueColor]];
    [textPageView.tabBar setTitleColorForSelected:[UIColor blueColor]];
    
    [textPageView setPageSize:CGSizeMake(textPageView.frame.size.width, textPageView.frame.size.height - textPageView.tabBarHeight)];
    
    [self.view addSubview:textPageView];
    
    UIView *page0 = [[UIView alloc]init];
    [page0 setBackgroundColor:[UIColor colorWithRed:0.2 green:0.91 blue:0.9 alpha:1]];
    UIView *page1 = [[UIView alloc]init];
    [page1 setBackgroundColor:[UIColor colorWithRed:0.5 green:0.3 blue:0.4 alpha:1]];
    UIView *page2 = [[UIView alloc]init];
    [page2 setBackgroundColor:[UIColor colorWithRed:0.6 green:0.1 blue:0.3 alpha:1]];
    UIView *page3 = [[UIView alloc]init];
    [page3 setBackgroundColor:[UIColor colorWithRed:0.16 green:0.41 blue:0.9 alpha:1]];
    UIView *page4 = [[UIView alloc]init];
    [page4 setBackgroundColor:[UIColor colorWithRed:0.16 green:0.0 blue:0.7 alpha:1]];
    [textPageView addPages:@[page0,page1,page2,page3,page4]];
    
    [textPageView setTabBarTitles:@[@"Home",@"Discover",@"Music",@"Movie",@"Other"]];
    
}

- (void)pageView:(JovisPageView *)pageView didSelectedPage:(NSInteger)pageIndex{
    if (pageView == textPageView) {
        NSLog(@"Selected:%ld", pageIndex);
        [label setText:[NSString stringWithFormat:@"selected page %ld", pageIndex]];
        //color effect
        [label setTextColor:pageView.pages[pageView.currentPageIndex].backgroundColor];
        
//        pageView.tabBar.indicatorLineColor = pageView.pages[pageView.currentPageIndex].backgroundColor;
//        pageView.tabBar.titleColorForSelected = pageView.tabBar.indicatorLineColor;
    }
}

@end
