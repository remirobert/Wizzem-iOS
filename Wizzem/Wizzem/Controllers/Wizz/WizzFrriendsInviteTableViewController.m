//
//  WizzFrriendsInviteTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "Wizz.h"
#import "WizzFrriendsInviteTableViewController.h"

@interface WizzFrriendsInviteTableViewController ()

@end

@implementation WizzFrriendsInviteTableViewController

- (IBAction)createWizz:(id)sender {
    PFObject *newWizz = [PFObject objectWithClassName:@"Event"];
    newWizz[@"title"] = [Wizz sharedInstance:false].title;
    if ([Wizz sharedInstance:false].start) {
        newWizz[@"start"] = [Wizz sharedInstance:false].start;
    }
    if ([Wizz sharedInstance:false].end) {
        newWizz[@"end"] = [Wizz sharedInstance:false].end;
    }
    if ([Wizz sharedInstance:false].location) {
        newWizz[@"city"] = [Wizz sharedInstance:false].location;
    }
    if ([Wizz sharedInstance:false].comment) {
        newWizz[@"description"] = [Wizz sharedInstance:false].comment;
    }
    if ([Wizz sharedInstance:false].numberParticipant) {
        newWizz[@"nbMaxParticipant"] = [NSNumber numberWithInteger:[Wizz sharedInstance:false].numberParticipant];
    }
    if ([Wizz sharedInstance:false].isPublic) {
        newWizz[@"public"] = [NSNumber numberWithBool:[Wizz sharedInstance:false].isPublic];
    }
    newWizz[@"creator"] = [PFUser currentUser];
    
    [newWizz saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your Wizz is created, enjey it !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The Wizz couldn't be saved. Check your internet connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [[UIImage imageNamed:@"friendNetwork"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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
        textView.text = @"the more the better. Invite some friends to your Wizz, for share great moment.";
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
    return 260;
}

@end
