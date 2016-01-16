//
//  MainScreenController.h
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewController.h"
#import "MyNote.h"

@interface MainScreenController : UITableViewController


- (IBAction)unwindToList:(UIStoryboardSegue *)segue;


@property NSMutableArray *notes;

@end
