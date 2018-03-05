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
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));

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
    /*
    if let collectionView = collectionView {
        let itemCount = collectionView.numberOfItems(inSection: 0)

        for itemIndex in 0..<itemCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let preferredAttributesForCell = self.preferredAttributesDict[IndexPath(item: itemIndex, section: 0)]
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let size = CGSize(
                              width: width,
                              height: preferredAttributesForCell != nil ? preferredAttributesForCell!.frame.size.height : CGFloat(50.0)
                              )

            attributes.frame = CGRect(x:0, y:y, width:width, height:size.height)

            currentAttributes.append(attributes)

            y += size.height
        }

        contentSize = CGSize(width:width, height:y)
    }
     */
}
/*
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
*/
/*
override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
    preferredAttributesDict[originalAttributes.indexPath] = preferredAttributes
    return true
}
*/

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    /*
    BOOL shouldUpdate = [super shouldInvalidateLayoutForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
    */
    self.preferredAttributes[originalAttributes.indexPath] = preferredAttributes;

    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSLog(@"- - - - %@ %@",NSStringFromSelector(_cmd), [indexPath description]);

    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    self.currentAttributes[indexPath] = attributes;
    */
    return self.currentAttributes[indexPath];
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

   //UICollectionViewLayoutAttributes *finalAttributes = [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    return self.currentSupplementaryAttributes[elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
/*
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
    */
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
/*
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *cellAttributes in normalAttributes) {
        if (![indexPaths containsObject:cellAttributes.indexPath]) {
            [indexPaths addObject:cellAttributes.indexPath];

            if (CGRectIntersectsRect(rect, cellAttributes.frame)) {


                //we inject the shadow attributes
                if (shadowAttributes) {
                    [newAttributes addObject:shadowAttributes];
                }
            }
        }
    }
*/
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
