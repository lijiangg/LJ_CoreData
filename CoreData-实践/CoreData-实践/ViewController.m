//
//  ViewController.m
//  CoreData-实践
//
//  Created by yurong on 2017/11/23.
//  Copyright © 2017年 yurong. All rights reserved.
//

#import "ViewController.h"
#import "Person+CoreDataClass.h"
#import "AppDelegate.h"
#import "AddViewController.h"
#import "UpdateViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//声明CoreData的上下文
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据
@property(copy,nonatomic)NSArray *dataArray;
//选中哪一行
@property(strong,nonatomic)NSIndexPath *selectedIndexPath;
@end

@implementation ViewController
#pragma mark -上下文
-(NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        _managedObjectContext = app.persistentContainer.viewContext;
    }
    return _managedObjectContext;
}
#pragma mark -逆向传值
-(IBAction)getSegue:(UIStoryboardSegue *)segue{
    if ([segue.identifier isEqualToString:@"addBack"]) {
        AddViewController *add = segue.sourceViewController;
        [self addDataWithDic:@{@"name":add.nameField.text,@"address":add.addressField.text}];
    }else if ([segue.identifier isEqualToString:@"updateBack"]){
        UpdateViewController *update = segue.sourceViewController;
        [self updateWithDic:@{@"name":update.nameField.text,@"address":update.addressField.text}];
    }
}
#pragma mark -add
-(void)addDataWithDic:(NSDictionary *)dic{
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    person.name = dic[@"name"];
    person.address = dic[@"address"];
    NSError *inserError;
    [self.managedObjectContext save:&inserError];
    if (!inserError) {
        [self updateDataArray];
    }
}
#pragma mark -delete
-(void)delete{
    for (Person *person in _dataArray) {
        [self.managedObjectContext deleteObject:person];
    }
    NSError *error;
    [self.managedObjectContext save:&error];
    if (!error) {
        [self updateDataArray];
    }
    
    
}
#pragma mark -update
-(void)updateWithDic:(NSDictionary *)dic{
    Person *person = _dataArray[_selectedIndexPath.row];
    person.name = dic[@"name"];
    person.address = dic[@"address"];
    NSError *error;
    
    [self.managedObjectContext save:&error];
    if (!error) {
        [self updateDataArray];
    }
}
#pragma mark -read 数据
-(void)updateDataArray{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Person"];
    NSError *error;
    _dataArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    //刷新tableview
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self updateDataArray];
    
}

#pragma mark -UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aaa"];
    Person *person = _dataArray[indexPath.row];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.address;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath = indexPath;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -editBarButton
- (IBAction)editSelecter:(UIBarButtonItem *)sender {
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.editing = !self.tableView.editing;
        if (self.tableView.editing) {
            //选中状态
            sender.title = @"确定";
        }else{
            //非选中状态
            sender.title = @"编辑";
            [self delete];
        }
    }];
    
}


@end
