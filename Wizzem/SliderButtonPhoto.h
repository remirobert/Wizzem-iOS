//
//  SliderButtonPhoto.h
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PHOTO_CAMERA,
    GIF_CAMERA,
} CAMERA_KIND;

@protocol SliderButtonPhotoDelegate;

@interface SliderButtonPhoto : UIScrollView <UIScrollViewDelegate>

- (instancetype) initWithFrame:(CGRect)frame;
@property (nonatomic, assign) id<SliderButtonPhotoDelegate> delegateCamera;

@end


@protocol SliderButtonPhotoDelegate <NSObject>

- (void) changeActionCamera:(CAMERA_KIND)cameraKind;

@end