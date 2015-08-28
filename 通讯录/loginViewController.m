//
//  loginViewController.m
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD+WJTools.h"

#define UserNameKey @"name"
#define UserPwdKey @"pwd"
#define RemPwdKey @"rem_pwd"


@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UISwitch *rembSwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction;

@end
/*
 1.plist 需要知道文件的名字 只适合NSArray,NSString 等基本数据类型
 2.偏好设置 不需要知道文件的名字 ，小型数据 NSUserDefaults
 3.对象归档 NSKeyedArchiver 必须实现NSCoding 协议方法
 4.core Data 大型数据
 5.sqlite3
 */
@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:2.0];
    // Do any additional setup after loading the view.
    //添加观察者
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdField];
    //在登陆前要获取配置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nameField.text = [defaults valueForKey:UserNameKey];

    self.rembSwitch.on = [defaults boolForKey:RemPwdKey];
    if (self.rembSwitch.isOn) {
        self.pwdField.text = [defaults valueForKey:UserPwdKey];
        self.loginButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textChange{
      self.loginButton.enabled = (self.nameField.text.length && self.pwdField.text.length);
    
    
}


//触屏退出编辑
#pragma mark - Touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touchs = [touches anyObject];
    if (![touchs.view isKindOfClass:[UITextField class]]||![touchs.view isKindOfClass:[UITextView class]]) {
        [self.view endEditing:YES];
    }
}

#pragma mark - Navigation
//跳转前的动作
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //获取目标控制器
    UIViewController *ContactVC = [segue destinationViewController];
    //设置标题（传值）
    ContactVC.title = [NSString stringWithFormat:@"%@的联系人列表",self.nameField.text];
}


- (IBAction)loginAction {
    if (![self.nameField.text isEqualToString:@"li"]) {
        [MBProgressHUD showError:@"账号错误"];
        return;
    }
    if (![self.pwdField.text isEqualToString:@"0822"]){
        [MBProgressHUD showError:@"密码错误"];
        return;
    }
    //启动蒙版（遮盖）
    [MBProgressHUD showMessage:@"努力加载中"];
    //使用GCD模拟跳转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        //根据标识符跳转
        [self performSegueWithIdentifier:@"LoginToContact" sender:nil ];

    });
    //存储登陆数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.nameField.text forKey:UserNameKey];
    [defaults setObject:self.pwdField.text forKey:UserPwdKey];
    [defaults setBool:self.rembSwitch.isOn forKey:RemPwdKey];
    //设置同步
    [defaults synchronize];
    
    

}
@end
