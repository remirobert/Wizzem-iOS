//
//  PreviewLayerMediaCaptureView.m
//  Wizzem
//
//  Created by Remi Robert on 02/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <PBJVision.h>
#import <PBJVision/PBJVision.h>
#import "PreviewLayerMediaCaptureView.h"

@interface PreviewLayerMediaCaptureView()
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation PreviewLayerMediaCaptureView

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[PBJVision sharedInstance] previewLayer];
        _previewLayer.frame = self.bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    self.frame = previewFrame;
    [self.layer addSublayer:self.previewLayer];
}

+ (instancetype)preview {
    return [[PreviewLayerMediaCaptureView alloc] init];
}

@end
