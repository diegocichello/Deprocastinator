//
//  ViewController.m
//  Deprocastinator
//
//  Created by Diego Cichello on 1/12/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *tasksArray;
@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;

@end

@implementation RootViewController

#pragma view methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasksArray = [[NSMutableArray alloc]init];
}

#pragma ibactions

//
- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender
{
    [self.tasksArray addObject:self.textField.text];
    self.textField.text = @"";
    [self.view resignFirstResponder];
    [self.tasksTableView reloadData];
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
    CGPoint tapLocation = [tap locationInView:self.tasksTableView];
    NSIndexPath *indexPath = [self.tasksTableView indexPathForRowAtPoint:tapLocation];
    [self.tasksArray objectAtIndex:indexPath];
}

- (IBAction)swipeHandler:(UISwipeGestureRecognizer *)swipe
{
    
}

#pragma other methods




@end
