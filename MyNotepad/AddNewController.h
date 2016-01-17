//
//  AddNewController.h
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNote.h"
#import "iflyMSC/IFlyMSC.h"
#include "PopupView.h"

@interface AddNewController : UIViewController<IFlySpeechRecognizerDelegate>

@property MyNote *note;
@property (nonatomic, assign) BOOL isCanceled;

//语音识别结果
@property (nonatomic, strong) NSString * result;

@end
