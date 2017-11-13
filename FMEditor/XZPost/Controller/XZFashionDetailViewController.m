//
//  XZFashionDetailViewController.m
//  FMB
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 ICompany. All rights reserved.
//
#define ImageID @"imageID"
#define TextID @"textID"
#define DetailHeaderID @"headerID"
#define DetailFooterID @"footerID"
#define MarginSide 15.f
#define MoreHeaderHeight 34.f

#import "XZFashionDetailViewController.h"
#import "XZFashionLayout.h"
#import "XZImageCell.h"
#import "XZTextViewCell.h"
#import "XZDetailHeaderView.h"
#import "XZDetailFooterView.h"
#import "SDPhotoBrowser.h"
//#import "FMFashionCategoryController.h"
//#import "XZTipsImageView.h"
//#import "FMShareView.h"
//#import "KxMenu.h"
//#import "FMFashionHomeViewController.h"
//#import "FMLoginViewController.h"

//#import "FMFashionCommentViewController.h"

//#import "FMEditMainViewController.h"

//#import "TabBarButton.h"

#pragma mark -

@interface XZFashionDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,XZFashionLayoutDelegate,SDPhotoBrowserDelegate,XZDetailFooterViewDelegate,XZDetailHeaderViewDelegate>

@property (nonatomic, copy) NSMutableArray  *imageIndexArray; /**< 图片索引 */

@end

@implementation XZFashionDetailViewController
{
    XZFashionLayout  *_layout;
    UICollectionView *_collectionView;
    NSInteger         _tid;             /**< 传进来的帖子id */
    NSString         *_userid;          /**< 传进来的用户id */
    
    UILabel          *_titleLabel;      /**< 标题 */
    
    
    
    UIButton         *_praiseBtn;       /**< 赞按钮 */
    UIButton         *_collectBtn;      /**< 收藏按钮 */
    UIButton         *_commentBtn;      /**< 评论按钮 */
    UILabel          *_commentLabel;    /**< 评论数 */
    NSArray          *_tag_lists;        /**< 标签 */
}

- (instancetype)initWithID:(NSInteger)tid
{
    self = [super init];
    if (self) {
        _tid = tid;
    }
    return self;
}

- (instancetype)initWithTID:(NSInteger)tid userID:(NSString *)uid
{
    self = [super init];
    if (self) {
        _tid = tid;
        _userid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"详情";
    
    //initUI
    
    [self initDetailCollectionView];
    [self initBottomView];
    [self initNavgation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //网络请求
    [self loadNetWorkDataIsShowHUD:YES];
    [self initDataToSubview];
}
#pragma mark - ---------------------------------------------------------------------初始化UI
#pragma mark 初始化导航栏
- (void)initNavgation {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50.f, 20.f)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.8f;
    [btn addTarget:self action:@selector(navigationBarRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightButton1;
    
}
#pragma mark 初始化bottomView 
- (void)initBottomView {
    
    CGFloat bottomHeight = 54.f;
    UIView *bottomView = [UIView viewWithFrame:CGRectMake(0, self.view.h - bottomHeight, SCREEN_WIDTH, bottomHeight) color:[UIColor whiteColor] contentView:self.view];
    [bottomView makeShadowWithColor:[UIColor grayColor] offSet:CGSizeMake(0, -1.f) opacity:0.5f];
    
    CGFloat buttonH = 30.f;
    _praiseBtn = [UIButton buttonImageName:@"details_icon_1@2x.png" selectImageName:@"details_icon_1_s@2x.png" frame:CGRectMake(MarginSide, (bottomHeight - buttonH)/2, buttonH, buttonH) target:self action:@selector(praiseButtonClick:) to:bottomView];
    
    _collectBtn = [UIButton buttonImageName:@"details_icon_2@2x.png" selectImageName:@"details_icon_2_s@2x.png" frame:CGRectMake(MarginSide*2 + buttonH, (bottomHeight - buttonH)/2, buttonH, buttonH) target:self action:@selector(collectButtonClick:) to:bottomView];
    
    [UIButton buttonImageName:@"details_icon_3@2x.png" selectImageName:@"details_icon_3_s@2x.png" frame:CGRectMake(MarginSide*3 + buttonH*2, (bottomHeight - buttonH)/2, buttonH, buttonH) target:self action:@selector(shareButtonClick:) to:bottomView];
    
    _commentBtn = [UIButton buttonImageName:@"details_icon_4@2x.png" selectImageName:@"details_icon_4_s@2x.png" frame:CGRectMake(bottomView.w - buttonH - MarginSide, (bottomHeight - buttonH)/2, buttonH, buttonH) target:self action:@selector(commentButtonClick) to:bottomView];
    
    CGFloat littleW = 12.f;
    _commentLabel = [UILabel labelFrame:CGRectMake(FMGetMaxX(_commentBtn) - littleW, _commentBtn.y, littleW, littleW) align:NSTextAlignmentCenter systemFont:8.f textColor:[UIColor whiteColor] text:@"0" to:bottomView];
    _commentLabel.backgroundColor = [UIColor redColor];
    _commentLabel.layer.cornerRadius = littleW/2;
    _commentLabel.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentButtonClick)];
    _commentLabel.userInteractionEnabled = YES;
    [_commentLabel addGestureRecognizer:tap];
}


- (void)deleteButtonClick {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否删除?" message:@"删除后将无法恢复" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


#pragma mark 初始化collectionView
- (void)initDetailCollectionView {
    
    _layout = [[XZFashionLayout alloc]init];
    _layout.minimumLineSpacing = 15.f;
    _layout.minimumInteritemSpacing = 0.f;
    _layout.sectionInset = UIEdgeInsetsMake(15.f, MarginSide, 30.f, MarginSide);
    _layout.fashionLayoutDelegate = self;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[XZImageCell class] forCellWithReuseIdentifier:ImageID];
    [_collectionView registerClass:[XZTextViewCell class] forCellWithReuseIdentifier:TextID];
    [_collectionView registerClass:[XZDetailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DetailHeaderID];
    [_collectionView registerClass:[XZDetailFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DetailFooterID];
    
    [self.view addSubview:_collectionView];
}
#pragma mark 关于cell
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allCellArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id tempData = [_allCellArray objectAtIndex:indexPath.item];
    
    if ([tempData isKindOfClass:[NSString class]]) {
//        NSLog(@"tampDict = %@", tampDict);
        XZTextViewCell *cell = (XZTextViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TextID forIndexPath:indexPath];
        [cell setCellTextView:tempData indexPath:indexPath];
        return cell;
    }
    
    XZImageCell *cell = (XZImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ImageID forIndexPath:indexPath];
    [cell setCellImage:_allCellArray indexPath:indexPath];
    return cell;
}

#pragma mark 关于头/脚
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        XZDetailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DetailHeaderID forIndexPath:indexPath];
        [headerView getDetailReuseableViewData:@{@"title": self.titleString, @"nick_name": @"作者名字"}];
        headerView.delegate = self;
        return headerView;
        
    }
    
    
    XZDetailFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DetailFooterID forIndexPath:indexPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@1 forKey:@"is_collect"];
    [dict setObject:@1 forKey:@"is_praise"];
    [dict setObject:@18.8f forKey:@"praise_amount"];
    [dict setObject:@99 forKey:@"collect_num"];
    [footerView setDetailFooterData:[dict copy]];
    footerView.userID = _userid;
    footerView.delegate = self;
    return footerView;
    
}
- (CGFloat)footerHeightForCollectionView:(UICollectionView *)collectionView {
    
    return 100.f;
}
#pragma mark - ------------------------------------------------------------------------网络请求
#pragma mark 详情页加载数据请求
- (void)loadNetWorkDataIsShowHUD:(BOOL)isShow {
    
    _layout.allCellSizeArr = self.allCellSizeArr;
    
}
#pragma mark 赋值小控件
- (void)initDataToSubview {
    _praiseBtn.selected = YES;
    _collectBtn.selected = YES;
    
    NSInteger commentCount = 181;
    if (commentCount) {
        _commentLabel.hidden = NO;
        _commentLabel.text = [NSString stringWithFormat:@"%zd",commentCount];
    } else {
        _commentLabel.hidden = YES;
        _commentLabel.text = @"0";
    }
    
    _titleLabel.text = self.titleString;
    
}
#pragma mark 赞、添加收藏、取消收藏共同用到的网络请求
- (void)postActionToHttp:(NSString *)URLstr {
    
}

#pragma mark - ------------------------------------------------------------------------点击事件
#pragma mark 赞
- (void)praiseButtonClick:(UIButton *)button {
//    if ([_userid isEqualToString:[GETUID stringValue]]) {
//        return;
//    }
    if (button.selected) {
        return;
    }
    if (!GETTOKEN) {
        [self haveNotLogin];
        return;
    }
    button.selected = YES;
    [self postActionToHttp:praise_bill];
}
#pragma mark 收藏
- (void)collectButtonClick:(UIButton *)button {
    if (!GETTOKEN) {
        [self haveNotLogin];
        return;
    }
    if (button.selected) {
        button.selected = NO;
        [self postActionToHttp:delete_bill_collect];
        return;
    }
    
    button.selected = YES;
    [self postActionToHttp:add_bill_collect];
}

#pragma mark 分享
- (void)shareButtonClick:(UIButton *)button {
    NSLog(@"分享%@",GETUID);
}
#pragma mark 评论
- (void)commentButtonClick {
    NSLog(@"评论");
}

#pragma mark cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![_imageIndexArray containsObject:@(indexPath.item)]) {
        return;
    }
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = [_imageIndexArray indexOfObject:@(indexPath.item)];
    photoBrowser.currentImageArray = _imageIndexArray;
    photoBrowser.imageCount = _imageIndexArray.count;
    photoBrowser.sourceImagesContainerView = _collectionView;
    photoBrowser.userName = @"作者";
    [photoBrowser show];
}

#pragma mark - ------------------------------------------------------------------------代理事件
#pragma mark layout代理
- (CGFloat)moreHeightForCollectionView:(UICollectionView *)collectionView {
    
    NSString *title = self.titleString;
    
    CGFloat height = [NSString heightFromString:title withLabelWidth:SCREEN_WIDTH - MarginSide*2 andLabelFont:[UIFont boldSystemFontOfSize:28.f]];
    
    CGFloat addHeight = 0.f;
    if (height > HEADERHEIGHT) {
        addHeight = height - HEADERHEIGHT + HEADERHEIGHT/2;
    }
    
    return MoreHeaderHeight + HEADERHEIGHT + addHeight;
}
#pragma mark 脚部视图代理
#pragma mark 赞按钮点击
- (void)detailFooterViewPraiseImageClick {
    [self postActionToHttp:praise_bill];
}
#pragma mark 添加收藏
- (void)detailFooterViewAddCollect {
    [self postActionToHttp:add_bill_collect];
}
#pragma mark 取消收藏
- (void)detailFooterViewDeleteCollect {
    [self postActionToHttp:delete_bill_collect];
}
#pragma mark 脚部的按钮发现没有登录
- (void)detailFooterViewTipsNotLogin {
    [self haveNotLogin];
}
#pragma mark  SDPhotoBrowserDelegate(浏览图片框架)
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    NSNumber *arrayIndexNum = [self.imageIndexArray objectAtIndex:index];
    NSInteger arrayIndex = [arrayIndexNum integerValue];
    
    return [self.imageArray objectAtIndex:arrayIndex];// 返回临时占位图片（即原来的小图）
}
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
//    NSString *urlStr = [[_imageArray objectAtIndex:index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//    return [NSURL URLWithString:urlStr];// 返回高质量图片的url
//}
#pragma mark 头部代理
- (void)detailHeaderImageViewClick:(NSString *)userID {
    NSLog(@"");
}
#pragma mark - 共调用
- (void)haveNotLogin {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"跳转到注册/登录界面？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"留在本界面" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"注册/登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 调到登录
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Action 
- (void)navigationBarRightBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Getter
- (NSMutableArray *)imageIndexArray {
    if (!_imageIndexArray) {
        _imageIndexArray = [NSMutableArray array];
    }
    return _imageIndexArray;
}
#pragma mark - Setter
- (void)setImageArray:(NSMutableArray *)imageArray {
    
    _imageArray = imageArray;
    
    for (NSInteger iii = 0; iii < imageArray.count; iii ++) {
        
        id object = [imageArray objectAtIndex:iii];
        
        if ([object isKindOfClass:[UIImage class]]) {
            
            [self.imageIndexArray addObject:@(iii)];
        }
    }
}

@end
