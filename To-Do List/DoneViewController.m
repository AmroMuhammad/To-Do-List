//
//  DoneViewController.m
//  To-Do List
//
//  Created by Amr Muhammad on 4/5/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

#import "DoneViewController.h"
#import "TaskModel.h"
#import "EditTaskViewController.h"

@interface DoneViewController (){
    NSMutableArray *highArray;
    NSMutableArray *medArray;
    NSMutableArray *lowArray;
}
@property NSUserDefaults *userDefault;
@property NSMutableArray<TaskModel*> *taskArray;
@property Boolean isSorted;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSorted = false;
    _userDefault = [NSUserDefaults standardUserDefaults];
    _taskArray = [NSMutableArray new];
    highArray = [NSMutableArray new];
    medArray = [NSMutableArray new];
    lowArray = [NSMutableArray new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_isSorted){
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isSorted){
        switch (section) {
            case 0:
                return highArray.count;
                break;
            case 1:
                return medArray.count;
                break;
            case 2:
                return lowArray.count;
                break;
        }
    }
    return _taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    if(_isSorted){
        switch (indexPath.section) {
            case 0:
                [self setCell:cell indexPath:indexPath array:highArray];
                break;
            case 1:
                [self setCell:cell indexPath:indexPath array:medArray];
                break;
            case 2:
                [self setCell:cell indexPath:indexPath array:lowArray];
                break;
        }
    }else{
        [self setCell:cell indexPath:indexPath array:_taskArray];
    }
    return cell;
}

- (void)viewDidAppear:(BOOL)animated{
    if([[[_userDefault dictionaryRepresentation] allKeys] containsObject:@"todoArray"]){
        [_taskArray removeAllObjects];
        NSData *data = [_userDefault objectForKey:@"todoArray"];
        NSMutableArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for(TaskModel *t in temp){
            if([t taskStatus]==2){
                [_taskArray addObject:t];
            }
        }
        if(_isSorted){
            [highArray removeAllObjects];
            [medArray removeAllObjects];
            [lowArray removeAllObjects];
            for(TaskModel *t in _taskArray){
                if([t taskPriority]==0){
                    [highArray addObject:t];
                }else if([t taskPriority]==1){
                    [medArray addObject:t];
                }else{
                    [lowArray addObject:t];
                }
            }
        }
        [_tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditTaskViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
    [editView setTaskRecieved:[_taskArray objectAtIndex:indexPath.row]];
    [editView setComingFrom:2];
    [self.navigationController pushViewController:editView animated:YES];
}

- (IBAction)sortTable:(id)sender {
    [highArray removeAllObjects];
    [medArray removeAllObjects];
    [lowArray removeAllObjects];
    if(_isSorted){
        _isSorted=false;
        [sender setTitle:@"Sort" forState:UIControlStateNormal];
    }else{
        _isSorted=true;
        [sender setTitle:@"Unsort" forState:UIControlStateNormal];
    }
    for(TaskModel *t in _taskArray){
        if([t taskPriority]==0){
            [highArray addObject:t];
        }else if([t taskPriority]==1){
            [medArray addObject:t];
        }else{
            [lowArray addObject:t];
        }
    }
    [_tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_isSorted){
        switch (section) {
            case 0:
                return @"High Priority";
                break;
            case 1:
                return @"Medium Priority";
                break;
            case 2:
                return @"Low Priority";
                break;
        }
    }
    return @"";
}

-(void) setCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath array:(NSMutableArray*)arr{
    UILabel *cellName = [cell viewWithTag:1];
    UIImageView *cellImage = [cell viewWithTag:2];
    cellName.text =[[arr objectAtIndex:indexPath.row] taskName];
    switch ([[arr objectAtIndex:indexPath.row] taskPriority]) {
        case 0:
            cellImage.image = [UIImage imageNamed:@"high.png"];
            break;
        case 1:
            cellImage.image = [UIImage imageNamed:@"med.png"];
            break;
        case 2:
            cellImage.image = [UIImage imageNamed:@"low.png"];
            break;
        }
}

@end
