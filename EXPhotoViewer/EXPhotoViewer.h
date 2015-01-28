//
//  EXPhotoViewer.h
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPhotoViewer : UIViewController <UIScrollViewDelegate, UIAppearanceContainer>

/**
 *  The scale to be applied as transformation to the background. IE, a scall of 
 *  0.8 would "shrink" the background making it appear inset from the screen edges.
 */
@property (nonatomic) CGFloat backgroundScale;

/**
 *  The background color of the screen while image is being viewed. Default is black.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

@property (atomic, readonly) BOOL isClosing;

+ (instancetype)showImageFrom:(UIImageView *)imageView;
+ (instancetype)newViewerFor:(UIImageView *)imageView;

- (void)show;
- (void)close;

@end
