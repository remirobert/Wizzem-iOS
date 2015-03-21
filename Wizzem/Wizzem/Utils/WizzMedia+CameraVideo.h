//
//  WizzMedia+CameraVideo.h
//  ExampleWizzMediaFramework
//
//  Created by Remi Robert on 18/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "WizzMedia.h"

@interface WizzMedia (CameraVideo)

- (void) cropVideo:(NSURL *)url blockCompletion:(void(^)(NSURL *url))completion;

@end
