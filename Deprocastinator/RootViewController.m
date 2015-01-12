//
//  ViewController.m
//  Deprocastinator
//
//  Created by Diego Cichello on 1/12/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *listItemsArray;

@end

@implementation RootViewController

#pragma view methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listItemsArray = [[NSMutableArray alloc]init];
}

#pragma ibactions

//
- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender
{
    [self.listItemsArray addObject:self.textField.text];
}

#pragma table methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listItemsArray.count;
}

#pragma other methods




@end
