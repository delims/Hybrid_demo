//
//  JSClass.h
//  Hybrid_demo
//
//  Created by delims on 2018/8/2.
//  Copyright © 2018年 com.delims. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSClassDelegate <JSExport>

- (void)buttonClick;
- (void)buttonClick2:(NSString *)arg;
- (void)buttonClick3:(NSString *)arg1 :(NSString*)arg2 :(NSString*)arg3;

@end

@interface JSClass : NSObject<JSClassDelegate>

@end
