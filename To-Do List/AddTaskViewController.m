//
//  AddTaskViewController.m
//  To-Do List
//
//  Created by Amr Muhammad on 4/5/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

#import "AddTaskViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "TaskModel.h"
@interface AddTaskViewController (){
    NSMutableArray *taskArray;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *descText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderDate;
@property TaskModel *task;
@property NSUserDefaults *userDefault;
@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _taskArray = [NSMutableArray new];
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
    _task = [TaskModel new];
    _userDefault = [NSUserDefaults standardUserDefaults];
    if([[[_userDefault dictionaryRepresentation] allKeys] containsObject:@"todoArray"]){
        taskArray = [NSMutableArray new];
        NSData *data = [_userDefault objectForKey:@"todoArray"];
        taskArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        printf("%lu \n",(unsigned long)[taskArray count]);

    }else{
        taskArray = [NSMutableArray new];
        printf("llllllllll");
    }
    

}

-(NSString*) currentDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyy HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(Boolean)checkData{
    if(_nameTxt.text.length != 0 || _descText.text.length != 0){
        return YES;
    }
else{
    return NO;
    }
    return NO;
}

- (IBAction)addTask:(id)sender {
    if([self checkData]){
        [self setTask];
        [self setNotification];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Kindly fill all labels" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

-(void) setNotification{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    [calendar setTimeZone:[NSTimeZone localTimeZone]];

    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone fromDate:_reminderDate.date];



    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
    NSString *textoutput = [NSString stringWithFormat:@"Reminder for Task: %@", _nameTxt.text];
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey:textoutput arguments:nil];
    objNotificationContent.sound = [UNNotificationSound defaultSound];

    /// 4. update application icon badge number
    objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);


    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];


    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ten"
                                                                          content:objNotificationContent trigger:trigger];
    /// 3. schedule localNotification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Local Notification succeeded");
        }
        else {
            NSLog(@"Local Notification failed");
        }
    }];
}

-(void) setTask{
    [_task setTaskName:_nameTxt.text];
    [_task setTaskDesc:_descText.text];
    [_task setTaskPriority:(int) _prioritySegment.selectedSegmentIndex];
    [_task setTaskDate:_reminderDate.date];
    [_task setTaskStatus:0];
    [_task setDateOfCreation:[self currentDate]];
    [self saveToUserDefault];
}

-(void) saveToUserDefault{
    [taskArray addObject:_task];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:taskArray];
    [_userDefault setObject:data forKey:@"todoArray"];
    [_userDefault synchronize];
}

@end
