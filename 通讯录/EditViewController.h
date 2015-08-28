//
//  EditViewController.h
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
#import "ContactViewController.h"
//以class类型是为了防止互相传值
@class ContactModel,EditViewController;
@protocol EditViewControllerDelegate <NSObject>

@optional
-(void)editViewControl:(EditViewController *)ediView
          didEditModel:(ContactModel *)model
             indexPath:(NSIndexPath *)path
             selectArr:(NSArray *)arr;

@end
@interface EditViewController : UIViewController
@property(nonatomic,assign)id<EditViewControllerDelegate>delegate;
@property(nonatomic ,strong)ContactModel *contact;
@property (nonatomic ,strong)NSIndexPath *selectPath;
@property (nonatomic ,strong)NSArray *selectArr;

-(void)setSelectArr:(NSArray *)selectArr;
@end
