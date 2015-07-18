//
//  CaptureButton.m
//  
//
//  Created by Remi Robert on 04/07/15.
//
//

#import "CaptureButton.h"

@implementation CaptureButton

- (void)animatedClick {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        } completion:nil];
    }];
}

@end
