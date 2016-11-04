//
//  UIControl+UserStatistics.m
//  CFDataStatisticsDemo
//
//  Created by wjc on 16/11/3.
//  Copyright © 2016年 CityFire. All rights reserved.
//  

#import "UIControl+UserStatistics.h"
#import "CFHookUtility.h"
#import "CFUserStatistics.h"

@implementation UIControl (UserStatistics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(swiz_sendAction:to:forEvent:);
        [CFHookUtility swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

#pragma mark - Method Swizzling
- (void)swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    // 插入埋点代码
    [self performUserStastisticsAction:action to:target forEvent:event];
    [self swiz_sendAction:action to:target forEvent:event];
}

- (void)performUserStastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSLog(@"\n***hook success.\n[1]action:%@\n[2]target:%@ \n[3]event:%ld", NSStringFromSelector(action), target, (long)event);
    NSString *actionString = NSStringFromSelector(action);// 获取SEL string
    NSString *targetName = NSStringFromClass([target class]);// viewController name
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *eventID = configDict[targetName][@"ControlEventIDs"][actionString];
    [CFUserStatistics sendControlEventToServer:eventID];
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CFGlobalUserStatisticsConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

@end
