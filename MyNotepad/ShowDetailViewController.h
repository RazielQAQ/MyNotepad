//
//  ShowDetailViewController.h
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MyNote.h"

@interface ShowDetailViewController : UIViewController

@property MyNote *showNote;
@property (weak, nonatomic) IBOutlet UITextView *contentDisplay;
@property (weak, nonatomic) IBOutlet UITextView *createDateDisplay;



@end
