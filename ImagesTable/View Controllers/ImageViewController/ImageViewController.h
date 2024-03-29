//
//  ImageViewController.h
//  ImagesTable
//
//  Created by Liubou Sakalouskaya on 6/15/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController

@property (copy, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;

- (void)imageChanged:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
