//
//  ViewController.m
//  CollectionViewShadows
//
//  Created by Felix Lapalme on 2018-03-01.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

#import "ViewController.h"
#import "SPCollectionViewFlowLayout.h"
#import "SPShadowView.h"
#import "SPTextCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SPCollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray<UIColor *> *colors;
@property (nonatomic, strong) NSArray<NSString *> *texts;
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
                    [UIColor.brownColor colorWithAlphaComponent:0.3],
                    [UIColor.redColor colorWithAlphaComponent:0.3],
                    [UIColor.greenColor colorWithAlphaComponent:0.3],
                    [UIColor.cyanColor colorWithAlphaComponent:0.3],
                    [UIColor.grayColor colorWithAlphaComponent:0.3],
                    [UIColor.blackColor colorWithAlphaComponent:0.3],
                    [UIColor.brownColor colorWithAlphaComponent:0.3]];

    self.texts = @[@"layoutMargins returns a set of insets from the edge of the view's bounds that denote a default spaciom the edge of the view's bounds that denote a default spaciom the edge of the view's bounds that denote a default spaciom the edge of the view's bounds that denote a default spaciom the edge of the view's bounds that denote a default spacing for laying out content.",
                   @"If preservesSuperviewLayoutMargins iins iins iins iins is YES, margins cascade down the view tree, adjusting for geometry offsets, so that settin",
                   @"the left value of layoutMargins on a superi superi superi superins iins iins iins iview will affect the left value of layoutMargins for subviews positioned close to the",
                   @"left edge of their superviewheir superviewheir superviewheir superviewheir superview's bounds",
                   @"If your view subclass uses layoutMargins in its layout or drawing, override -layoutMains in its layout or drawing, override -layoutMains in its layout or drawing, override -layoutMarginsDidChange in order to refresh your",
                   @"view if the margins change.",
                   @"On iOS 11.0 and later, please supphe layoutMargins property will depend on the user interface layout diirections by setting the directionalLayoutMargins property",
                   @"instead of the layoutMargins property. After setting the directionalLayoutMargins property, the values in the left and right",
                   @"fields of the layoutMargins property will depend on the user interface layout dihe layoutMargins property will depend on the user interface layout dihe layoutMargins property will depend on the user interface layout direction.",
                   @"If your view subclass uses layoutMargins in its layout or drawing, override -layouass uses layoutMargins in its layout or drawing, override -layouass uses layoutMargins in its layout or drawing, override -layoutMarginsDidChange in order to refresh your",
                   @"view if the marass uses layoutMargins in its layout or drawing, override -layougins change.",
                   @"On iOS 11.0 and ass uses layoutMargins in its layout or drawing, override -layoulater, please support both user interface layout directions by setting the directionalLayoutMargins property",
                   @"instead of the laass uses layoutMargins in its layout or drawing, override -layouyoutMargins property. After setting the directionalLayoutMargins property, the values in the left and right",
                   @"fields of the lass uses layoutMargins in its layout or drawing, override -layouayoutMargins property will depend on the user interface layout direction."];

    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.frame;
    self.collectionView.autoresizingMask = self.view.autoresizingMask;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.alwaysBounceVertical = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView stuff

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SPTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    cell.text = self.texts[indexPath.row];
    cell.width = collectionView.bounds.size.width;
    cell.label.numberOfLines = [collectionView.indexPathsForSelectedItems containsObject:indexPath] ? 0 : 1;
    return cell;
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL selected = [self.collectionView.indexPathsForSelectedItems containsObject:indexPath];
    return CGSizeMake(collectionView.bounds.size.width, selected ? 900 : 150);
}
*/

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    SPTextCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.label.numberOfLines = 1;

    [self animateLayoutForIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SPTextCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.label.numberOfLines = 0;

    [self animateLayoutForIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:SPCollectionViewShadowElementKind]) {
        SPShadowView *shadowView = [collectionView dequeueReusableSupplementaryViewOfKind:SPCollectionViewShadowElementKind
                                                                      withReuseIdentifier:SPCollectionViewShadowElementKind
                                                                             forIndexPath:indexPath];

        shadowView.container.alpha = (indexPath.row % 2 == 0) ? 1 : 0;
        shadowView.container.backgroundColor = self.colors[(indexPath.row - 2) % self.colors.count];
        return shadowView;
    }

    return [collectionView dequeueReusableSupplementaryViewOfKind:SPCollectionViewNoShadowElementKind
                                              withReuseIdentifier:SPCollectionViewNoShadowElementKind
                                                     forIndexPath:indexPath];
}

- (void)animateLayoutForIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:3.3 animations:^{
        //UICollectionViewFlowLayoutInvalidationContext *invalidationContext = [[UICollectionViewFlowLayoutInvalidationContext alloc] init];
        //[invalidationContext invalidateItemsAtIndexPaths:@[indexPath]];
        //[invalidationContext invalidateSupplementaryElementsOfKind:SPCollectionViewShadowElementKind atIndexPaths:@[indexPath]];
        //[self.flowLayout invalidateLayoutWithContext:invalidationContext];

        [self.flowLayout invalidateLayout];
        [self.collectionView layoutIfNeeded];
    }];
}

#pragma mark - Getters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:SPTextCollectionViewCell.class
            forCellWithReuseIdentifier:@"cell"];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.allowsSelection = YES;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:SPShadowView.class
 forSupplementaryViewOfKind:SPCollectionViewShadowElementKind
        withReuseIdentifier:SPCollectionViewShadowElementKind];
        [_collectionView registerClass:UICollectionReusableView.class
 forSupplementaryViewOfKind:SPCollectionViewNoShadowElementKind
        withReuseIdentifier:SPCollectionViewNoShadowElementKind];
    }

    return _collectionView;
}

- (SPCollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [SPCollectionViewFlowLayout new];
        //_flowLayout.minimumLineSpacing = 0;
        //_flowLayout.minimumInteritemSpacing = 0;
        //_flowLayout.sectionInset = UIEdgeInsetsMake(50, 0, 14, 0);
        //_flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
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
