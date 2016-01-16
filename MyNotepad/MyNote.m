//
//  MyNote.m
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import "MyNote.h"

@implementation MyNote

- (id)init {
    self = [super init];
    if(self) {
        _createDate = [[NSDate alloc]init];
        _lastModified = [[NSDate alloc] init];
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"noteContent"];
    [aCoder encodeObject:self.subject forKey:@"noteSubject"];
    [aCoder encodeObject:self.createDate forKey:@"createDate"];
    [aCoder encodeObject:self.lastModified forKey:@"lastModified"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        _content = [aDecoder decodeObjectForKey:@"noteContent"];
        _subject = [aDecoder decodeObjectForKey:@"noteSubject"];
        _createDate = [aDecoder decodeObjectForKey:@"createDate"];
        _lastModified = [aDecoder decodeObjectForKey:@"lastModified"];
    }
    return self;
}

@end



