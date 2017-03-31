//
//  GCDAsyncSocket+Extension.m
//  SocketDemo
//
//  Created by IndusGoo on 2017/3/24.
//  Copyright © 2017年 Annie. All rights reserved.
//

#import "GCDAsyncSocket+Extension.h"

@implementation GCDAsyncSocket (Extension)
- (instancetype)writeString:(NSString *)string
{
    [self writeData:[string dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    return self;
}
@end
