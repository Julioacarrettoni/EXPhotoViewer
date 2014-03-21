//
//  ThumbCollectionCell.m
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import "ThumbCollectionCell.h"
#import "EXPhotoViewer.h"

@implementation ThumbCollectionCell

- (IBAction)onButtonTUI:(id)sender {
    [EXPhotoViewer showImageFrom:self.thumbnailImage];
}

@end
