//
//  ImageURLTableViewCell.m
//  ImagesTable
//
//  Created by Liubou Sakalouskaya on 6/15/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ImageURLTableViewCell.h"

static void *ImageViewImageContext = &ImageViewImageContext;

@implementation ImageURLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCenteredImageView];
        [self setupImageURLLabel];
        [self setupConstraints];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.centeredImageView.image = [UIImage imageNamed:@"placeholderImage"];
}

- (void)setupCenteredImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.contentView addSubview:imageView];
    self.centeredImageView = imageView;
    [self.centeredImageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:ImageViewImageContext];
    self.centeredImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.centeredImageView.userInteractionEnabled = YES;
}

- (void)setupImageURLLabel {
    UILabel *label = [UILabel new];
    [self.contentView addSubview:label];
    self.imageURLLabel = label;
    self.imageURLLabel.numberOfLines = 0;
    self.imageURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupConstraints {
    CGFloat aspectRatio = self.centeredImageView.image.size.height / self.centeredImageView.image.size.width;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.centeredImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
                                              [self.centeredImageView.topAnchor constraintGreaterThanOrEqualToAnchor:self.imageURLLabel.topAnchor],
                                              [self.centeredImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [self.centeredImageView.widthAnchor constraintEqualToConstant:80],
                                              [self.centeredImageView.heightAnchor constraintEqualToAnchor:self.centeredImageView.widthAnchor multiplier:aspectRatio],
                                              [self.imageURLLabel.leadingAnchor constraintEqualToAnchor:self.centeredImageView.trailingAnchor constant:25],
                                              [self.contentView.trailingAnchor constraintEqualToAnchor:self.imageURLLabel.trailingAnchor constant:20],
                                              [self.imageURLLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
                                              [self.contentView.bottomAnchor constraintEqualToAnchor:self.imageURLLabel.bottomAnchor constant:20]
                                              ]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ImageViewImageContext) {
        UIImage *oldImageView = change[NSKeyValueChangeOldKey];
        UIImage *newImageView = change[NSKeyValueChangeNewKey];
        CGFloat aspectRatioOld = oldImageView.size.height / oldImageView.size.width;
        CGFloat aspectRatioNew = newImageView.size.height / newImageView.size.width;
        if (aspectRatioNew != aspectRatioOld) {
            [self updateImageAspectRatioConstraint];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateImageAspectRatioConstraint {
    CGFloat aspectRatio = self.centeredImageView.image.size.height / self.centeredImageView.image.size.width;
    for (NSLayoutConstraint *constraint in self.constraints) {
        if ([constraint.firstAnchor isEqual:self.centeredImageView.heightAnchor] && [constraint.secondAnchor isEqual:self.centeredImageView.widthAnchor]) {
            [self removeConstraint:constraint];
            [NSLayoutConstraint activateConstraints:@[[self.centeredImageView.heightAnchor constraintEqualToAnchor:self.centeredImageView.widthAnchor multiplier:aspectRatio]]];
        }
    }
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = [urlString copy];
    self.imageURLLabel.text = _urlString;
}

- (void)dealloc
{
    [_centeredImageView removeObserver:self forKeyPath:@"image"];
    _centeredImageView = nil;
    _imageURLLabel = nil;
}

@end
