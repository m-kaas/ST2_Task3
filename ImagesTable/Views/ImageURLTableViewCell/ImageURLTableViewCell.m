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

#pragma mark - Lifecycle

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

- (void)updateConstraints {
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
            if ([constraint.identifier isEqualToString:@"heightConstraint"]) {
                [self.centeredImageView removeConstraint:constraint];
                break;
            }
        }
    }
    CGFloat aspectRatio = self.centeredImageView.image.size.height / self.centeredImageView.image.size.width;
    NSLayoutConstraint *heightConstraint = [self.centeredImageView.heightAnchor constraintEqualToConstant:aspectRatio*100];
    heightConstraint.identifier = @"heightConstraint";
    heightConstraint.priority = UILayoutPriorityRequired-1;
    [NSLayoutConstraint activateConstraints:@[heightConstraint]];
    [super updateConstraints];
}

- (void)dealloc
{
    [_centeredImageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - Private

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

#pragma mark - Key-Value Observing

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

#pragma mark - Custom Accessors

- (void)setUrlString:(NSString *)urlString {
    _urlString = [urlString copy];
    self.imageURLLabel.text = _urlString;
}

#pragma mark - Gesture Recognizers

- (void)onImageViewTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didTapOnImageViewInCell:)]) {
        [self.delegate didTapOnImageViewInCell:self];
    }
}

@end
