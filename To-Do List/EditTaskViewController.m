//
//  EditTaskViewController.m
//  To-Do List
//
//  Created by Amr Muhammad on 4/5/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

#import "EditTaskViewController.h"
#import "TaskModel.h"
#import <UserNotifications/UserNotifications.h>


@interface EditTaskViewController (){
    NSMutableArray *taskArray;
    Boolean isSave;
    int rowSelected;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *descTxt;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateCreated;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property TaskModel *task;
@property NSUserDefaults *userDefault;
@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isSave = false;
    _task = [TaskModel new];
    _userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [_userDefault objectForKey:@"todoArray"];
    taskArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    _datePicker.userInteractionEnabled = NO;
    [self indexOfRecievedTask];
    [self setData];
}

-(void) setData{
    _nameTxt.text = [[taskArray objectAtIndex:rowSelected] taskName];
    _descTxt.text = [[taskArray objectAtIndex:rowSelected] taskDesc];
    _prioritySegment.selectedSegmentIndex = [[taskArray objectAtIndex:rowSelected] taskPriority];
    _datePicker.date = [[taskArray objectAtIndex:rowSelected] taskDate];
    _dateCreated.text = [[taskArray objectAtIndex:rowSelected] dateOfCreation];
    if(_comingFrom ==1){
        [_statusSegment removeSegmentAtIndex:0 animated:YES];
        _statusSegment.selectedSegmentIndex = [[taskArray objectAtIndex:rowSelected] taskStatus]-1;
    }else if(_comingFrom ==2){
        _statusSegment.hidden = YES;
    }else{
        _statusSegment.selectedSegmentIndex = [[taskArray objectAtIndex:rowSelected] taskStatus];
    }
}
- (IBAction)editClicked:(id)sender {
    if(isSave){
        [self addTask];
    }else{
        isSave = true;
        [sender setTitle:@"Save" forState:UIControlStateNormal];
        _nameTxt.enabled = YES;
        _descTxt.enabled = YES;
        _prioritySegment.enabled = YES;
        _statusSegment.enabled = YES;
        _datePicker.userInteractionEnabled = YES;
    }
    
}

-(void) indexOfRecievedTask{
    for(int i=0;i<taskArray.count;i++){
        if([[[taskArray objectAtIndex:i] dateOfCreation] isEqualToString:[_taskRecieved dateOfCreation]] ){
            rowSelected = i;
            break;
        }else{
            rowSelected = -1;
        }
    }
}

-(Boolean)checkData{
    if(_nameTxt.text.length != 0 || _descTxt.text.length != 0){
        return YES;
    }
else{
    return NO;
    }
    return NO;
}

- (void)addTask{
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

    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone fromDate:_datePicker.date];



    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"Notification!" arguments:nil];
    objNotificationContent.body = [NSString localizedUserNotificationStringForKey:@"This is local notification message!"
                                                                        arguments:nil];
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
    [_task setTaskDesc:_descTxt.text];
    [_task setTaskPriority:(int) _prioritySegment.selectedSegmentIndex];
    [_task setTaskDate:_datePicker.date];
    if(_comingFrom ==1){
        [_task setTaskStatus:((int)_statusSegment.selectedSegmentIndex+1)];
    }else{
        [_task setTaskStatus:(int)_statusSegment.selectedSegmentIndex];
    }
    [_task setDateOfCreation:_dateCreated.text];
    [self saveToUserDefault];
}

-(void) saveToUserDefault{
    [taskArray replaceObjectAtIndex:rowSelected withObject:_task];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:taskArray];
    [_userDefault setObject:data forKey:@"todoArray"];
    [_userDefault synchronize];
}



@end
