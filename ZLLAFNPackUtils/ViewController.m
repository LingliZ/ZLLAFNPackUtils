//
//  ViewController.m
//  ZLLAFNPackUtils
//
//  Created by 张伶俐 on 2017/6/24.
//  Copyright © 2017年 张伶俐. All rights reserved.
//

#import "ViewController.h"
#import "ZLLAFNPackUtils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self get];
    [self post];
    [self downLoad];
    [self upLoad];
}

-(void)upLoad
{
    [[ZLLAFNPackUtils shareUtils] uploadWithUrlString:@"http://120.25.226.186:32812/upload" parameters:nil fileInfo:@{@"filePath":@"/Users/zhanglingli/Desktop/Snip20170622_14.png"} progress:^(NSProgress *progress) {
        
    } success:^(id obj) {
        NSLog(@"====%@==",obj);
    } failur:^(NSError *error) {
        NSLog(@"=====%@===",error);
    }];
    
}

-(void)downLoad
{
    
    [[ZLLAFNPackUtils shareUtils] downloadWithUrlString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" filePath:nil progress:^(NSProgress *progress) {
        NSLog(@"+++++++%@---------+++",progress);
    } success:^(NSURL *fileURL) {
        NSLog(@"+++++%@+++++++++++",fileURL);
    } failur:^(NSError *error) {
        NSLog(@"+++++++%@+++++++++",error);
    }];
}

-(void)post
{
    NSDictionary *params = @{
                             @"username":@"520it",
                             @"pwd":@"520it"
                             };
    [[ZLLAFNPackUtils shareUtils] Post:@"http://120.25.226.186:32812/login" parameters:params success:^(id obj) {
        NSLog(@"%@",obj);
    } failur:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)get
{
    NSDictionary *params = @{
                             @"username":@"520it",
                             @"pwd":@"520it"
                             };
    [[ZLLAFNPackUtils shareUtils] Get:@"http://120.25.226.186:32812/login" parameters:params progerss:^(NSProgress *progress) {
        NSLog(@"%@",progress);
    } success:^(id obj) {
        NSLog(@"%@",obj);
    } failur:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
