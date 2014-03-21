//
//  MainViewController.m
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import "MainViewController.h"
#import "ThumbCollectionCell.h"

#define CELL_NAME @"ThumbCollectionCell"

@interface MainViewController ()

@end

@implementation MainViewController {
    NSArray* imagesArray;
    __weak IBOutlet UICollectionView *photoCollectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    imagesArray = @[@"1_woman.jpg",
                    @"2_woman.jpg",
                    @"3_woman.jpg",
                    @"4_woman.jpg",
                    @"5_woman.jpg",
                    @"6_woman.jpg",
                    @"7_woman.jpg",
                    @"8_woman.jpg",
                    @"9_woman.jpg",
                    @"10_woman.jpg",
                    @"11_woman.jpg",
                    @"12_woman.jpg",
                    @"13_woman.jpg",
                    @"14_woman.jpg",
                    @"15_woman.jpg",
                    @"16_woman.jpg",
                    @"17_woman.jpg",
                    @"18_woman.jpg",
                    @"19_woman.jpg",
                    @"20_woman.jpg",
                    @"21_woman.jpg",
                    @"22_woman.jpg",
                    @"23_woman.jpg",
                    @"24_woman.jpg",
                    @"25_woman.jpg",
                    @"26_woman.jpg",
                    @"27_woman.jpg",
                    @"28_woman.jpg",
                    @"29_woman.jpg",
                    @"30_woman.jpg",];
    
    [photoCollectionView registerNib:[UINib nibWithNibName:CELL_NAME bundle:nil] forCellWithReuseIdentifier:CELL_NAME];
    [photoCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_NAME forIndexPath:indexPath];
    cell.thumbnailImage.image = [UIImage imageNamed:imagesArray[indexPath.row]];
    return cell;
}

@end
