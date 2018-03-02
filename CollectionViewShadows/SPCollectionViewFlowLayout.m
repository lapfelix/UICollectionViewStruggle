//
//  SPCollectionViewFlowLayout.m
//  CollectionViewShadows
//
//  Created by Felix Lapalme on 2018-03-01.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

#import "SPCollectionViewFlowLayout.h"

@interface SPCollectionViewFlowLayout()

//@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *previousValidAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *previousAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *currentAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *previousSupplementaryAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *currentSupplementaryAttributes;

@property (nonatomic, assign) CGPoint initialContentOffset;

@end

@implementation SPCollectionViewFlowLayout

- (void)prepareLayout {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));

    [super prepareLayout];

    self.previousAttributes = self.currentAttributes;
    self.previousSupplementaryAttributes = self.currentSupplementaryAttributes;

    self.currentAttributes = [NSMutableDictionary new];
    self.currentSupplementaryAttributes = [NSMutableDictionary new];
}

- (void)invalidateLayoutWithContext:(UICollectionViewFlowLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));

    if (context.invalidateEverything) {
        self.currentAttributes = self.previousAttributes;
    }

    for (NSIndexPath *indexPath in context.invalidatedItemIndexPaths) {
        UICollectionViewLayoutAttributes *previousAttributes = self.previousAttributes[indexPath];
        if (previousAttributes) {
            self.currentAttributes[indexPath] = previousAttributes;
        }

        previousAttributes = self.previousSupplementaryAttributes[indexPath];
        if (previousAttributes) {
            self.currentSupplementaryAttributes[indexPath] = previousAttributes;
        }
    }
}

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));

    BOOL shouldUpdate = [super shouldInvalidateLayoutForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
    if (shouldUpdate) {
        return YES;
    }
    else {
        return NO;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"- - - - %@ %@",NSStringFromSelector(_cmd), [indexPath description]);

    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    self.currentAttributes[indexPath] = attributes;
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    NSLog(@"- - - - %@ %@",NSStringFromSelector(_cmd), [itemIndexPath description]);

    UICollectionViewLayoutAttributes *attributes = self.previousAttributes[itemIndexPath];
    if (attributes) {
        return attributes;
    }
    else {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    NSLog(@"- - - - %@ %@",NSStringFromSelector(_cmd), [itemIndexPath description]);

    UICollectionViewLayoutAttributes *attributes = self.currentAttributes[itemIndexPath];// [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    if (attributes.frame.origin.y > 900) {
        NSLog(@"uh");
    }
    else if (attributes.frame.size.width == 50) {
        NSLog(@"u2h");
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)itemIndexPath {
    NSLog(@"- - - - %@ %@",NSStringFromSelector(_cmd), [itemIndexPath description]);

    UICollectionViewLayoutAttributes *attributes = self.previousSupplementaryAttributes[itemIndexPath];
    if (attributes) {
        return attributes;
    }
    else {
        return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:itemIndexPath];
    }
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    NSLog(@"- - - - %@ %@",NSStringFromSelector(_cmd), [elementIndexPath description]);

    UICollectionViewLayoutAttributes *finalAttributes = [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    return finalAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes;
    if ([elementKind isEqualToString:SPCollectionViewShadowElementKind]) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        attributes.zIndex = -1;
        attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    }
    else if ([elementKind isEqualToString:SPCollectionViewNoShadowElementKind]) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        attributes.zIndex = -1;
        attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    }

    self.currentSupplementaryAttributes[indexPath] = attributes;

    if (!attributes) {
        NSLog(@"uh oh");
    }
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *newAttributes = [NSMutableArray new];
    NSArray<UICollectionViewLayoutAttributes *> *normalAttributes = [super layoutAttributesForElementsInRect:rect];

    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *cellAttributes in normalAttributes) {
        if (![indexPaths containsObject:cellAttributes.indexPath]) {
            [indexPaths addObject:cellAttributes.indexPath];

            if (CGRectIntersectsRect(rect, cellAttributes.frame)) {
                UICollectionViewLayoutAttributes *shadowAttributes = [self layoutAttributesForSupplementaryViewOfKind:SPCollectionViewShadowElementKind atIndexPath:cellAttributes.indexPath];

                //we inject the shadow attributes
                if (shadowAttributes) {
                    [newAttributes addObject:shadowAttributes];
                }
            }
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
@end
