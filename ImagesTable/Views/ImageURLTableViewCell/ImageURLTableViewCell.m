//
//  ImageURLTableViewCell.m
//  ImagesTable
//
//  Created by Liubou Sakalouskaya on 6/15/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ImageURLTableViewCell.h"

static void *ImageViewImageContext = &ImageViewImageContext;

@interface ImageURLTableViewCell ()

@property (assign, nonatomic) BOOL didSetupConstraints;

@end

@implementation ImageURLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCenteredImageView];
        [self setupImageURLLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.centeredImageView.image = [UIImage imageNamed:@"placeholderImage"];
    self.isImageLoaded = NO;
    self.didFailedLoadingImage = NO;
}

- (void)setupCenteredImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderImage"]];
    self.isImageLoaded = NO;
    [self.contentView addSubview:imageView];
    self.centeredImageView = imageView;
    [self.centeredImageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:ImageViewImageContext];
    self.centeredImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.centeredImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageViewTap:)];
    [self.centeredImageView addGestureRecognizer:tap];
}

- (void)setupImageURLLabel {
    UILabel *label = [UILabel new];
    [self.contentView addSubview:label];
    self.imageURLLabel = label;
    self.imageURLLabel.numberOfLines = 0;
    self.imageURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageURLLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisVertical];
}

- (void)updateConstraints {
    [super updateConstraints];
    if (!self.didSetupConstraints) {
        [NSLayoutConstraint activateConstraints:@[
              [self.centeredImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
              [self.centeredImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
              [self.centeredImageView.widthAnchor constraintEqualToConstant:100],
              [self.contentView.heightAnchor constraintGreaterThanOrEqualToAnchor:self.centeredImageView.heightAnchor multiplier:1.0 constant:40],
              [self.imageURLLabel.leadingAnchor constraintEqualToAnchor:self.centeredImageView.trailingAnchor constant:25],
              [self.imageURLLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
              [self.contentView.trailingAnchor constraintEqualToAnchor:self.imageURLLabel.trailingAnchor constant:20],
              [self.contentView.bottomAnchor constraintEqualToAnchor:self.imageURLLabel.bottomAnchor constant:20]
              ]];
        self.didSetupConstraints = YES;
    } else {
        for (NSLayoutConstraint *constraint in self.centeredImageView.constraints) {
            if ([constraint.firstAnchor isEqual:self.centeredImageView.heightAnchor] && [constraint.secondAnchor isEqual:self.centeredImageView.widthAnchor]) {
                [self.centeredImageView removeConstraint:constraint];
                break;
            }
        }
    }
    CGFloat aspectRatio = self.centeredImageView.image.size.height / self.centeredImageView.image.size.width;
    NSLayoutConstraint *aspectRatioConstraint = [self.centeredImageView.heightAnchor constraintEqualToAnchor:self.centeredImageView.widthAnchor multiplier:aspectRatio];
    aspectRatioConstraint.priority = 999;
    [NSLayoutConstraint activateConstraints:@[aspectRatioConstraint]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ImageViewImageContext) {
        UIImage *oldImageView = change[NSKeyValueChangeOldKey];
        UIImage *newImageView = change[NSKeyValueChangeNewKey];
        CGFloat aspectRatioOld = oldImageView.size.height / oldImageView.size.width;
        CGFloat aspectRatioNew = newImageView.size.height / newImageView.size.width;
        if (aspectRatioNew != aspectRatioOld) {
            [self setNeedsUpdateConstraints];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageURLTableViewCellImageChanged" object:self];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = [urlString copy];
    self.imageURLLabel.text = _urlString;
}

- (void)onImageViewTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didTapOnImageViewInCell:)]) {
        [self.delegate didTapOnImageViewInCell:self];
    }
}

- (void)dealloc
{
    [_centeredImageView removeObserver:self forKeyPath:@"image"];
    _centeredImageView = nil;
    _imageURLLabel = nil;
}

@end
