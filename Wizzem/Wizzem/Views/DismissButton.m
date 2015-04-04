//
//  DismissButton.m
//  Wizzem
//
//  Created by Remi Robert on 04/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "DismissButton.h"

@implementation DismissButton

- (void)drawRect:(CGRect)rect {
    [self setImage:[[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.tintColor = [UIColor colorWithRed:0.41 green:0.4 blue:0.52 alpha:1];
    self.frame = CGRectMake(10, 300, 40, 40);
}

@end
