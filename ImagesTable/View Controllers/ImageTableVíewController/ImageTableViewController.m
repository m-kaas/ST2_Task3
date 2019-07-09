//
//  ImageTableViewController.m
//  ImagesTable
//
//  Created by Liubou Sakalouskaya on 6/15/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ImageTableViewController.h"
#import "ImageURLTableViewCell.h"
#import "ImageViewController.h"

NSString * const imageNotificationImageKey = @"image";
NSString * const imageNotificationIsImageLoadedKey = @"isImageLoaded";
NSString * const cellReuseId = @"cellReuseId";

@interface ImageTableViewController () <UITableViewDelegate, UITableViewDataSource, ImageURLTableViewCellDelegate>

@property (weak, nonatomic) UITableView *imagesTableView;
@property (copy, nonatomic) NSArray *imageURLs;
@property (strong, nonatomic) NSCache *imageCache;
@property (strong, nonatomic) NSIndexPath *tappedRowIndexPath;
@property (strong, nonatomic) NSMutableSet *failedDownloads;

@end

@implementation ImageTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Image Gallery";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.failedDownloads = [NSMutableSet set];
    self.imageCache = [NSCache new];
    self.imageURLs = @[@"https://sun1-20.userapi.com/c836137/v836137037/4d4c3/59O1-wHWWZQ.jpg", @"https://pp.userapi.com/c543103/v543103522/30526/3C1ihzj8d40.jpg", @"http://lookw.ru/1/519/1402242533-009.jpg", @"https://pp.userapi.com/c543103/v543103522/3052f/axm4Rf9YVFc.jpg", @"https://pp.userapi.com/c543103/v543103522/30538/RCE3LjS-W6o.jpg", @"https://pp.userapi.com/c543103/v543103522/30f04/nfHoWCKAEmw.jpg", @"https://pp.userapi.com/c543103/v543103522/30efb/oU-z5R0uICo.jpg", @"http://lookw.ru/1/519/1402242484-064.jpg", @"https://pp.userapi.com/c543103/v543103522/30ef2/qAdoaLDAjgs.jpg", @"https://pp.userapi.com/c543101/v543101522/28e4a/ifD0qQucd0A.jpg", @"https://sun1-86.userapi.com/c543101/v543101522/28e30/zwL_FvlVHPE.jpg", @"https://pp.userapi.com/c836137/v836137037/4d4cd/B_EPRGbXXzg.jpg",@"https://pp.userapi.com/c543101/v543101522/28e53/W97gjCGkqL0.jpg",  @"http://lookw.ru/1/519/1402242453-065.jpg", @"https://sun9-1.userapi.com/c836137/v836137037/4d4d7/K9q1JZbIM0I.jpg", @"https://pp.userapi.com/c836137/v836137037/4d4e1/82qkXuvA4YQ.jpg", @"https://pp.userapi.com/c543100/v543100522/273b6/lAvtgEoKZL8.jpg", @"http://lookw.ru/1/519/1402242501-066.jpg", @"https://pp.userapi.com/c543100/v543100522/273be/zL1noyD7n_A.jpg", @"https://pp.userapi.com/c543100/v543100522/273c6/I0x7aodqbDY.jpg", @"https://pp.userapi.com/c543103/v543103522/2e1a9/ZpWpu5LmhTA.jpg", @"http://lookw.ru/1/519/1402242480-033.jpg", @"https://sun1-29.userapi.com/c543103/v543103522/2e1a1/7HWelc2m-ig.jpg", @"https://pp.userapi.com/c543103/v543103522/2e171/LGcMARWD_I4.jpg", @"http://lookw.ru/1/519/1402242520-013.jpg", @"https://pp.userapi.com/c543103/v543103522/2e191/dROgZeOhpQY.jpg", @"https://pp.userapi.com/c543103/v543103522/2e199/I_fIb15xB9w.jpg", @"https://sun1-29.userapi.com/c543103/v543103522/2e181/gq96dSgcSzQ.jpg", @"http://lookw.ru/1/519/1402242457-099.jpg", @"https://sun1.beltelecom-by-minsk.userapi.com/c543101/v543101522/2a01b/ygFyNZGhxAk.jpg", @"https://pp.userapi.com/c543108/v543108172/dd65/5Du7h4JVMUA.jpg", @"http://lookw.ru/1/519/1402242510-002.jpg", @"https://pp.userapi.com/c543108/v543108554/1502b/rjVqePYOI4Y.jpg", @"https://pp.userapi.com/c543101/v543101787/36813/ObltXsSC2oE.jpg", @"https://pp.userapi.com/c543101/v543101833/19bf1/S8tEAL7xRmg.jpg", @"https://pp.userapi.com/c543101/v543101787/3681c/AYaVZ7Xam4g.jpg", @"http://lookw.ru/1/519/1402242476-001.jpg",  @"https://pp.userapi.com/wO3RGr8Abl6XBoa72TpRG1CQFbT5h8F792Cfdw/g9N2NNp7Oo4.jpg", @"https://pp.userapi.com/c636825/v636825533/b15a/QNLNBLCVRx0.jpg", @"http://cs543101.vk.me/v543101702/c495/j3v-FCLx2-c.jpg", @"http://lookw.ru/1/519/1402242468-042.jpg", @"http://cs543101.vk.me/v543101702/c4af/oRxmqE6Z-G0.jpg", @"https://pp.userapi.com/c543100/v543100522/292a4/eWc4I4pg6oU.jpg", @"https://sun1.beltelecom-by-minsk.userapi.com/c543100/v543100522/29292/9ajVJbJOriM.jpg", @"https://pp.userapi.com/c543100/v543100522/29289/Lfopu2o59FQ.jpg", @"http://lookw.ru/1/519/1402242474-007.jpg", @"https://sun1.beltelecom-by-minsk.userapi.com/c543100/v543100522/2929b/Y7-yiL21odc.jpg", @"https://sun2.beltelecom-by-minsk.userapi.com/c543103/v543103522/21ff7/6SRmo_fHRV8.jpg", @"http://lookw.ru/1/519/1402242539-008.jpg", @"https://sun1.beltelecom-by-minsk.userapi.com/c543103/v543103522/21fee/I7086MVXdZ8.jpg", @"https://pp.userapi.com/c543103/v543103522/21fe5/fslXjzZU4GU.jpg", @"http://lookw.ru/1/519/1402242543-073.jpg", @"https://pp.userapi.com/c543103/v543103522/22000/Z-baKP-ZVL0.jpg", @"https://pp.userapi.com/c543103/v543103522/21fd3/KdyvF6rEYm4.jpg", @"https://pp.userapi.com/c543103/v543103522/21fdc/hkZVRrUkmBw.jpg", @"http://lookw.ru/1/519/1402242469-045.jpg", @"https://pp.userapi.com/c849428/v849428683/f7ec5/dH1y20Yf58U.jpg", @"https://pp.userapi.com/c845216/v845216622/173480/5D3y0WwC6Rs.jpg", @"http://lookw.ru/1/519/1402242490-006.jpg", @"http://lookw.ru/1/519/1402242556-014.jpg"];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.tappedRowIndexPath) {
        [self.imagesTableView scrollToRowAtIndexPath:self.tappedRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)viewDidLayoutSubviews {
    if (self.tappedRowIndexPath) {
        [self.imagesTableView scrollToRowAtIndexPath:self.tappedRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.tappedRowIndexPath = nil;
    }
}

#pragma mark - Private

- (void)setupTableView {
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    self.imagesTableView = tableView;
    self.imagesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
          [self.imagesTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
          [self.imagesTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
          [self.view.safeAreaLayoutGuide.trailingAnchor constraintEqualToAnchor:self.imagesTableView.trailingAnchor],
          [self.view.safeAreaLayoutGuide.bottomAnchor constraintEqualToAnchor:self.imagesTableView.bottomAnchor]
          ]];
    self.imagesTableView.delegate = self;
    self.imagesTableView.dataSource = self;
    [self.imagesTableView registerClass:[ImageURLTableViewCell class] forCellReuseIdentifier:cellReuseId];
    self.imagesTableView.estimatedRowHeight = 200;
    self.imagesTableView.tableFooterView = [UIView new];
    self.imagesTableView.allowsSelection = NO;
}

- (void)loadNewImageWithURL:(NSString *)stringURL forCell:(ImageURLTableViewCell *)cell {
    dispatch_queue_t utilityQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    dispatch_async(utilityQueue, ^{
        NSURL *url = [NSURL URLWithString:stringURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *loadedImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (loadedImage) {
                [self.imageCache setObject:loadedImage forKey:stringURL];
                [[NSNotificationCenter defaultCenter] postNotificationName:stringURL object:self userInfo:@{imageNotificationIsImageLoadedKey: @YES, imageNotificationImageKey: loadedImage}];
                if ([cell.imageURL isEqualToString:stringURL]) {
                    cell.centeredImageView.image = loadedImage;
                }
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:stringURL object:self userInfo:@{imageNotificationIsImageLoadedKey: @NO}];
                if ([cell.imageURL isEqualToString:stringURL]) {
                    [self.failedDownloads addObject:stringURL];
                    cell.centeredImageView.image = [UIImage imageNamed:@"reloadImage"];
                    cell.imageURLLabel.text = @"Error: connection timed out (at least I think so)";
                }
            }
        });
    });
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageURLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    cell.delegate = self;
    NSString *imageURL = self.imageURLs[indexPath.row];
    cell.imageURL = imageURL;
    [cell setNeedsUpdateConstraints];
    UIImage *image = [self.imageCache objectForKey:imageURL];
    if (image) {
        cell.centeredImageView.image = image;
    } else {
        if ([self.failedDownloads containsObject:imageURL]) {
            [self.failedDownloads removeObject:imageURL];
        }
        [self loadNewImageWithURL:imageURL forCell:cell];
    }
    return cell;
}

#pragma mark - ImageURLTableViewCellDelegate

- (void)didTapOnImageViewInCell:(ImageURLTableViewCell *)cell {
    NSIndexPath *indexPath = [self.imagesTableView indexPathForCell:cell];
    NSString *imageURL = self.imageURLs[indexPath.row];
    if ([self.failedDownloads containsObject:imageURL]) {
        [self.imagesTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    ImageViewController *imageVC = [ImageViewController new];
    imageVC.imageURL = imageURL;
    UIImage *image = [self.imageCache objectForKey:imageURL];
    if (image) {
        imageVC.image = image;
    }
    self.tappedRowIndexPath = indexPath;
    [self.navigationController pushViewController:imageVC animated:YES];
}

@end
