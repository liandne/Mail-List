//
//  ContactViewController.h
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ContactFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"contact.data"]

@interface ContactViewController : UITableViewController
@property(nonatomic,assign)BOOL clearr;
@property (readonly ,nonatomic)NSIndexPath *selectIndexPath;

@end
