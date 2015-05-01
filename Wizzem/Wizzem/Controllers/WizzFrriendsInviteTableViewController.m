//
//  WizzFrriendsInviteTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzFrriendsInviteTableViewController.h"

@interface WizzFrriendsInviteTableViewController ()

@end

@implementation WizzFrriendsInviteTableViewController

- (IBAction)createWizz:(id)sender {
    
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
        imageView.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 10, 100, 100);
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
        textView.frame = CGRectMake(0, 150 / 2 - textView.frame.size.height / 2 + 110, self.view.frame.size.width, textView.frame.size.height);
        
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
