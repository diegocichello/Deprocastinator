//
//  ViewController.m
//  Deprocastinator
//
//  Created by Diego Cichello on 1/12/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *tasksArray;
@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;

@property NSIndexPath *indexPathDeleted;

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
        
        [self.tasksTableView reloadData];
        [self.view resignFirstResponder];
    }
}
- (IBAction)onEditButtonPressed:(UIBarButtonItem *)editButton
{

    if (self.isEditButtonPressed)
    {
        editButton.title = @"Edit";
        [self.tasksTableView setEditing:false animated:false];
    }
    else
    {
        editButton.title = @"Done";
        [self.tasksTableView setEditing:true animated:true];
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
         UITableViewCell *cell = [self getCellFromTap:tap];
         cell.textLabel.backgroundColor = [UIColor greenColor];
    }

}


- (void) deleteCurrentRow:(UIGestureRecognizer *)gesture
{
    CGPoint gestureLocation = [gesture locationInView:self.tasksTableView];
    
    
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:gestureLocation];
    NSArray *indexPathToBeDeleted = [NSArray arrayWithObject:indexPath];
    
    if (indexPath)
    {
        [self.tasksArray removeObjectAtIndex:indexPath.row];
        [self.tasksTableView deleteRowsAtIndexPaths:indexPathToBeDeleted withRowAnimation:(UITableViewRowAnimationFade)];
        [self.tasksTableView reloadData];
    }
    
        


}



- (UITableViewCell *) getCellFromTap: (UIGestureRecognizer *)tap
{
    CGPoint tapLocation = [tap locationInView:self.tasksTableView];
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:tapLocation];
    UITableView *cell = [self.tasksTableView cellForRowAtIndexPath:indexPath];
    return cell;

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==1)
    {

        [self.tasksArray removeObjectAtIndex:self.indexPathDeleted.row];
        [self.tasksTableView deleteRowsAtIndexPaths:@[self.indexPathDeleted] withRowAnimation:UITableViewRowAnimationFade];


        [self.tasksTableView reloadData];




    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{


    UIAlertView *deleteAlert = [[UIAlertView alloc]init];
    deleteAlert.delegate = self;
    deleteAlert.title =@"Delete warning!";
    deleteAlert.message = @"Are you sure you want to delete?";
    [deleteAlert addButtonWithTitle:@"No!"];
    [deleteAlert addButtonWithTitle:@"Yes"];

    [deleteAlert show];
    self.indexPathDeleted = indexPath;



}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    NSString *stringToBeMoved = [self.tasksArray objectAtIndex:sourceIndexPath.row];
    [self.tasksArray removeObjectAtIndex:sourceIndexPath.row];
    [self.tasksArray insertObject:stringToBeMoved atIndex:destinationIndexPath.row];
}


- (IBAction)swipeHandler:(UISwipeGestureRecognizer *)swipe
{



    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        //[self deleteCurrentRow:swipe];
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        UITableViewCell *cell = [self getCellFromTap:swipe];

        if (cell.textLabel.textColor == [UIColor greenColor])
        {
            cell.textLabel.textColor = [UIColor yellowColor];
        }
        else if (cell.textLabel.textColor == [UIColor yellowColor])
        {
            cell.textLabel.textColor = [UIColor redColor];
        }
        else if (cell.textLabel.textColor == [UIColor redColor])
        {
            cell.textLabel.textColor = [UIColor blackColor];

        }
        else
        {
            cell.textLabel.textColor = [UIColor greenColor];
        }






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
