//
//  UIViewController+UserStatistics.m
//  CFDataStatisticsDemo
//
//  Created by wjc on 16/11/3.
//  Copyright © 2016年 CityFire. All rights reserved.
//

#import "UIViewController+UserStatistics.h"
#import "CFHookUtility.h"
#import "CFUserStatistics.h"

@implementation UIViewController (UserStatistics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(swiz_viewWillAppear:);
        [CFHookUtility swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
        
        SEL originalSelector2 = @selector(viewWillDisappear:);
        SEL swizzledSelector2 = @selector(swiz_viewWillDisappear:);
        [CFHookUtility swizzlingInClass:[self class] originalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
    });
}

#pragma mark - Method Swizzling
- (void)swiz_viewWillAppear:(BOOL)animated {
    // 插入需要执行的代码
    [self inject_viewWillApper];
    NSLog(@"我在%@类viewWillAppear执行前偷偷插入了一段代码", NSStringFromClass([self class]));
    // 不能干扰原来的代码流程，插入代码结束后要让本来该执行的代码继续执行
    [self swiz_viewWillAppear:animated];
}

- (void)swiz_viewWillDisappear:(BOOL)animated {
    [self inject_viewWillDisappear];
    [self swiz_viewWillDisappear:animated];
}

// 利用hook 统计所有页面的停留时长
- (void)inject_viewWillApper {
    NSString *pageID = [self pageEventID:YES];
    if (pageID) {
        [CFUserStatistics sendEventToServer:pageID];
    }
}

- (void)inject_viewWillDisappear {
    NSString *pageID = [self pageEventID:NO];
    if (pageID) {
        [CFUserStatistics sendEventToServer:pageID];
    }
}

- (NSString *)pageEventID:(BOOL)bEnterPage
{
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
//    NSString *pageEventID = nil;
//    if ([selfClassName isEqualToString:@"HomeViewController"]) {
//        pageEventID = bEnterPage ? @"EVENT_HOME_ENTER_PAGE" : @"EVENT_HOME_LEAVE_PAGE";
//    } else if ([selfClassName isEqualToString:@"DetailViewController"]) {
//        pageEventID = bEnterPage ? @"EVENT_DETAIL_ENTER_PAGE" : @"EVENT_DETAIL_LEAVE_PAGE";
//    }
    return configDict[selfClassName][@"PageEventIDs"][bEnterPage ? @"Enter" : @"Leave"];
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CFGlobalUserStatisticsConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

@end
