//
//  DPPhotoGroupViewController.m
//  DPPictureSelector
//
//  Created by boombox on 15/9/1.
//  Copyright (c) 2015年 lidaipeng. All rights reserved.
//

#import "DPPhotoGroupViewController.h"
#import "XZPostPhotoListViewController.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation DPPhotoGroupCell

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame         = self.imageView.frame;
    frame.size.width     = self.frame.size.height - 5;
    frame.size.height    = frame.size.width;
    frame.origin.y       = (self.frame.size.height - frame.size.height) / 2;
    self.imageView.frame = frame;
}

@end

@interface DPPhotoGroupViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray    *groupList;
@property (strong, nonatomic) UITableView       *tableView;

@end

@implementation DPPhotoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
    self.navigationItem.title = @"相薄";
    
    [self.view addSubview:self.tableView];
    [self getAllGroup];
    
}

#pragma mark 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - ---------------------- getter
- (NSMutableArray *)groupList{
    if (!_groupList) {
        _groupList = [NSMutableArray new];
    }
    return _groupList;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

//获取所有相薄
- (void)getAllGroup{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });

    //枚举回调
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group){
            //设置过滤类型
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            [self.groupList addObject:group];
        }else{
            //group为nil时代表枚举完成，刷新tableView
            [self.tableView reloadData];
        }
    };
    
    //枚举失败回调
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
//        ALERT_MSG(@"没有权限访问相册");
    };

    //设置枚举相薄类型
    NSUInteger type = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream | ALAssetsGroupSavedPhotos;
    
    [library enumerateGroupsWithTypes:type
                           usingBlock:resultsBlock
                         failureBlock:failureBlock];
    
//    NSLog(@"self.groupList = %@",self.groupList);
}

//获取某个相薄最后一张图片
- (void)getLastImageByGroup:(ALAssetsGroup *)group usingBlock:(void (^)(UIImage *image))block{
    //枚举回调
    void (^selectionBlock)(ALAsset*, NSUInteger, BOOL*) = ^(ALAsset* asset, NSUInteger index, BOOL* innerStop) {
        if (asset == nil) {
            return;
        }
        if (block) {
            block([UIImage imageWithCGImage:[asset thumbnail]]);
        }
    };
    
    //设置过滤类型
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    if ([group numberOfAssets] > 0) {
        NSUInteger index              = [group numberOfAssets] - 1;
        NSIndexSet* lastPhotoIndexSet = [NSIndexSet indexSetWithIndex:index];
        //枚举最后一个Asset
        [group enumerateAssetsAtIndexes:lastPhotoIndexSet options:0 usingBlock:selectionBlock];
    }
}

#pragma mark - ---------------------- TableViewDelegate/TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    DPPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DPPhotoGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    ALAssetsGroup *group = _groupList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"group_default"];
    //获取相薄最后一张图片
    [self getLastImageByGroup:group usingBlock:^(UIImage *image) {
        cell.imageView.image = image;
    }];
    //显示相薄名称+图片张数
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%li张)",[group valueForProperty:ALAssetsGroupPropertyName],[group numberOfAssets]];
    
    NSLog(@"groupList = %@",self.groupList);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_groupList[indexPath.row] numberOfAssets] <= 0) {
//        ALERT_MSG(@"此相薄没有照片");
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPhotos:)]) {
        [self.delegate didSelectPhotos:_groupList[indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groupList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.layoutMargins = cell.layoutMargins;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.separatorInset = cell.separatorInset;
    }
}

#pragma mark - ---------------------- action
- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
