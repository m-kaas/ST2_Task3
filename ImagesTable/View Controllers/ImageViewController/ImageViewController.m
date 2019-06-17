//
//  ImageViewController.m
//  ImagesTable
//
//  Created by Liubou Sakalouskaya on 6/15/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ImageViewController.h"
#import "ImageURLTableViewCell.h"

@interface ImageViewController ()

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation ImageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Image";
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.image) {
        self.image = [UIImage imageNamed:@"placeholderImage"];
    }
    [self setupImageView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)setupImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [NSLayoutConstraint activateConstraints:@[[self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:10],
        [self.view.safeAreaLayoutGuide.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:10],
        [self.view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:10]]];
}

#pragma mark - Notifications

- (void)imageChanged:(NSNotification *)notification {
    ImageURLTableViewCell *cell = notification.object;
    if (cell.didFailedLoadingImage) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.image = cell.centeredImageView.image;
    self.imageView.image = self.image;
}

@end
