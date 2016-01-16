//
//  MyNote.h
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNote : NSObject<NSCoding>

@property NSString *content;
@property NSString *subject;
@property (readonly)NSDate *createDate;
@property NSDate *lastModified;

@end
