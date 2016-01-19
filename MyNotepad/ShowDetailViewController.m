//
//  ShowDetailViewController.m
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import "ShowDetailViewController.h"

@interface ShowDetailViewController ()

@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.showNote != nil) {
        self.title = self.showNote.subject;
        NSDateFormatter *ndf = [[NSDateFormatter alloc]init];
        [ndf setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        NSString *time = [ndf stringFromDate:self.showNote.createDate];
        
        //显示选中笔记的详细信息
        self.createDateDisplay.text = time;
        self.contentDisplay.text = self.showNote.content;
        
        self.createDateDisplay.editable = false;
        self.contentDisplay.editable = false;
        
        self.createDateDisplay.textAlignment = NSTextAlignmentCenter;
               
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
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

@end
