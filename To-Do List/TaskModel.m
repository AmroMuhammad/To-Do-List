//
//  TaskModel.m
//  To-Do List
//
//  Created by Amr Muhammad on 4/5/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel
- (id)initWithCoder:(NSCoder *)decode{
    self = [super init];
    if (self != nil)
    {
        _taskName = [decode decodeObjectForKey:@"name"];
        _taskDesc = [decode decodeObjectForKey:@"desc"];
        _taskPriority = [decode decodeIntForKey:@"priority"];
        _taskDate = [decode decodeObjectForKey:@"date"];
        _taskStatus = [decode decodeIntForKey:@"status"];
        _dateOfCreation = [decode decodeObjectForKey:@"dateOfCreation"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encode{
    [encode encodeObject:_taskName forKey:@"name"];
    [encode encodeObject:_taskDesc forKey:@"desc"];
    [encode encodeInt:_taskPriority forKey:@"priority"];
    [encode encodeObject:_taskDate forKey:@"date"];
    [encode encodeInt:_taskStatus forKey:@"status"];
    [encode encodeObject:_dateOfCreation forKey:@"dateOfCreation"];
}

@end
