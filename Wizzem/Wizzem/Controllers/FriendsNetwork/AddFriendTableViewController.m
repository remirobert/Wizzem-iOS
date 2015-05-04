//
//  AddFriendTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 03/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Parse/Parse.h>
#import "AddFriendTableViewController.h"

@interface AddFriendTableViewController () <ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation AddFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
        NSLog(@"name : %@", firstName);
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSLog(@"name :");
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        if(![MFMessageComposeViewController canSendText]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        
        [messageController setBody:[NSString stringWithFormat:@"%@ souhaite vous invitez sur Wizzem. Téléchargez l'application sur http://wizzem.fr", [PFUser currentUser].username]];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [[UIImage imageNamed:@"searchAccount"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView.layer.masksToBounds = true;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(self.view.frame.size.width / 2 - 75, 10, 150, 150);
        imageView.tintColor = [UIColor darkGrayColor];
        
        UITextView *textView = [UITextView new];
        textView.textAlignment = NSTextAlignmentCenter;
        textView.font = [UIFont systemFontOfSize:14];
        textView.textColor = [UIColor darkGrayColor];
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = false;
        textView.selectable = false;
        textView.scrollEnabled = false;
        textView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        textView.text = @"Find some friends on the Wizzem network. If your friends are not using Wizzem yet, invite them !";
        [textView sizeToFit];
        textView.frame = CGRectMake(0, 150 / 2 - textView.frame.size.height / 2 + 130, self.view.frame.size.width, textView.frame.size.height);
        
        UIView *container = [UIView new];
        container.frame = CGRectMake(0, 0, self.view.frame.size.width, 260);
        [container addSubview:textView];
        [container addSubview:imageView];
        return container;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 260;
    }
    return 24;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
