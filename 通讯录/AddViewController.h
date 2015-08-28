//
//  AddViewController.h
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddViewController,ContactModel;
@protocol AddViewControllerDelegate <NSObject>
//方法为弱引用方法
@optional
-(void)addContact:(AddViewController *)addViewController  didAddContact:(ContactModel *)contactModel;

@end


@interface AddViewController : UIViewController
//assgin类型为不可循环调用的属性类型
@property(nonatomic , assign)id<AddViewControllerDelegate>delegate;
@end
