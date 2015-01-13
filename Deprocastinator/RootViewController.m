//
//  ViewController.m
//  Deprocastinator
//
//  Created by Diego Cichello on 1/12/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "RootViewController.h"
#import "Task.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate,UIScrollViewDelegate>
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

//----------------------- IBActions ----------------------------------------------------------

//Add Button method
- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender
{
    //prevent from adding an empty string
    if (![self.textField.text isEqualToString:@""])
    {
        //Create a new instance of Task, set its property taskName
        //And add it to our array
        Task *task = [[Task alloc]init];
        task.taskName = self.textField.text;


        [self.tasksArray addObject:task];
        self.textField.text = @"";

        [self.view resignFirstResponder];
        [self.tasksTableView reloadData];

    }
}

//Edit Button
- (IBAction)onEditButtonPressed:(UIBarButtonItem *)editButton
{

    //Change if its Done, or Editing

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




//Swipe handler
- (IBAction)swipeHandler:(UISwipeGestureRecognizer *)swipe
{

    //Grab the current Task swiped
    CGPoint swipeLocation = [swipe locationInView:self.tasksTableView];
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:swipeLocation];
    Task *task = [self.tasksArray objectAtIndex:indexPath.row];



    //If its is a swipe to right change the color of its property taskColor
    //Black -> Green -> Yellow -> Red

    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {

        if (task.taskColor == [UIColor greenColor])
        {
            task.taskColor = [UIColor yellowColor];
        }
        else if (task.taskColor== [UIColor yellowColor])
        {
            task.taskColor = [UIColor redColor];
        }
        else if (task.taskColor == [UIColor redColor])
        {
            task.taskColor = [UIColor blackColor];

        }
        else
        {
            task.taskColor= [UIColor greenColor];
        }

        [self.tasksTableView reloadData];
        
        
        
        
    }
    
}

#pragma table methods


//Method that updates the tableView
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Creates a new instance of cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];

    //Creates a new instance of task and update the cell using Task properties
    Task *task = [self.tasksArray objectAtIndex:indexPath.row];

    cell.textLabel.text = task.taskName;
    cell.textLabel.textColor = task.taskColor;
    
    return cell;
}


//Method that bring back the number os objects into the Array
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasksArray.count;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.tasksArray objectAtIndex:indexPath.row];

    task.taskColor = [UIColor greenColor];

    [self.tasksTableView reloadData];



}



//Delete Current Row Method

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

//Method that returns the cell you tapped or swiped

- (UITableViewCell *) getCellFromGesture: (UIGestureRecognizer *)gesture
{
    CGPoint gestureLocation = [gesture locationInView:self.tasksTableView];
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:gestureLocation];
    UITableView *cell = [self.tasksTableView cellForRowAtIndexPath:indexPath];
    return cell;

}

//Method that sets the do the delete button real time without editing it
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
//Method that check if you can move Rows
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//Method that is trigger when you move rows
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //Just create a dummy String to hold data, and exchange rows.
    NSString *stringToBeMoved = [self.tasksArray objectAtIndex:sourceIndexPath.row];
    [self.tasksArray removeObjectAtIndex:sourceIndexPath.row];
    [self.tasksArray insertObject:stringToBeMoved atIndex:destinationIndexPath.row];
}

/*
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.tasksTableView reloadData];
}
 */


#pragma other methods

//--------------Other Methods--------------------------------------------


//Delegated function from alert view to get the button tapped
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==1)
    {

        [self.tasksArray removeObjectAtIndex:self.indexPathDeleted.row];
        [self.tasksTableView deleteRowsAtIndexPaths:@[self.indexPathDeleted] withRowAnimation:UITableViewRowAnimationFade];
        [self.tasksTableView reloadData];

    }

}



//Delegated function from textField



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self.textField.text isEqualToString:@""])
    {
        Task *task = [[Task alloc]init];

        task.taskName = self.textField.text;

        [self.tasksArray addObject:task];
        self.textField.text = @"";
        [self.view resignFirstResponder];
        [self.tasksTableView reloadData];
    }
    return true;
}






@end
