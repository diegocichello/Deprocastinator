//
//  ViewController.m
//  Deprocastinator
//
//  Created by Diego Cichello on 1/12/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *tasksArray;
@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;

@property bool isEditButtonPressed;

@end

@implementation RootViewController

#pragma view methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasksArray = [[NSMutableArray alloc]init];
    self.isEditButtonPressed = false;
}

#pragma ibactions

//
- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender
{
    if (![self.textField.text isEqualToString:@""])
    {
        [self.tasksArray addObject:self.textField.text];
        self.textField.text = @"";
        [self.view resignFirstResponder];
        [self.tasksTableView reloadData];
    }
}
- (IBAction)onEditButtonPressed:(UIBarButtonItem *)editButton
{
    if (self.isEditButtonPressed)
    {
        editButton.title = @"Edit";
    }
    else
    {
        editButton.title = @"Done";
    }
    self.isEditButtonPressed = !self.isEditButtonPressed;
    



}

#pragma table methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
    
    cell.textLabel.text = [self.tasksArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasksArray.count;
}

- (IBAction)tapHandler:(UITapGestureRecognizer *)tap
{

    if (self.isEditButtonPressed)
    {
        [self deleteCurrentRow:tap];
    }
    else
    {
         UITableViewCell *cell = [self getCellFromTap:tap];
         cell.backgroundColor = [UIColor greenColor];
    }

}

- (void) deleteCurrentRow:(UIGestureRecognizer *)gesture
{
    CGPoint gestureLocation = [gesture locationInView:self.tasksTableView];
    
    
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:gestureLocation];
    
    if (indexPath)
    {
        [self.tasksArray removeObjectAtIndex:indexPath.row];
        [self.tasksTableView reloadData];
    }
    
        


}

- (UITableViewCell *) getCellFromTap: (UITapGestureRecognizer *)tap
{
    CGPoint tapLocation = [tap locationInView:self.tasksTableView];
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:tapLocation];
    UITableView *cell = [self.tasksTableView cellForRowAtIndexPath:indexPath];
    return cell;

}

- (IBAction)swipeHandler:(UISwipeGestureRecognizer *)swipe
{

    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self deleteCurrentRow:swipe];
    }
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self.textField.text isEqualToString:@""])
    {
        [self.tasksArray addObject:self.textField.text];
        self.textField.text = @"";
        [self.view resignFirstResponder];
        [self.tasksTableView reloadData];
    }
    return true;
}

#pragma other methods




@end
