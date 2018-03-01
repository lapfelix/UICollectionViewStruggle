//
//  SPCollectionViewFlowLayout.m
//  CollectionViewShadows
//
//  Created by Felix Lapalme on 2018-03-01.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

#import "SPCollectionViewFlowLayout.h"

@interface SPCollectionViewFlowLayout()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) CGFloat springDamping;
@property (nonatomic, assign) CGFloat springFrequency;

@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *previousAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *currentAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *previousSupplementaryAttributes;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *currentSupplementaryAttributes;

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGPoint initialContentOffset;

@end

@implementation SPCollectionViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.springDamping = 0.5;
        self.springFrequency = 1;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];

    self.previousAttributes = self.currentAttributes;
    self.previousSupplementaryAttributes = self.currentSupplementaryAttributes;

    self.contentSize = CGSizeZero;

    self.currentAttributes = [NSMutableDictionary new];
    self.currentSupplementaryAttributes = [NSMutableDictionary new];
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
}

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
    return [super shouldInvalidateLayoutForPreferredLayoutAttributes:preferredAttributes withOriginalAttributes:originalAttributes];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    self.currentAttributes[indexPath] = attributes;
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attributes = self.previousAttributes[itemIndexPath];
    if (attributes) {
        return attributes;
    }
    else {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
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
    return [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:elementIndexPath];
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

// This method is called when there is an update with deletes/inserts to the collection view.
// It will be called prior to calling the initial/final layout attribute methods below to give the layout an opportunity to do batch computations for the insertion and deletion layout attributes.
// The updateItems parameter is an array of UICollectionViewUpdateItem instances for each element that is moving to a new index path.
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    [super prepareForCollectionViewUpdates:updateItems];
}
- (void)finalizeCollectionViewUpdates {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    [super finalizeCollectionViewUpdates];
} // called inside an animation block after the update
/*
 - (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 [super prepareForAnimatedBoundsChange:oldBounds];
 } // UICollectionView calls this when its bounds have changed inside an animation block before displaying cells in its new bounds
 - (void)finalizeAnimatedBoundsChange {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 [super finalizeAnimatedBoundsChange];
 } // also called inside the animation block
 */
// UICollectionView calls this when prior the layout transition animation on the incoming and outgoing layout
- (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout NS_AVAILABLE_IOS(7_0) {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    [super prepareForTransitionToLayout:newLayout];

}
- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout NS_AVAILABLE_IOS(7_0) {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    [super prepareForTransitionFromLayout:oldLayout];

}
- (void)finalizeLayoutTransition NS_AVAILABLE_IOS(7_0) {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    [super finalizeLayoutTransition];

} // called inside an animation block after the transition

// This set of methods is called when the collection view undergoes an animated transition such as a batch update block or an animated bounds change.
// For each element on screen before the invalidation, finalLayoutAttributesForDisappearingXXX will be called and an animation setup from what is on screen to those final attributes.
// For each element on screen after the invalidation, initialLayoutAttributesForAppearingXXX will be called and an animation setup from those initial attributes to what ends up on screen.
/*
 - (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 return    [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
 }
 - (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 return   [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];

 }
 - (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 return   [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];

 }
 - (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 return    [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];

 }
 - (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 return   [super initialLayoutAttributesForAppearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];

 }
 - (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
 NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
 return   [super finalLayoutAttributesForDisappearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];

 }
 */

// These methods are called by collection view during an update block.
// Return an array of index paths to indicate views that the layout is deleting or inserting in response to the update.
- (NSArray<NSIndexPath *> *)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0) {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    return    [super indexPathsToDeleteForSupplementaryViewOfKind:elementKind];

}
- (NSArray<NSIndexPath *> *)indexPathsToDeleteForDecorationViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0) {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    return    [super indexPathsToDeleteForDecorationViewOfKind:elementKind];

}
- (NSArray<NSIndexPath *> *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0) {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    return  [super indexPathsToInsertForSupplementaryViewOfKind:elementKind];

}
- (NSArray<NSIndexPath *> *)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(7_0) {
    NSLog(@"- - - - %@",NSStringFromSelector(_cmd));
    return [super indexPathsToInsertForDecorationViewOfKind:elementKind];

}
#pragma mark - Getters

- (UIDynamicAnimator *)animator {
    if (!_animator) {

        _animator = [UIDynamicAnimator new];
        _animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        CGSize contentSize = [self collectionViewContentSize];
        NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];

        for (UICollectionViewLayoutAttributes *item in items) {
            UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];

            spring.length = 0;
            spring.damping = self.springDamping;
            spring.frequency = self.springFrequency;

            [_animator addBehavior:spring];
        }
    }

    return _animator;
}

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
