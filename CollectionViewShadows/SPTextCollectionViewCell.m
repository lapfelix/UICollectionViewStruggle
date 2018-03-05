//
//  SPTextCollectionViewCell.m
//  CollectionViewShadows
//
//  Created by Felix Lapalme on 2018-03-01.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

#import "SPTextCollectionViewCell.h"

@interface SPTextCollectionViewCell()

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation SPTextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
        [NSLayoutConstraint activateConstraints:
         @[[self.label.topAnchor constraintEqualToAnchor:self.topAnchor constant:5],
           [self.label.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0],
           [self.label.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0],
           [self.label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5]]
         ];

        self.widthConstraint = [self.label.widthAnchor constraintEqualToConstant:150];
        self.widthConstraint.priority = 999;
        self.widthConstraint.active = YES;
    }

    return self;
}

- (void)setText:(NSString *)text {
    _text = text;

    self.label.text = text;
}

- (void)setWidth:(CGFloat)width {
    _width = width;

    self.widthConstraint.constant = width;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.numberOfLines = 0;
    }

    return _label;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CGRect frame = layoutAttributes.frame;
    frame.size.height = [self systemLayoutSizeFittingSize:CGSizeMake(frame.size.width, UIViewNoIntrinsicMetric)
                            withHorizontalFittingPriority:UILayoutPriorityRequired
                                  verticalFittingPriority:UILayoutPriorityDefaultLow].height;
    layoutAttributes.frame = frame;
    return layoutAttributes;
}

/*

 override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
 var frame = layoutAttributes.frame
 //todo: the width, but correctly
 frame.size = label.systemLayoutSizeFitting(CGSize(width: 375, height: UIViewNoIntrinsicMetric),
 withHorizontalFittingPriority: .required,
 verticalFittingPriority: .defaultLow)
 layoutAttributes.frame = frame
 return layoutAttributes
 }
 */

@end
