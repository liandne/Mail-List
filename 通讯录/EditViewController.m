//
//  EditViewController.m
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import "EditViewController.h"
#import "ContactViewController.h"
@interface EditViewController ()
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)editAction:(id)sender;

@end

@implementation EditViewController
@synthesize selectArr = _selectArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.nameField.text = self.contact.name;
//    self.phoneField.text = self.contact.phone;
    
    self.nameField.text = [_selectArr objectAtIndex:0];
    self.phoneField.text = [_selectArr objectAtIndex:1];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneField];
}
-(void)textChange{
    
    self.saveButton.enabled = (self.nameField.text.length && self.phoneField.text.length);
    
}
#pragma mark - UITouch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touchs = [touches anyObject];
    if (![touchs.view isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setSelectArr:(NSArray *)selectArr
{
    _selectArr  = [NSArray arrayWithArray:selectArr];
    NSLog(@"sel %@",_selectArr);
}

- (IBAction)editAction:(UIBarButtonItem *)sender {
    if (self.nameField.enabled) {
        self.nameField.enabled = NO;
        self.phoneField.enabled = NO;
        [self.view endEditing:YES];
        self.saveButton.hidden = YES;
        sender.title = @"编辑";
        //还原数据
        
        self.nameField.text = [_selectArr objectAtIndex:0];
        self.phoneField.text = [_selectArr objectAtIndex:1];

        
    }else{
        self.nameField.enabled = YES;
        self.phoneField.enabled = YES;
        [self.view endEditing:YES];
        self.saveButton.hidden = NO;
        sender.title = @"取消";

    }
    
}
- (IBAction)saveAction:(id)sender {
    //关闭视图控制器
    [self.navigationController popViewControllerAnimated:YES];
    //保存数据
    if ([self.delegate respondsToSelector:@selector(editViewControl:didEditModel:indexPath:selectArr:)]) {
        
        self.contact = [[ContactModel alloc]init];
        self.contact.name = self.nameField.text;
        self.contact.phone = self.phoneField.text;
        [self.delegate editViewControl:self
                          didEditModel:self.contact
                             indexPath:self.selectPath
                             selectArr:_selectArr];
    }
    
}
@end
