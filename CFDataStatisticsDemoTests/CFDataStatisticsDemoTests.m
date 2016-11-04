//
//  CFDataStatisticsDemoTests.m
//  CFDataStatisticsDemoTests
//
//  Created by wjc on 16/11/3.
//  Copyright © 2016年 CityFire. All rights reserved.
//  测试情况：一种情况是基于plist列表去校验代码，这里就要反过来，根据代码去校验plist是否有缺失。但问题来了，一个项目中响应函数往往是非常多的，并不是任何响应函数都需要埋点。需要埋点的响应函数与其他响应函数并没有区别。
//  一中是如果代码中新增了响应事件并且该响应事件是在PM要求的埋点列表中，但是plist有可能会漏掉该事件。这种情况是比较棘手的。对于这种情况，一种方式是加强code review避免忘记往配置表中添加埋点；另一种方式是：要求埋点响应函数的方法名中包含约定的字符串，比如收藏事件的方法名为onFavBtnPressed_UA:表示这个事件是需要埋点的。然后在单元测试中使用运行时API class_copyMethodList取出标记了_UA的所有函数，随后到plist中校验是否存在。不存在则表示测试用例不通过，提示开发人员校验。

#import <XCTest/XCTest.h>

@interface CFDataStatisticsDemoTests : XCTestCase

@end

@implementation CFDataStatisticsDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testIfUserStaticsConfigPlistValid {
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    XCTAssertNotNil(configDict, @"CFGlobalUserStatisticsConfig.plist加载失效");
    [configDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        XCTAssert([obj isKindOfClass:[NSDictionary class]], @"plist文件结构可能已经改变，请确认");
        NSString *targetPageName = key;
        Class pageClass = NSClassFromString(targetPageName);
        id pageInstance = [[pageClass alloc] init];
        
        // 一个pageDict对应一个页面，存放pageID,所有的action对应的eventID
        NSDictionary *pageDict = (NSDictionary *)obj;
        
        // 页面配置信息
        NSDictionary *pageEventIDDict = pageDict[@"PageEventIDs"];
        
        // 交互配置信息
        NSDictionary *controlEventIDDict = pageDict[@"ControlEventIDs"];
        
        XCTAssert(pageEventIDDict, @"plist文件未包含PageID字段或者该字段值为空");
        XCTAssert(controlEventIDDict, @"plist文件未包含EventIDs字段或者该字段值为空");
        
        [pageEventIDDict enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            XCTAssert([value isKindOfClass:[NSString class]], @"plist文件结构可能已经改变，请确认");
            XCTAssertNotNil(value, @"EVENT_ID为空，请确认");
        }];
        
        [controlEventIDDict enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            XCTAssert([value isKindOfClass:[NSString class]], @"plist文件结构可能已经改变，请确认");
            NSString *actionName = key;
            SEL actionSel = NSSelectorFromString(actionName);
            XCTAssert([pageInstance respondsToSelector:actionSel], @"代码与plist文件函数不匹配，请确认：-[%@ %@]", targetPageName, actionName);
            
            //EVENT_ID不能为空
            XCTAssertNotNil(value, @"EVENT_ID为空，请确认");
        }];

    }];
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CFGlobalUserStatisticsConfig" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
