//
//  TaskModel.h
//  To-Do List
//
//  Created by Amr Muhammad on 4/5/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : NSObject
@property NSString *taskName;
@property NSString *taskDesc;
@property int taskPriority;
@property NSDate *taskDate;
@property int taskStatus;
@property NSString *dateOfCreation;

- (void) encodeWithCoder : (NSCoder *)encode ;
- (id) initWithCoder : (NSCoder *)decode;

@end

NS_ASSUME_NONNULL_END
