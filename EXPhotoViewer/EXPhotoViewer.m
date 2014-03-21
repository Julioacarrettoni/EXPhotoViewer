//
//  EXPhotoViewer.m
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import "EXPhotoViewer.h"

@interface EXPhotoViewer ()

@property (nonatomic, retain) UIView* tempViewContainer;
@property (nonatomic, assign) CGRect originalImageRect;
@property (nonatomic, retain) UIViewController* controller;
@property (nonatomic, retain) UIViewController* selfController;
@property (nonatomic, retain) UIImageView* originalImage;

@end

@implementation EXPhotoViewer

+ (void) showImageFrom:(UIImageView*) imageView {
    if (imageView.image) {
        EXPhotoViewer* viewer = [EXPhotoViewer new];
        [viewer showImageFrom:imageView];
    }
}

- (void) showImageFrom:(UIImageView*) imageView {
    
    UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.tempViewContainer = [[UIView alloc] initWithFrame:controller.view.bounds];
    self.tempViewContainer.backgroundColor = controller.view.backgroundColor;
    controller.view.backgroundColor = [UIColor blackColor];
    
    for (UIView* subView in controller.view.subviews) {
        [self.tempViewContainer addSubview:subView];
    }
    
    [controller.view addSubview:self.tempViewContainer];
    
    self.controller = controller;
    [controller.view addSubview:self.view];
    
    self.view.frame = controller.view.bounds;
    dimView.alpha = 0.0;
    [controller.view addSubview:self.view];
    
    theImageView.image = imageView.image;
    self.originalImageRect = [imageView convertRect:imageView.frame toView:self.view];
    theImageView.frame = self.originalImageRect;
    
    [UIView animateWithDuration:0.3 animations:^{
        dimView.alpha = 1.0;
        self.tempViewContainer.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
        theImageView.frame = [self centeredOnScreenImage:theImageView.image];
    } completion:^(BOOL finished) {
        [self adjustScrollInsetsToCenterImage];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap)];
        [self.view addGestureRecognizer:tap];
    }];
    
    self.selfController = self; //Stupid ARC I need to do this to avoid being dealloced :P
    self.originalImage = imageView;
    imageView.image = nil;
}

- (void) onBackgroundTap {
    
    CGRect absoluteCGRect = [self.view convertRect:theImageView.frame fromView:theImageView.superview];
    zoomeableScrollView.contentOffset = CGPointZero;
    zoomeableScrollView.contentInset = UIEdgeInsetsZero;
    theImageView.frame = absoluteCGRect;
    
    [UIView animateWithDuration:0.3 animations:^{
        theImageView.frame = self.originalImageRect;
        dimView.alpha = 0.0;
        self.tempViewContainer.layer.transform = CATransform3DIdentity;
    }completion:^(BOOL finished) {
        self.originalImage.image = theImageView.image;
        self.controller.view.backgroundColor = self.tempViewContainer.backgroundColor;
        for (UIView* subView in self.tempViewContainer.subviews) {
            [self.controller.view addSubview:subView];
        }
        [self.view removeFromSuperview];
        [self.tempViewContainer removeFromSuperview];
    }];
    
    self.selfController = nil;//Ok ARC you can kill me now.
}

- (CGRect) centeredOnScreenImage:(UIImage*) image {
    CGSize imageSize = [self imageSizesizeThatFitsForImage:theImageView.image];
    CGPoint imageOrigin = CGPointMake(self.view.frame.size.width/2.0 - imageSize.width/2.0, self.view.frame.size.height/2.0 - imageSize.height/2.0);
    return CGRectMake(imageOrigin.x, imageOrigin.y, imageSize.width, imageSize.height);
}

- (CGSize) imageSizesizeThatFitsForImage:(UIImage*) image {
    if (!image)
        return CGSizeZero;
    
    CGSize imageSize = image.size;
    CGFloat ratio = MIN(self.view.frame.size.width/imageSize.width, self.view.frame.size.height/imageSize.height);
    ratio = MIN(ratio, 1.0);//If the image is smaller than the screen let's not make it bigger
    return CGSizeMake(imageSize.width*ratio, imageSize.height*ratio);
}

#pragma mark - ZOOM
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return theImageView;
}

- (void) adjustScrollInsetsToCenterImage {
    CGSize imageSize = [self imageSizesizeThatFitsForImage:theImageView.image];
    zoomeableScrollView.zoomScale = 1.0;
    theImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    zoomeableScrollView.contentSize = theImageView.frame.size;
    
    CGRect innerFrame = theImageView.frame;
    CGRect scrollerBounds = zoomeableScrollView.bounds;
    CGPoint myScrollViewOffset = zoomeableScrollView.contentOffset;
    
    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
    {
        CGFloat tempx = theImageView.center.x - ( scrollerBounds.size.width / 2 );
        CGFloat tempy = theImageView.center.y - ( scrollerBounds.size.height / 2 );
        myScrollViewOffset = CGPointMake( tempx, tempy);
    }
    
    UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
    if ( scrollerBounds.size.width > innerFrame.size.width )
    {
        anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
        anEdgeInset.right = -anEdgeInset.left; // I don't know why this needs to be negative, but that's what works
    }
    if ( scrollerBounds.size.height > innerFrame.size.height )
    {
        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
        anEdgeInset.bottom = -anEdgeInset.top; // I don't know why this needs to be negative, but that's what works
    }
    
    zoomeableScrollView.contentOffset = myScrollViewOffset;
    zoomeableScrollView.contentInset = anEdgeInset;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView* view = theImageView;
    
    CGRect innerFrame = view.frame;
    CGRect scrollerBounds = scrollView.bounds;
    CGPoint myScrollViewOffset = scrollView.contentOffset;
    
    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
    {
        CGFloat tempx = view.center.x - ( scrollerBounds.size.width / 2 );
        CGFloat tempy = view.center.y - ( scrollerBounds.size.height / 2 );
        myScrollViewOffset = CGPointMake( tempx, tempy);
    }
    
    UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
    if ( scrollerBounds.size.width > innerFrame.size.width )
    {
        anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
        anEdgeInset.right = -anEdgeInset.left; // I don't know why this needs to be negative, but that's what works
    }
    if ( scrollerBounds.size.height > innerFrame.size.height )
    {
        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
        anEdgeInset.bottom = -anEdgeInset.top; // I don't know why this needs to be negative, but that's what works
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentOffset = myScrollViewOffset;
        scrollView.contentInset = anEdgeInset;
    }];
}

@end
