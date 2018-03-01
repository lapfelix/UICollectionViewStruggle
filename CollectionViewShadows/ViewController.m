//
//  ViewController.m
//  CollectionViewShadows
//
//  Created by Felix Lapalme on 2018-03-01.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

#import "ViewController.h"
#import "SPCollectionViewFlowLayout.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SPCollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray<UIColor *> *colors;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *expandedCells;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;

    self.colors = @[[UIColor.blueColor colorWithAlphaComponent:0.3],
                    [UIColor.redColor colorWithAlphaComponent:0.3],
                    [UIColor.greenColor colorWithAlphaComponent:0.3],
                    [UIColor.cyanColor colorWithAlphaComponent:0.3],
                    [UIColor.grayColor colorWithAlphaComponent:0.3],
                    [UIColor.blackColor colorWithAlphaComponent:0.3],
                    [UIColor.brownColor colorWithAlphaComponent:0.3]];

    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.frame;
    self.collectionView.autoresizingMask = self.view.autoresizingMask;
    self.collectionView.contentInset = UIEdgeInsetsMake(400, 0, 0, 0);
    self.collectionView.alwaysBounceVertical = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView stuff

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;//self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL selected = [self.collectionView.indexPathsForSelectedItems containsObject:indexPath];
    return CGSizeMake(collectionView.bounds.size.width, selected ? 900 : 150);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self animateLayout];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self animateLayout];
}

- (void)animateLayout {
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.4
                                                          delay:0
                                                        options:0
                                                     animations:^{
                                                         [self.flowLayout invalidateLayout];
                                                         [self.collectionView layoutIfNeeded];
                                                     } completion:^(UIViewAnimatingPosition finalPosition) {

                                                     }];
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:UICollectionViewCell.class
            forCellWithReuseIdentifier:@"cell"];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.allowsSelection = YES;
        _collectionView.backgroundColor = UIColor.whiteColor;
    }

    return _collectionView;
}

- (SPCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [SPCollectionViewFlowLayout new];
    }

    return _flowLayout;
}

- (NSMutableArray<NSIndexPath *> *)expandedCells {
    if (!_expandedCells) {
        _expandedCells = [NSMutableArray new];
    }

    return _expandedCells;
}

@end
