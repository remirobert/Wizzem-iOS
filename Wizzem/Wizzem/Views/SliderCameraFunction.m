//
//  SliderCameraFunction.m
//  Wizzem
//
//  Created by Remi Robert on 21/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SliderCameraFunction.h"
#import "Colors.h"

@interface SliderCameraFunction()
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation SliderCameraFunction

- (UIButton *)createButton:(CGFloat)positionX {
    
    CGFloat sizeButton = self.frame.size.height - self.frame.size.height / 3;
    
    CGRect frameButton = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - sizeButton / 2 + positionX, self.frame.size.height - sizeButton - sizeButton / 2, sizeButton, sizeButton);
    
    frameButton.origin.y = self.frame.size.height - self.frame.size.height + (self.frame.size.height - sizeButton) / 2;
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newButton.frame = frameButton;
    [newButton setImage:[[UIImage imageNamed:@"captureButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    newButton.backgroundColor = [UIColor clearColor];
    newButton.tintColor = [Colors greenColor];
    
    return newButton;
}

- (void)initSliderButtons {
    self.pagingEnabled = true;
    self.showsHorizontalScrollIndicator = false;
    self.delegate = self;
    self.buttons = [[NSMutableArray alloc] init];
    
    CGFloat indexPositionX = 0;
    for (int indexButton = 0; indexButton < 7; indexButton++) {
        UIButton *newButton = [self createButton:indexPositionX];
        [self.buttons addObject:newButton];
        [self addSubview:newButton];
        indexPositionX += self.frame.size.width;
    }
    self.contentSize = CGSizeMake(indexPositionX, self.frame.size.height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSliderButtons];
    }
    return self;
}

@end
