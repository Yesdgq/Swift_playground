//
//  MyDDLogFormatter.m
//  DTH Service App
//
//  Created by yesdgq on 2018/11/16.
//  Copyright © 2018 yesdgq. All rights reserved.
//

#import "MyDDLogFormatter.h"
#import <libkern/OSAtomic.h>

#define DATE_STRING @"YYYY-MM-dd HH:mm:ss:SS"

@implementation MyDDLogFormatter
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

+ (instancetype)sharedInstance {
    static MyDDLogFormatter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (id)init {
    if((self = [super init])) {
        threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
        [threadUnsafeDateFormatter setDateFormat:DATE_STRING];
    }
    return self;
}


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error"; break;
        case DDLogFlagWarning  : logLevel = @"Warning"; break;
        case DDLogFlagInfo     : logLevel = @"Info"; break;
        case DDLogFlagDebug    : logLevel = @"Debug"; break;
        default                : logLevel = @"Verbose"; break;
    }
    
    NSString *dateAndTime = [threadUnsafeDateFormatter stringFromDate:(logMessage->_timestamp)];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"[%@] %@ | %@", dateAndTime, logLevel, logMsg];
}

- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:DATE_STRING];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyDDLogFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:DATE_STRING];
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end
