//
//  ViewController.m
//  XXTableViewReloadViewHolderDemo
//
//  Created by 朱小亮 on 2017/6/1.
//  Copyright © 2017年 朱小亮. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+XXTableViewReloadViewHolder.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [NSMutableArray arrayWithObjects:@1,@2,@3, nil];
    [self.tableView setPlaceHolderViewAction:^(UITableView *tableView){
        self.dataSource = [NSMutableArray arrayWithObjects:@1,@2,@3, nil];
        [tableView reloadData];
    }];
    
    UIView *heard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    heard.backgroundColor = [UIColor blueColor];
    self.tableView.tableHeaderView = heard;
    
    self.tableView.enableShowNet = YES;
    self.tableView.enableShowError = YES;
    
    [self.tableView setNoNetViewAction:^(UITableView *temp){
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] stringValue];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource removeAllObjects];
    [tableView reloadData];
}

@end
