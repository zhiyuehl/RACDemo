//
//  Calculator.h
//  RACDemo
//
//  Created by tederen on 2017/11/1.
//  Copyright © 2017年 zhiyuehl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject



@property(nonatomic,assign) int result;


//加法
- (Calculator *(^)(int))add;



@end
 
