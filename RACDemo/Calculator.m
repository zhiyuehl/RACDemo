//
//  Calculator.m
//  RACDemo
//
//  Created by tederen on 2017/11/1.
//  Copyright © 2017年 zhiyuehl. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator


- (Calculator *(^)(int))add
{
    return ^Calculator *(int value) {
        _result += value;
        return self;
    };
}





@end
