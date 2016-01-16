//
//  AddNewController.m
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import "AddNewController.h"

@interface AddNewController ()
@property (weak, nonatomic) IBOutlet UITextField *noteSubject;
@property (weak, nonatomic) IBOutlet UITextView *noteContent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;



@end

@implementation AddNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.doneButton) return;
    if (self.noteSubject.text.length > 0) {
        self.note = [[MyNote alloc] init];
        self.note.subject = self.noteSubject.text;
        self.note.content = self.noteContent.text;
        //NSLog(@"create Date :%@, last Modified: %@", self.note.createDate, self.note.lastModified);
    }
}

@end
