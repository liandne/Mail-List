//
//  ContactModel.m
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
/*
    将某个对象写入文件时候会调用
    在这个方法中说清楚哪些属性需要储存
 */
-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.phone forKey:@"phone"];
}
/*
    解析对象（读取数据）会调用这个方法
    需要解析哪些对象
 */
-(id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
    }
    return self;
}
@end
