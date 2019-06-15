//
//  ImageTableViewController.m
//  ImagesTable
//
//  Created by Liubou Sakalouskaya on 6/15/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "ImageTableViewController.h"
#import "ImageURLTableViewCell.h"

NSString * const cellReuseId = @"cellReuseId";

@interface ImageTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *imagesTableView;

@end

@implementation ImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}

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
    self.imagesTableView.estimatedRowHeight = 70;
    self.imagesTableView.rowHeight = UITableViewAutomaticDimension;
    self.imagesTableView.tableFooterView = [UIView new];
    self.imagesTableView.allowsSelection = NO;
}

#pragma mark - UITableViewDelegate



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageURLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    cell.imageURLLabel.text = @"Под цифрой 2 находится: UILabel. UILabel должен быть настроен как многострочный, контент должен быть полностью отображен в UILabel. В случае если контент большой то ячейка должна увеличить свои размеры чтобы весь текст был отображен в UILabel. Контентом для UILabel будет являтся URL";
    return cell;
}

@end
