//
//  EditTaskViewController.h
//  To-Do List
//
//  Created by Amr Muhammad on 4/5/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

#import "ViewController.h"
#import "TaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditTaskViewController : ViewController
@property TaskModel *taskRecieved;
@property int comingFrom;

@end

NS_ASSUME_NONNULL_END
