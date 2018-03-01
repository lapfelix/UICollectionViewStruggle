//
//  SPShadowView.m
//  CollectionViewShadows
//
//  Created by Felix Lapalme on 2018-03-01.
//  Copyright © 2018 Felix Lapalme. All rights reserved.
//

#import "SPShadowView.h"

@interface SPShadowView ()

@property (nonatomic, strong, readwrite) UIView *container;

@end

@implementation SPShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self addSubview:self.container];

        [NSLayoutConstraint activateConstraints:
         @[[self.container.topAnchor constraintEqualToAnchor:self.topAnchor constant:5],
           [self.container.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:5],
           [self.container.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-5],
           [self.container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5],
           ]
         ];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
}

#pragma mark - Getters

- (UIView *)container {
    if (!_container) {
        _container = [UIView new];
        _container.translatesAutoresizingMaskIntoConstraints = NO;
        _container.backgroundColor = UIColor.clearColor;
        _container.layer.cornerRadius = 10;
        _container.layer.shadowRadius = 25;
        _container.layer.shadowOffset = CGSizeMake(0, 5);
        _container.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
        _container.layer.shadowOpacity = 0.2;
    }

    return _container;
}

@end

