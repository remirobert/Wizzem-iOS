//
//  WizzPrivacyTableViewController.m
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "Wizz.h"
#import "WizzPrivacyTableViewController.h"

@interface WizzPrivacyTableViewController ()
@property (nonatomic, strong) UIView *mask;
@end

@implementation WizzPrivacyTableViewController

- (UIView *)mask {
    if (!_mask) {
        _mask = [UIView new];
        _mask.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        _mask.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _mask.tag = 2;
    }
    return _mask;
}

- (void)changeValue:(UISwitch *)sender {
    [Wizz sharedInstance:false].isPublic = sender.on;
    if (sender.on) {
        self.mask.alpha = 0;
    }
    else {
        self.mask.alpha = 1;
    }
}

- (void)valueSetepper:(UIStepper *)sender {
    if ([Wizz sharedInstance:false].isPublic) {
        [Wizz sharedInstance:false].numberParticipant = sender.value;
    }
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    
    if (sender.value == 0) {
        ((UILabel *)[currentCell.contentView viewWithTag:1]).text = @"Illimited";
    }
    else {
        ((UILabel *)[currentCell.contentView viewWithTag:1]).text = [NSString stringWithFormat:@"%d", (int)sender.value];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    [((UIStepper *)[currentCell.contentView viewWithTag:2]) addTarget:self action:@selector(valueSetepper:) forControlEvents:UIControlEventValueChanged];
    [currentCell.contentView addSubview:self.mask];
    
    UITableViewCell *switchCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UISwitch *switchPrivacy = (UISwitch *)[switchCell.contentView viewWithTag:1];
    [switchPrivacy addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [[UIImage imageNamed:@"privacy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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
        textView.text = @"The privacy define who can participate to your Wizz and see the content.\nPublic: everyone can see your Wizz in the main feed, and ask for participate. In this Wizz, can define the number of participant.\nPrivate: No one can see your Wizz expect the persons you invite.";
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
