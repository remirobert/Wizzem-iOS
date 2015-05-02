//
//  CreateWizzTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "Wizzem-Swift.h"
#import "CreateWizzTableViewController.h"
#import "LocationPickerViewController.h"
#import "Wizz.h"

@interface CreateWizzTableViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) DatePickerDialog *datePicker;
@end

@implementation CreateWizzTableViewController

- (DatePickerDialog *)datePicker {
    if (!_datePicker) {
        _datePicker = [[DatePickerDialog alloc] init];
    }
    return  _datePicker;
}

#pragma mark -
#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= 1 && string.length == 0) {
        if (range.location == 0 && range.length == textField.text.length) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
        }
    }
    
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:true];
        return false;
    }

    if (textField.text.length > 0 && string.length > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextPrivacyController)];
    }
    return true;
}

#pragma mark -
#pragma mark UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSString *textCheck = @"Add a comment in your Wizz, for add some details.";
    
    if ([textView.text isEqualToString:textCheck]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add a comment in your Wizz, for add some details.";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {    
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:true];
        return false;
    }

    return true;
}


#pragma mark -
#pragma mark UIView cycle

- (void)nextPrivacyController {
    [Wizz sharedInstance:false].title = ((UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].contentView viewWithTag:1]).text;
    
    [Wizz sharedInstance:false].comment = ((UITextView *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]].contentView viewWithTag:1]).text;

    [self performSegueWithIdentifier:@"nextPrivacyController" sender:nil];
}

- (IBAction)cancelCreation:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.view endEditing:true];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
    ((UITextView *)[cell.contentView viewWithTag:1]).delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    [Wizz sharedInstance:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"locationController"]) {
        LocationPickerViewController *locationController = (LocationPickerViewController *)(((UINavigationController *)segue.destinationViewController).topViewController);
        
        locationController.selectionBlock = ^(NSDictionary *content) {
            if (content) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

                [Wizz sharedInstance:false].location = [PFGeoPoint geoPointWithLatitude:[[content objectForKey:@"lat"] doubleValue] longitude:[[content objectForKey:@"lon"] doubleValue]];
                
                UILabel *labelLocation = ((UILabel *)[cell.contentView viewWithTag:1]);
                labelLocation.text = [content objectForKey:@"title"];
                labelLocation.textColor = [UIColor grayColor];
            }
        };
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1 || indexPath.row == 2) {
            
            [self.datePicker showWithTitle:(indexPath.row == 1) ? @"Start date" : @"End date" datePickerMode:UIDatePickerModeDateAndTime callback:
             ^(NSDate* date) {
                 UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
                 
                 currentCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", date];
                 NSLog(@"date : %@", date);

                 if (indexPath.row == 1) {
                     [Wizz sharedInstance:false].start = date;
                 }
                 else {
                     [Wizz sharedInstance:false].end = date;
                 }
                 
                 [self.datePicker removeFromSuperview];
             }];
            [self.view addSubview:self.datePicker];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITextView *textView = [UITextView new];
        textView.textAlignment = NSTextAlignmentCenter;
        textView.font = [UIFont systemFontOfSize:14];
        textView.textColor = [UIColor darkGrayColor];
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = false;
        textView.selectable = false;
        textView.scrollEnabled = false;
        textView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        textView.text = @"Grâce au wizz, organisez vos activités et centralisez les publications de tous les participants impliqués. Retranscrivez, chaque instant que vous vivez en utilisant le média le plus adapté !";
        [textView sizeToFit];
        textView.frame = CGRectMake(0, 150 / 2 - textView.frame.size.height / 2, self.view.frame.size.width, textView.frame.size.height);
        
        UIView *container = [UIView new];
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
        [container addSubview:textView];
        return container;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 150;
    }
    return 44;
}

@end
