//
//  CFUserStatistics.h
//  CFDataStatisticsDemo
//
//  Created by wjc on 16/11/3.
//  Copyright © 2016年 CityFire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFUserStatistics : NSObject

+ (void)sendEventToServer:(NSString *)pageID;

+ (void)sendControlEventToServer:(NSString *)eventID;

@end
