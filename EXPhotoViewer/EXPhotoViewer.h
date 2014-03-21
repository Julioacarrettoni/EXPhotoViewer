//
//  EXPhotoViewer.h
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPhotoViewer : UIViewController <UIScrollViewDelegate>{
    IBOutlet UIScrollView *zoomeableScrollView;
    IBOutlet UIImageView *theImageView;
    IBOutlet UIView *dimView;
}

+ (void) showImageFrom:(UIImageView*) image;

@end
