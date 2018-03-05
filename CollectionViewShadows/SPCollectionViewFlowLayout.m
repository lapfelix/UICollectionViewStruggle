//
//  SPCollectionViewFlowLayout.m
//  CollectionViewShadows
//
//  Created by Felix Lapalme on 2018-03-01.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

#import "SPCollectionViewFlowLayout.h"

@interface SPCollectionViewFlowLayout()

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *preferredAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *previousAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *currentAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *previousSupplementaryAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *currentSupplementaryAttributes;

@property (nonatomic, assign) CGPoint initialContentOffset;

@property (nonatomic, assign) CGSize contentSize;

@end

@implementation SPCollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];

    self.previousAttributes = self.currentAttributes;
    self.previousSupplementaryAttributes = self.currentSupplementaryAttributes;

    self.currentAttributes = [NSMutableDictionary new];
    self.currentSupplementaryAttributes = [NSMutableDictionary new];

    self.contentSize = CGSizeZero;

    NSInteger sectionsCount = self.collectionView.numberOfSections;
    CGFloat y = 0;

    CGFloat width = self.collectionView.bounds.size.width;

    for (int section = 0; section < sectionsCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (int item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            UICollectionViewLayoutAttributes *preferredAttributes = self.preferredAttributes[indexPath];

            UICollectionViewLayoutAttributes *shadowAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:SPCollectionViewShadowElementKind withIndexPath:indexPath];

            CGFloat height = 50;
            if (preferredAttributes) {
                height = preferredAttributes.frame.size.height;
            }

            attributes.frame = CGRectMake(0, y, width, height);
            shadowAttributes.frame = attributes.frame;
            shadowAttributes.zIndex = -1;

            self.currentSupplementaryAttributes[indexPath] = shadowAttributes;
            self.currentAttributes[indexPath] = attributes;

            y += attributes.frame.size.height;
        }
    }

    self.contentSize = CGSizeMake(width, y);
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
    self.preferredAttributes[originalAttributes.indexPath] = preferredAttributes;
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.currentAttributes[indexPath];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {UICollectionViewLayoutAttributes *attributes = self.previousAttributes[itemIndexPath];
    if (attributes) {
        return attributes;
    }
    else {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return self.currentAttributes[itemIndexPath];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = self.previousSupplementaryAttributes[itemIndexPath];
    if (attributes) {
        return attributes;
    }
    else {
        return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:itemIndexPath];
    }
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    return self.currentSupplementaryAttributes[elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    return self.currentSupplementaryAttributes[indexPath];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *newAttributes = [NSMutableArray new];
    NSMutableArray<UICollectionViewLayoutAttributes *> *normalAttributes = [NSMutableArray new];//[super layoutAttributesForElementsInRect:rect];

    for (UICollectionViewLayoutAttributes *attributes in self.currentAttributes.allValues) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [normalAttributes addObject:attributes];
        }
    }

    for (UICollectionViewLayoutAttributes *attributes in self.currentSupplementaryAttributes.allValues) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [normalAttributes addObject:attributes];
        }
    }

    return [normalAttributes arrayByAddingObjectsFromArray:newAttributes.copy];
}

#pragma mark - Getters

- (NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *)previousAttributes {
    if (!_previousAttributes) {
        _previousAttributes = [NSMutableDictionary new];
    }

    return _previousAttributes;
}

- (NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *)currentAttributes {
    if (!_currentAttributes) {
        _currentAttributes = [NSMutableDictionary new];
    }

    return _currentAttributes;
}

- (NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *)previousSupplementaryAttributes {
    if (!_previousSupplementaryAttributes) {
        _previousSupplementaryAttributes = [NSMutableDictionary new];
    }

    return _previousSupplementaryAttributes;
}

- (NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *)currentSupplementaryAttributes {
    if (!_currentSupplementaryAttributes) {
        _currentSupplementaryAttributes = [NSMutableDictionary new];
    }

    return _currentSupplementaryAttributes;
}

- (NSMutableDictionary *)preferredAttributes {
    if (!_preferredAttributes) {
        _preferredAttributes = [NSMutableDictionary new];
    }

    return _preferredAttributes;
}

@end
