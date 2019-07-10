//
//  MyDDLogFormatter.h
//  DTH Service App
//
//  Created by yesdgq on 2018/11/16.
//  Copyright © 2018 yesdgq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDDLogFormatter : NSObject <DDLogFormatter>

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
