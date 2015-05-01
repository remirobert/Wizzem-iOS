//
//  CreateWizzTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "CreateWizzTableViewController.h"
#import "LocationPickerViewController.h"

@interface CreateWizzTableViewController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation CreateWizzTableViewController

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self.view endEditing:true];
        return false;
    }
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:true];
        return false;
    }
    return true;
}

- (void)viewDidAppear:(BOOL)animated {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    ((UITextField *)[cell.contentView viewWithTag:1]).delegate = self;
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];
    ((UITextView *)[cell.contentView viewWithTag:1]).delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"locationController"]) {
        ((LocationPickerViewController *)segue.destinationViewController).selectionBlock = ^(NSDictionary *content) {
            if (content) {
                
            }
        };
    }
}

@end
