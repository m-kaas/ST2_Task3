//
//  ImageURLTableViewCell.h
//  ImagesTable
//
//  Created by Liubou Sakalouskaya on 6/15/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageURLTableViewCell : UITableViewCell

@property (weak, nonatomic) UIImageView *centeredImageView;
@property (weak, nonatomic) UILabel *imageURLLabel;
@property (copy, nonatomic) NSString *urlString;

@end

NS_ASSUME_NONNULL_END
