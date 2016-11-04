//
//  CFUserStatistics.m
//  CFDataStatisticsDemo
//
//  Created by wjc on 16/11/3.
//  Copyright © 2016年 CityFire. All rights reserved.
//  统计埋点 把某个页面单元的所有事件ID分成了两类：页面事件ID(PageEventIDs，页面的进出等)、交互事件ID(ControlEventIDs，单击、双击、手势等)。
// 优势： 1.与工程代码基本解耦，避免引入“脏代码”
//       2.即使后期工程代码发生重构，需要修改的仅仅是plist配置表
//       3.维护配置表比维护散落在工程各个角落的代码简单

#import "CFUserStatistics.h"

@implementation CFUserStatistics

+ (void)sendEventToServer:(NSString *)pageID {
    NSLog(@"pageID:%@", pageID);
}

+ (void)sendControlEventToServer:(NSString *)eventID {
    NSLog(@"controlEventID:%@", eventID);
}

@end
