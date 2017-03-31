//
//  ViewController.m
//  ClientSocketDemo
//
//  Created by IndusGoo on 2017/3/24.
//  Copyright © 2017年 Annie. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncSocket+Extension.h"
@interface ViewController ()<GCDAsyncSocketDelegate,UITableViewDataSource>
@property(nonatomic,strong) GCDAsyncSocket * socket;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSMutableArray * arr;
@end

@implementation ViewController
- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    NSError * error = nil;
    [self.socket connectToHost:@"192.168.2.106" onPort:5538 error:&error];
    if (!error) {
        NSLog(@"连接服务器端口成功");
    }
    else{
        NSLog(@"连接失败");
    }
    // socket开始监听数据 如果不写则没有反应
    [self.socket readDataWithTimeout:-1 tag:0];
    self.tableView.dataSource = self;
}
//-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
//    NSLog(@"连接主机成功--------delegate");
//    // 监听数据
//    [self.socket readDataWithTimeout:-1 tag:0];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.arr[indexPath.row];
    }
    return cell;
}
- (IBAction)buttonClick:(id)sender {
    [self.socket writeString:self.textField.text];
//    [self.tableView reloadData];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self.arr addObject:string];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //回到主线程刷新页面.
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self.tableView reloadData];
//    }];
    //监听数据接收
    [self.socket readDataWithTimeout:-1 tag:0];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
