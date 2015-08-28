//
//  ContactViewController.m
//  通讯录
//
//  Created by lijunping on 15/6/11.
//  Copyright (c) 2015年 lijunping. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactModel.h"
#import "AddViewController.h"
#import "EditViewController.h"
#import "ChineseString.h"
//设置文件储存路径


@interface ContactViewController ()<AddViewControllerDelegate,EditViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backAction:(id)sender;
//不能用weak，因为在数组传值的时候，操作结束后NSMutableArray任然不能释放
@property (nonatomic ,strong)NSMutableArray *contactArry;
@property(nonatomic,strong)NSMutableArray *indexArray;
//设置每个section下的cell内容
@property (nonatomic,strong)NSMutableArray *letterResultArr;
@property (nonatomic ,strong)NSMutableArray *nameArr;
@property (strong,nonatomic)UILabel *lab;
@end

@implementation ContactViewController
@synthesize contactArry = _contactArry;
@synthesize indexArray = _indexArray;
@synthesize letterResultArr = _letterResultArr;
//加载数据
-(NSMutableArray *)contactArry{
    if (!_contactArry) {
        //解析路径 NSKeyedUnarchiver
        _contactArry = [NSKeyedUnarchiver unarchiveObjectWithFile:ContactFilePath];
        
        if (_contactArry == nil) {
            _contactArry = [NSMutableArray array];
        }


    }
    return _contactArry;
}


-(NSMutableArray *)indexArray{
    if (!_indexArray) {

        [self reloadIndexArrayArrDataWithArraty:self.contactArry];
        if (_indexArray == nil) {
            _indexArray = [NSMutableArray array];
        }
    }

    return _indexArray;
}
-(NSMutableArray *)letterResultArr{
    if (!_letterResultArr) {
        [self reloadLetterResultArrDataWithArraty:self.contactArry];
        if (_letterResultArr == nil) {
            _letterResultArr = [NSMutableArray array];
        }
    }
    
    return _letterResultArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - Data
- (void)reloadLetterResultArrDataWithArraty:(NSArray *)array
{
//    [self.letterResultArr removeAllObjects];
    [_letterResultArr removeAllObjects];
    
    _nameArr = [NSMutableArray array];
    for (int i = 0; i< array.count; i ++) {
        NSString *str = [[[array objectAtIndex:i] name] stringByAppendingFormat:@"_%@",[[array objectAtIndex:i] phone]];
        [_nameArr addObject:str];
        
    }
    
    _letterResultArr = [ChineseString LetterSortArray:[self nameArr]];
   
}

-(void)reloadIndexArrayArrDataWithArraty:(NSArray *)array
{
//    [self.indexArray removeAllObjects];
    [_indexArray removeAllObjects];
    
    _nameArr = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        [_nameArr addObject:[[array objectAtIndex:i] name]];
    }
    
    _indexArray = [ChineseString IndexArray:[self nameArr]];
}

- (void)removeModelWith:(NSArray *)array setNewModel:(ContactModel *)model
{
    for (int i = 0 ; i<self.contactArry.count; i ++)
    {
        NSString *str = [[[self.contactArry objectAtIndex:i] name] stringByAppendingFormat:@"_%@",[[self.contactArry objectAtIndex:i] phone]];
        if ([[[array objectAtIndex:0] stringByAppendingFormat:@"_%@",[array objectAtIndex:1]] isEqualToString:str])
        {
            [self.contactArry removeObjectAtIndex:i];
            [self.contactArry insertObject:model atIndex:i];
        }
    }
    
 

}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.indexArray objectAtIndex:section];
    
    return key;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    _lab =
    ({
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        lab.backgroundColor = UIColorFromRGB16(0xcccccc);
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = [self.indexArray objectAtIndex:section];
        lab.textColor = [UIColor whiteColor];
        lab;
    });
    
    return _lab;
}
#pragma mark -设置右方表格的索引数组

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.indexArray;

}
//选中的section
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.indexArray count];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self.letterResultArr objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndexPath = indexPath;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
//   进行初始化
    ContactModel *contactModels = [[ContactModel alloc]init];
    //因为我们需要从数组中取数据
//    ContactModel *contactModels = self.contactArry[indexPath.row];
    
    NSArray *titleArr = [[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] componentsSeparatedByString:@"_"];
    
    cell.textLabel.text = [titleArr objectAtIndex:0];
    
    cell.detailTextLabel.text = [titleArr objectAtIndex:1];
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell %@",cell.textLabel.text);
}


#pragma  mark - AddViewControllerDelegate

-(void)addContact:(AddViewController *)addViewController
    didAddContact:(ContactModel *)contactModel
{
    //添加数据模型
    [self.contactArry addObject:contactModel];
    
    [self reloadIndexArrayArrDataWithArraty:self.contactArry];
    
    [self reloadLetterResultArrDataWithArraty:self.contactArry];
    
    NSLog(@"cc %@",self.contactArry);
    
    //归档，凡是需要对数据进行操作的地方均需要归档
    [NSKeyedArchiver archiveRootObject:self.contactArry
                                toFile:ContactFilePath];
    
      //更新视图数据
    [self.tableView reloadData];
    
}
#pragma  mark - editViewControllerDelegate
-(void)editViewControl:(EditViewController *)ediView
          didEditModel:(ContactModel *)model
             indexPath:(NSIndexPath *)path
             selectArr:(NSArray *)arr
{
    [self removeModelWith:arr setNewModel:model];

    
    [NSKeyedArchiver archiveRootObject:self.contactArry
                                toFile:ContactFilePath];
    
    [self reloadIndexArrayArrDataWithArraty:self.contactArry];
    
    [self reloadLetterResultArrDataWithArraty:self.contactArry];
    
    [self.tableView reloadData];
}

#pragma  mark - UITableView delegate 删除选择行

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据模型
        [[self.letterResultArr objectAtIndex:indexPath.section]removeObjectAtIndex:indexPath.row];
        [self.contactArry removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationTop];
        
        
        [NSKeyedArchiver archiveRootObject:self.contactArry
                                    toFile:ContactFilePath];
        [self letterResultArr];
    }
}

#pragma mark - Navigation

//跳转前的准备,设置代理对象
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id vc = segue.destinationViewController;
    
    if ([vc isKindOfClass:[AddViewController class]])
    {
        AddViewController *addVC = vc;
        
        addVC.delegate = self;
    }
    else if ([vc isKindOfClass:[EditViewController class]])
    {
        EditViewController *editVC = vc;

        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        NSArray *selectArray = [[[self.letterResultArr objectAtIndex:path.section]objectAtIndex:path.row] componentsSeparatedByString:@"_"];

        editVC.selectPath = path;
        
        [editVC setSelectArr:selectArray];
        
        editVC.delegate = self;
    }
    
}


- (IBAction)backAction:(id)sender {
    //在iOS8.0以后，UIAlertController代替了UIAlertView 和 UIActionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否注销" message:@"返回登陆界面" preferredStyle: UIAlertControllerStyleActionSheet];
    //添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    //弹出
   
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
@end
