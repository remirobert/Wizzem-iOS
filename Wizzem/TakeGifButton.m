//
//  TakeGif.m
//  Wizzem
//
//  Created by Remi Robert on 28/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "TakeGifButton.h"

@implementation TakeGifButton

- (void) displayButton {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4
                        options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                            self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70,
                                                    [UIScreen mainScreen].bounds.size.height - 130 + 25, 50, 50);
    } completion:nil];
}

- (void) hideButton {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4
                        options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                            self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70,
                                                    [UIScreen mainScreen].bounds.size.height + 50, 50, 50);
    } completion:nil];
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70,
                                [UIScreen mainScreen].bounds.size.height + 50, 50, 50);
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
    }
    return (self);
}

@end
