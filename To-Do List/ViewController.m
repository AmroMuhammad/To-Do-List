//
//  ViewController.m
//  To-Do List
//
//  Created by Amr Muhammad on 4/5/21.
//  Copyright © 2021 Amr Muhammad. All rights reserved.
//

#import "ViewController.h"
#import "AddTaskViewController.h"
#import "TaskModel.h"
#import "EditTaskViewController.h"

@interface ViewController ()
@property NSUserDefaults *userDefault;
@property NSMutableArray<TaskModel*> *taskArray;
@property NSMutableArray<TaskModel*> *tasksFiltered;
@property NSMutableArray<TaskModel*> *originalTasks;
@property Boolean isFiltered;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefault = [NSUserDefaults standardUserDefaults];
    _taskArray = [NSMutableArray new];
    _tasksFiltered = [NSMutableArray new];
    _isFiltered = false;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFiltered) {
        return _tasksFiltered.count;
    }
    return _taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    UILabel *cellName = [cell viewWithTag:1];
    UIImageView *cellImage = [cell viewWithTag:2];
    if (_isFiltered) {
        cellName.text =[[_tasksFiltered objectAtIndex:indexPath.row] taskName];
        switch ([[_tasksFiltered objectAtIndex:indexPath.row] taskPriority]) {
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
    }else{
        cellName.text =[[_taskArray objectAtIndex:indexPath.row] taskName];
        switch ([[_taskArray objectAtIndex:indexPath.row] taskPriority]) {
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
    
    return cell;
}
- (IBAction)addClicked:(id)sender {
    AddTaskViewController *addView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    [self.navigationController pushViewController:addView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    if([[[_userDefault dictionaryRepresentation] allKeys] containsObject:@"todoArray"]){
        [_taskArray removeAllObjects];
        NSData *data = [_userDefault objectForKey:@"todoArray"];
        _originalTasks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for(TaskModel *t in _originalTasks){
            if([t taskStatus]==0){
                [_taskArray addObject:t];
            }
        }
        [_tableView reloadData];
    }
}
	
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length == 0) {

        _isFiltered = false;

        [self.searchBar endEditing:YES];

    }

    else {

        _isFiltered = true;

        _tasksFiltered = [[NSMutableArray alloc]init];

     for (TaskModel *task in _taskArray) {
         NSString *device = task.taskName;
            NSRange range = [device rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if (range.location != NSNotFound) {

                [_tasksFiltered addObject:task];

            }

        }

    }

    [self.tableView reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isFiltered){
        EditTaskViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
        [editView setTaskRecieved:[_tasksFiltered objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:editView animated:YES];
    }else{
        EditTaskViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTaskViewController"];
        [editView setTaskRecieved:[_taskArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:editView animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(_isFiltered){
            [self deleteFromTableWithVisibleArray:indexPath.row];
        }else{
            TaskModel *model = [_taskArray objectAtIndex:indexPath.row];
            for(int i=0;i<_originalTasks.count;i++){
                if([[[_originalTasks objectAtIndex:i] dateOfCreation] isEqualToString:[model dateOfCreation]] ){
                    [_originalTasks removeObjectAtIndex:i];
                    break;
                }
            }
            [_taskArray removeObjectAtIndex:indexPath.row];
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_originalTasks];
        [_userDefault setObject:data forKey:@"todoArray"];
        [_userDefault synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void) deleteFromTableWithVisibleArray:(int)row{
    TaskModel *model = [_tasksFiltered objectAtIndex:row];
    for(int i=0;i<_taskArray.count;i++){
        if([[[_taskArray objectAtIndex:i] dateOfCreation] isEqualToString:[model dateOfCreation]] ){
            [_taskArray removeObjectAtIndex:i];
            [_tasksFiltered removeObjectAtIndex:row];
            break;
        }
    }
    for(int i=0;i<_originalTasks.count;i++){
        if([[[_originalTasks objectAtIndex:i] dateOfCreation] isEqualToString:[model dateOfCreation]] ){
            [_originalTasks removeObjectAtIndex:i];
            break;
        }
    }
}

@end
