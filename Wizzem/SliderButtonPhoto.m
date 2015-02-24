//
//  SliderButtonPhoto.m
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SliderButtonPhoto.h"

@interface SliderButtonPhoto()
@property (nonatomic, strong) NSMutableArray *sliderButtons;
@end

@implementation SliderButtonPhoto

- (UIButton *) buttonPhoto:(CGFloat)positionX {
    UIButton *buttonPhoto = [[UIButton alloc] initWithFrame:CGRectMake(positionX, 0, 100, 100)];
    [buttonPhoto setImage:[UIImage imageNamed:@"sliderPhoto"] forState:UIControlStateNormal];
    buttonPhoto.layer.masksToBounds = true;
    buttonPhoto.imageView.contentMode = UIViewContentModeScaleAspectFill;
    buttonPhoto.tag = 0;
    return buttonPhoto;
}

- (UIButton *) buttonGif:(CGFloat)positionX {
    UIButton *buttonGif = [[UIButton alloc] initWithFrame:CGRectMake(positionX, 0, 100, 100)];
    [buttonGif setImage:[UIImage imageNamed:@"sliderGif"] forState:UIControlStateNormal];
    buttonGif.layer.masksToBounds = true;
    buttonGif.imageView.contentMode = UIViewContentModeScaleToFill;
    buttonGif.tag = 1;
    return buttonGif;
}

- (void) initSliderUI {
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.pagingEnabled = true;
    self.layer.masksToBounds = true;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.showsHorizontalScrollIndicator = false;
    self.delegate = self;
    
    self.sliderButtons = [[NSMutableArray alloc] init];
    [self.sliderButtons addObject:[self buttonGif:0]];
    [self.sliderButtons addObject:[self buttonPhoto:100]];
    [self.sliderButtons addObject:[self buttonGif:200]];
    [self.sliderButtons addObject:[self buttonPhoto:300]];

    for (UIButton *currentButton in self.sliderButtons) {
        [self addSubview:currentButton];
    }
    
    self.contentSize = CGSizeMake(100 * (self.sliderButtons.count), 0);
    [self setContentOffset:CGPointMake(100, 0) animated:false];
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self initSliderUI];
    return self;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger position = (int)scrollView.contentOffset.x / 100;
    
    if (position == self.sliderButtons.count - 1) {
        [scrollView setContentOffset:CGPointMake(100, 0) animated:false];
    }
    else if (position == 0) {
        [scrollView setContentOffset:CGPointMake((self.sliderButtons.count - 2) * 100, 0) animated:false];
    }
    if ([self.delegateCamera respondsToSelector:@selector(changeActionCamera:)]) {
        [self.delegateCamera changeActionCamera:((UIButton *)[self.sliderButtons objectAtIndex:position]).tag];
    }
}

#pragma mark - selector init

- (NSArray *) buttonForKind:(CAMERA_KIND)cameraKind {
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (UIButton *currentButton in self.sliderButtons) {
        if (currentButton.tag == cameraKind) {
            [buttons addObject:currentButton];
        }
    }
    return (NSArray *)buttons;
}

@end
