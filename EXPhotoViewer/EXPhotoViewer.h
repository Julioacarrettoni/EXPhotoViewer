//
//  EXPhotoViewer.h
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPhotoViewer : UIViewController <UIScrollViewDelegate>

+ (void) showImageFrom:(UIImageView*) image;
+ (void) showImageFrom:(UIImageView*) image originalImage:(UIImage*)originalImage;

@end
