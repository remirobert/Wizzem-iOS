//
//  SliderButtonPhoto.m
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SliderButtonPhoto.h"
#import "CircleView.h"

@interface SliderButtonPhoto()
@property (nonatomic, strong) NSMutableArray *sliderButtons;
@property (nonatomic, strong) UIView *layerIndicator;
@property (nonatomic, strong) CircleView *circleView;
@end

@implementation SliderButtonPhoto

#pragma mark - slider indicator functional

- (void) incrementValueCircle:(NSInteger)count {
    [self.circleView setStrokeEnd:(CGFloat)(count / 10.0) animated:YES];
}

- (void) resetValueCircle {
    [self.circleView setStrokeEnd:0.0 animated:false];
}

- (void) displayIndicatorInView:(UIView *)parentView {
    if ([self.layerIndicator superview] != nil) {
        return;
    }
    self.layerIndicator.frame = CGRectZero;
    self.layerIndicator.center = CGPointMake(self.frame.origin.x + self.frame.size.width / 2,
                                             self.frame.origin.y + self.frame.size.height / 2);
    [parentView addSubview:self.layerIndicator];
    [parentView bringSubviewToFront:self];
    [UIView animateWithDuration:0.7 delay:0.3 usingSpringWithDamping:0.4 initialSpringVelocity:0.4
                        options:UIViewAnimationOptionTransitionNone animations:^{
        self.layerIndicator.frame = CGRectMake(0, 0,
                                               self.frame.size.width + 40, self.frame.size.height + 40);
        self.layerIndicator.center = CGPointMake(self.frame.origin.x + self.frame.size.width / 2,
                                                 self.frame.origin.y + self.frame.size.height / 2);
    } completion:^(BOOL finished) {
    }];
    
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    v.backgroundColor = [UIColor redColor];
    [parentView addSubview:v];
}

- (void) hideIndicatorInView {
    [UIView animateWithDuration:0.7 delay:0.3 usingSpringWithDamping:0.4 initialSpringVelocity:0.4
                        options:UIViewAnimationOptionTransitionNone animations:^{
        self.layerIndicator.frame = CGRectZero;
        self.layerIndicator.center = CGPointMake(self.frame.origin.x + self.frame.size.width / 2,
                                                 self.frame.origin.y + self.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [self.layerIndicator removeFromSuperview];
    }];
}

#pragma mark - button init

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

- (UIButton *) buttonVideo:(CGFloat)positionX {
    UIButton *buttonVideo = [[UIButton alloc] initWithFrame:CGRectMake(positionX, 0, 100, 100)];
    [buttonVideo setImage:[UIImage imageNamed:@"sliderVideo"] forState:UIControlStateNormal];
    buttonVideo.layer.masksToBounds = true;
    buttonVideo.imageView.contentMode = UIViewContentModeScaleToFill;
    buttonVideo.tag = 2;
    return buttonVideo;
}

#pragma mark - initalisation

- (void) initIndicatorSlider {
    self.layerIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x - 20, self.frame.origin.y - 20,
                                                                   self.frame.size.width + 40, self.frame.size.height + 40)];
    self.layerIndicator.layer.cornerRadius = self.layerIndicator.frame.size.width / 2;
    self.layerIndicator.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
}

- (void) initCircleView:(UIView *)parentView {
    self.circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    self.circleView.center = self.center;
    self.circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
    [parentView addSubview:self.circleView];
    [parentView bringSubviewToFront:self];
    [self.circleView setStrokeEnd:0.0 animated:false];
}

- (void) initSliderUI {
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.pagingEnabled = true;
    self.layer.masksToBounds = true;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.showsHorizontalScrollIndicator = false;
    self.delegate = self;
    
    self.sliderButtons = [[NSMutableArray alloc] init];
    [self.sliderButtons addObject:[self buttonVideo:0]];
    [self.sliderButtons addObject:[self buttonPhoto:100]];
    [self.sliderButtons addObject:[self buttonGif:200]];
    [self.sliderButtons addObject:[self buttonVideo:300]];
    [self.sliderButtons addObject:[self buttonPhoto:400]];

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
