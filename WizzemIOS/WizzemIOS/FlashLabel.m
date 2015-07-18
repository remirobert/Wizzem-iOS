//
//  FlashLabel.m
//  
//
//  Created by Remi Robert on 04/07/15.
//
//

#import "FlashLabel.h"

@implementation FlashLabel

- (void)flashText:(NSString *)content {
    self.text = content;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        self.transform = CGAffineTransformMakeScale(2, 2);
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0.6;
        }];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformMakeScale(0, 0);
        }];
    }];
}

- (void)awakeFromNib {
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0, 0);
}

@end
