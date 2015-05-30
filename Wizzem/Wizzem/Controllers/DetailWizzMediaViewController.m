//
//  DetailWizzMediaViewController.m
//  Wizzem
//
//  Created by Remi Robert on 30/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import "DetailWizzMediaViewController.h"

@interface DetailWizzMediaViewController ()
@property (strong, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *title;
@end

@implementation DetailWizzMediaViewController

@synthesize title;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title.text = self.media[@"title"];
    PFFile *currentFile = self.media[@"file"];
    [currentFile getDataInBackgroundWithBlock:^(NSData * data, NSError * error) {
        if (data == nil) {
            NSLog(@"err : %@", error);
            return;
        }
        if ([self.media[@"type"] isEqualToString:@"photo"]) {
            self.imageView.image = [UIImage imageWithData:data];
        }
        else if ([self.media[@"type"] isEqualToString:@"gif"]) {
            FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
            self.imageView.animatedImage = animatedImage;
        }
    }];
}

@end
