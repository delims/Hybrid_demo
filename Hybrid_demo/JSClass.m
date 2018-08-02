//
//  JSClass.m
//  Hybrid_demo
//
//  Created by delims on 2018/8/2.
//  Copyright © 2018年 com.delims. All rights reserved.
//

#import "JSClass.h"

@implementation JSClass

- (void)buttonClick
{
    NSLog(@"调用了oc的无参方法");
}

- (void)buttonClick2:(NSString *)arg
{
    NSLog(@"%@",arg);
}
- (void)buttonClick3:(NSString *)arg1 :(NSString *)arg2 :(NSString *)arg3
{
    NSLog(@"%@",arg1);
    NSLog(@"%@",arg2);
    NSLog(@"%@",arg3);
}

@end
