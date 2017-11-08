//
//  NSObject+Calculator.h
//  RACDemo
//
//  Created by tederen on 2017/11/1.
//  Copyright © 2017年 zhiyuehl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Calculator;

@interface NSObject (Calculator)

+ (int)makeCalculators:(void(^)(Calculator *make))calculator;


@end
