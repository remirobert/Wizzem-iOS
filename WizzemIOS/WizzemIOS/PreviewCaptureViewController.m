//
//  PreviewCaptureViewController.m
//  
//
//  Created by Remi Robert on 04/07/15.
//
//

#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import "PreviewCaptureViewController.h"

@interface PreviewCaptureViewController ()
@property (strong, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@end

@implementation PreviewCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.media.type == GIF) {
        FLAnimatedImage *animatedGif = [FLAnimatedImage animatedImageWithGIFData:self.media.dataMedia];
        self.imageView.animatedImage = animatedGif;
    }
    else {
        self.imageView.image = [UIImage imageWithData:self.media.dataMedia];
    }
}

@end
