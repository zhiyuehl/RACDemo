//
//  NSObject+Calculator.m
//  RACDemo
//
//  Created by tederen on 2017/11/1.
//  Copyright © 2017年 zhiyuehl. All rights reserved.
//

#import "NSObject+Calculator.h"
#import "Calculator.h"

@implementation NSObject (Calculator)


+ (int)makeCalculators:(void (^)(Calculator *))calculator
{
    Calculator *mgr = [[Calculator alloc]init];
    calculator(mgr);
    
    return mgr.result;
}



@end
