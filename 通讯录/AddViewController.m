//
//  AddViewController.m
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import "AddViewController.h"
#import "ContactModel.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *NameField;
@property (weak, nonatomic) IBOutlet UITextField *telField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)addAction;
- (IBAction)backAction:(id)sender;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangs) name:UITextFieldTextDidChangeNotification object:self.NameField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangs) name:UITextFieldTextDidChangeNotification object:self.telField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //让姓名文本框为第一响应者
    [self.NameField becomeFirstResponder];
    
}
-(void)textChangs{
    
    self.addButton.enabled = (self.NameField.text.length && self.telField.text.length);
    
}

#pragma mark - Touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touchs = [touches anyObject];
    if (![touchs.view isKindOfClass:[UITextField class]]||![touchs.view isKindOfClass:[UITextView class]]) {
        [self.view endEditing:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//添加数据
- (IBAction)addAction {
    //关闭视图控制器
    [self.navigationController popViewControllerAnimated:YES];
    
    //判断，如果他的代理对象响应了我们的协议方法则进行传值
    if ([self.delegate respondsToSelector:@selector(addContact:didAddContact:)]) {
        ContactModel *contactModels = [[ContactModel alloc]init];
        contactModels.name = self.NameField.text;
        contactModels.phone = self.telField.text;
        NSLog(@"aa  %@",contactModels.name);
        NSLog(@"bb  %@",contactModels.phone);
        [self.delegate addContact:self didAddContact:contactModels];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
