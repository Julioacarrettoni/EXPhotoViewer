//
//  EXPhotoViewer.m
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import "EXPhotoViewer.h"

@interface EXPhotoViewer ()

@property (nonatomic, retain) UIScrollView *zoomeableScrollView;
@property (nonatomic, retain) UIImageView *originalImageView;
@property (nonatomic, retain) UIImageView *theImageView;
@property (nonatomic, retain) UIView* tempViewContainer;
@property (nonatomic, assign) CGRect originalImageRect;
@property (nonatomic, retain) UIViewController* controller;
@property (nonatomic, retain) UIViewController* selfController;
@property (atomic, readwrite) BOOL isClosing;

@end

@implementation EXPhotoViewer

+ (instancetype)showImageFrom:(UIImageView *)imageView {
    EXPhotoViewer *viewer = [self newViewerFor:imageView];

    [viewer show];

    return viewer;
}

+ (instancetype)newViewerFor:(UIImageView *)imageView {
    EXPhotoViewer *viewer = nil;

    if (imageView.image) {
        viewer = [[self alloc] init];
        viewer.originalImageView = imageView;
        viewer.backgroundScale = 1.0;
    }

    return viewer;
}

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.maximumZoomScale = 10.f;
    scrollView.minimumZoomScale = 1.f;
    scrollView.delegate = self;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: scrollView];
    self.zoomeableScrollView = scrollView;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.clipsToBounds = YES;
    imageView.contentMode = self.originalImageView.contentMode;
    [self.zoomeableScrollView addSubview: imageView];
    self.theImageView = imageView;
}

-(UIViewController *)rootViewController {
    UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([controller presentedViewController]) {
        controller = [controller presentedViewController];
    }
    return controller;
}

- (void)show {
    if (self.controller)
        return;

    UIViewController * controller = [self rootViewController];
    
    self.tempViewContainer = [[UIView alloc] initWithFrame:controller.view.bounds];
    self.tempViewContainer.backgroundColor = controller.view.backgroundColor;
    controller.view.backgroundColor = [UIColor blackColor];
    
    for (UIView* subView in controller.view.subviews) {
        [self.tempViewContainer addSubview:subView];
    }
    
    [controller.view addSubview:self.tempViewContainer];
    
    self.controller = controller;
    
    self.view.frame = controller.view.bounds; //CGRectZero;
    self.view.backgroundColor = [UIColor clearColor];
    
    [controller.view addSubview:self.view];

    self.theImageView.image = self.originalImageView.image;
    self.originalImageRect = [self.originalImageView convertRect:self.originalImageView.bounds toView:self.view];

    self.theImageView.frame = self.originalImageRect;
    
    //listen to the orientation change notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = (self.backgroundColor) ? self.backgroundColor : [UIColor blackColor];
        self.tempViewContainer.layer.transform = CATransform3DMakeScale(self.backgroundScale, self.backgroundScale, self.backgroundScale);
        self.theImageView.frame = [self centeredOnScreenImage:self.theImageView.image];
    } completion:^(BOOL finished) {
        [self adjustScrollInsetsToCenterImage];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self.view addGestureRecognizer:tap];
    }];

    self.selfController = self; //Stupid ARC I need to do this to avoid being dealloced :P
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];}

- (void)orientationDidChange:(NSNotification *)note {
    self.theImageView.frame = [self centeredOnScreenImage:self.theImageView.image];

    CGRect newFrame = [self rootViewController].view.bounds;
    self.tempViewContainer.frame = newFrame;
    self.view.frame = newFrame;
    [self adjustScrollInsetsToCenterImage];
}

- (void)close {
    if (!self.isClosing) {
        self.isClosing = YES;

        CGRect absoluteCGRect = [self.view convertRect:self.theImageView.frame fromView:self.theImageView.superview];
        self.zoomeableScrollView.contentOffset = CGPointZero;
        self.zoomeableScrollView.contentInset = UIEdgeInsetsZero;
        self.theImageView.frame = absoluteCGRect;

        [UIView animateWithDuration:0.3 animations:^{
            self.theImageView.frame = self.originalImageRect;
            self.view.backgroundColor = [UIColor clearColor];
            self.tempViewContainer.layer.transform = CATransform3DIdentity;
        }completion:^(BOOL finished) {
            self.originalImageView.image = self.theImageView.image;
            self.controller.view.backgroundColor = self.tempViewContainer.backgroundColor;
            for (UIView* subView in self.tempViewContainer.subviews) {
                [self.controller.view addSubview:subView];
            }
            [self.view removeFromSuperview];
            [self.tempViewContainer removeFromSuperview];

            self.isClosing = NO;
        }];

        self.selfController = nil;//Ok ARC you can kill me now.
    }
}

- (CGRect)centeredOnScreenImage:(UIImage*) image {
    CGSize imageSize = [self imageSizesizeThatFitsForImage:self.theImageView.image];
    CGPoint imageOrigin = CGPointMake(self.view.frame.size.width/2.0 - imageSize.width/2.0, self.view.frame.size.height/2.0 - imageSize.height/2.0);
    return CGRectMake(imageOrigin.x, imageOrigin.y, imageSize.width, imageSize.height);
}

- (CGSize)imageSizesizeThatFitsForImage:(UIImage*) image {
    if (!image)
        return CGSizeZero;
    
    CGSize imageSize = image.size;
    CGFloat ratio = MIN(self.view.frame.size.width/imageSize.width, self.view.frame.size.height/imageSize.height);
    return CGSizeMake(imageSize.width*ratio, imageSize.height*ratio);
}

#pragma mark - ZOOM
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.theImageView;
}

- (void)adjustScrollInsetsToCenterImage {
    CGSize imageSize = [self imageSizesizeThatFitsForImage:self.theImageView.image];
    self.zoomeableScrollView.zoomScale = 1.0;
    self.theImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    self.zoomeableScrollView.contentSize = self.theImageView.frame.size;
    
    CGRect innerFrame = self.theImageView.frame;
    CGRect scrollerBounds = self.zoomeableScrollView.bounds;
    CGPoint myScrollViewOffset = self.zoomeableScrollView.contentOffset;
    
    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
    {
        CGFloat tempx = self.theImageView.center.x - ( scrollerBounds.size.width / 2 );
        CGFloat tempy = self.theImageView.center.y - ( scrollerBounds.size.height / 2 );
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
    
    self.zoomeableScrollView.contentOffset = myScrollViewOffset;
    self.zoomeableScrollView.contentInset = anEdgeInset;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView* view = self.theImageView;
    
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
