//
//  CreateWizzViewController.m
//  Wizzem
//
//  Created by Remi Robert on 29/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "Wizzem-Swift.h"
#import "Wizz.h"
#import "CreateWizzViewController.h"
#import "ValidateViewController.h"

@interface CreateWizzViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) DatePickerDialog *datePicker;
@property (nonatomic, strong) Wizz *wizz;
@end

@implementation CreateWizzViewController

- (DatePickerDialog *)datePicker {
    if (!_datePicker) {
        _datePicker = [[DatePickerDialog alloc] init];
    }
    return _datePicker;
}

- (IBAction)createWizz:(id)sender {
    self.wizz = [Wizz new];
    
    
    self.wizz.title = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] viewWithTag:1]).text;
    self.wizz.start = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]] viewWithTag:1]).text;
    self.wizz.end = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]] viewWithTag:1]).text;
    if (self.cells.count > 4) {
        self.wizz.comment = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3]] viewWithTag:1]).text;
    }
    [self performSegueWithIdentifier:@"wizzValidateCreation" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"wizzValidateCreation"]) {
        ((ValidateViewController *)segue.destinationViewController).wizz = self.wizz;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"touch : %d", indexPath.row);
    
    if (indexPath.row == 3) {
        [self.cells removeObjectAtIndex:3];
        [self.cells addObject:@"wizzComentCell"];
        [self.cells addObject:@"wizzLocationCell"];
        [self.tableView reloadData];
    }
    if (indexPath.row == 1 || indexPath.row == 2) {
        [self.datePicker showWithTitle:(indexPath.row == 1) ? @"Start date" : @"End date" datePickerMode:UIDatePickerModeDateAndTime callback:
         ^(NSDate* date) {
             UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
             
             ((UILabel *)[currentCell.contentView viewWithTag:1]).text = [NSString stringWithFormat:@"%@", date];
             NSLog(@"date : %@", date);
             [self.datePicker removeFromSuperview];
         }];
        [self.view addSubview:self.datePicker];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.cells objectAtIndex:indexPath.row]];
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSArray *cellsIdentifier = @[@"wizzTitleCell", @"wizzStartCell", @"wizzEndCell", @"wizzMoreOptionsCell"];
    self.cells = [[NSMutableArray alloc] initWithArray:cellsIdentifier];
}

@end
