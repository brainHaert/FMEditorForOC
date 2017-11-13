//
//  XZViewController.m
//  XZMoveCollectIon
//
//  Created by admin on 16/3/17.
//  Copyright © 2016年 XieZi. All rights reserved.
//
#define CELLID @"cellid1"
#define TextCellID @"textCell"
#define HEADERID @"headerID"
#define XZCollectionInsetVertical 15.f
#define XZCollectionItemSpace 15.f
#define BottomViewHeight 52

#import "XZPostMainViewController.h"
#import "XZImageCell.h"
#import "XZTextViewCell.h"
#import "RACollectionViewReorderableTripletLayout.h"
#import "DPPhotoGroupViewController.h"
#import "XZPostPhotoListViewController.h"
#import "XZEditPhotoListViewController.h"

#import "XZTextCellFakeView.h"
#import "XZPostTipsView.h"

#import "NSString+Format.h"
#import "UIView+Extension.h"
#import "MEUtils.h"
#import "XZFashionDetailViewController.h"

@interface XZPostMainViewController ()<RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource,XZPostPhotoListViewControllerDelegate,XZEditPhotoListDelegate,XZGetOnePhotoDelegate,XZTextCellFakeViewDelegate,UITextViewDelegate>

@property ( nonatomic, strong)NSMutableArray *imageArray;/**< 数据源数组 */

@end

@implementation XZPostMainViewController
{
    UICollectionView *_collectionView;
    
    RACollectionViewReorderableTripletLayout *_layoutRA;
    
    NSInteger _seletedItem;                 /**< 选择的item*/
    
    //    UITextField *_titleField;/**< title输入框*--不能换行，要把他换成UITextView*/
    UITextView *_titleView;//title输入框
    
    XZTextCellFakeView *_cellTextFakeView;  /**< 假cell（输入框的）*/
    
    BOOL _isShowKeybroad;                   /**< 在cellforindexPath里判断是否要升起键盘的判断 */
    
    CGFloat _textCellmaxY;                  /**< 当前正在输入的textViewCell的最大Y值 */
    
    CGFloat _keyboardHeight;                /**< 键盘高度 */
    
    UIView *_bottomView;                    /**< 底栏 */
    
    UIButton *_addTextBtn;                  /**< 添加textCell按钮 */
    
    BOOL _isBeginEdit;                      /**< 是否开始编辑 */
    
    UILabel *_placeholderLabel;//UITextView的占位符号
    
    XZPostTipsView *_tipsView;              /**<提示的view*/
}
#pragma mark 一开始的加号
-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        [_imageArray addObject:[UIImage imageNamed:@"post01_icon_a.png"]];
    }
    
    return _imageArray;
}
#pragma mark 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postMainViewkeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postMainViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _isShowKeybroad = NO;
    [self initXZUI];
    
}
#pragma mark UI
- (void)initXZUI {
    [self initCollectionView];
    [self initNavigateBarButton];
    //    [self initTextFieldToView:nil];
    [self initTextViewToView:nil];
    [self initBottomView];
    
    _tipsView = [[XZPostTipsView alloc]initWithFrame:[XZPostTipsView getTipsViewFrame]];
    [_tipsView showViewOnMainWindow];
}
#pragma mark 初始化textfield
//- (void)initTextFieldToView:(UIView *)view {
//    if (!_titleField) {
//        _titleField = [[UITextField alloc]initWithFrame:CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, 60)];
//        _titleField.placeholder = @"请输入标题";
//        _titleField.textColor = [UIColor blackColor];
//        _titleField.font = [UIFont boldSystemFontOfSize:34];
//        [_titleField addTarget:self action:@selector(whenTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
//        [_collectionView addSubview:_titleField];
//    }
//}
-(void)initTextViewToView:(UIView *)view{
    if (!_titleView) {
        _titleView = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, [UIScreen mainScreen].bounds.size.width - 30, 80)];
        CGRect titleViewF=_titleView.bounds;
        titleViewF.origin.y -= 15;
        _placeholderLabel=[[UILabel alloc] initWithFrame:titleViewF];
        _placeholderLabel.text=@"请输入标题";
        _placeholderLabel.font=[UIFont boldSystemFontOfSize:31.6];
        _placeholderLabel.textColor=[UIColor grayColor];
        
        _titleView.delegate=self;
        _titleView.textColor = [UIColor blackColor];
        _titleView.font = [UIFont boldSystemFontOfSize:31.6];
        [_titleView addSubview:_placeholderLabel];
        [_collectionView addSubview:_titleView];
    }
    
    
}
#pragma mark 初始化collectionView
- (void)initCollectionView {
    
    _layoutRA = [[RACollectionViewReorderableTripletLayout alloc]init];
    _layoutRA.delegate = self;
    _layoutRA.datasource = self;
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:_layoutRA];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[XZImageCell class] forCellWithReuseIdentifier:CELLID];
    [_collectionView registerClass:[XZTextViewCell class] forCellWithReuseIdentifier:TextCellID];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERID];
    [self.view addSubview:_collectionView];
    
    _seletedItem = -1;
    _collectionView.tag = -1;
    _isBeginEdit = NO;
}
#pragma mark 初始化底view
- (void)initBottomView {
    
    CGFloat bottomHeight = BottomViewHeight;
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - bottomHeight - 44, [UIScreen mainScreen].bounds.size.width, bottomHeight)];
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    _bottomView.layer.shadowOpacity = .5f;
    _bottomView.layer.shadowRadius = 3.f;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    CGFloat littleWidth = bottomHeight;
    CGFloat littleHeight = littleWidth - 18;
    CGFloat littleMargin = bottomHeight;
    CGFloat littleY = (bottomHeight - littleHeight)/2;
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat imageX = ([UIScreen mainScreen].bounds.size.width - littleHeight*2 - littleMargin)/2;
    imageBtn.frame = CGRectMake(imageX, littleY, littleHeight, littleHeight);
    [imageBtn addTarget:self action:@selector(insertImageCell:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:imageBtn];
    
    _addTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat textX = CGRectGetMaxX(imageBtn.frame) + littleMargin;
    _addTextBtn.frame = CGRectMake(textX, littleY, littleHeight, littleHeight);
    [_addTextBtn addTarget:self action:@selector(insertTextCell:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_addTextBtn];
    
    [imageBtn setImage:[UIImage imageNamed:@"post01_icon_b.png"] forState:UIControlStateNormal];
    [_addTextBtn setImage:[UIImage imageNamed:@"post01_icon_c.png"] forState:UIControlStateNormal];
    _addTextBtn.hidden = YES;
}
#pragma mark NavigateBar
- (void)initNavigateBarButton {
    self.navigationItem.title = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickShow)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navbar_cancel_icon@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(clickShow)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"继续" style:UIBarButtonItemStyleDone target:self action:@selector(navigationRightClick)];
    self.navigationController.navigationBar.translucent = NO;
}
#pragma mark - collectionView数据源
#pragma mark 关于cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    DLog(@"----=======%@", self.imageArray);
    return self.imageArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isTextView = [[self.imageArray objectAtIndex:indexPath.item]isKindOfClass:[NSString class]];
    
    if (isTextView) {
        
        XZTextViewCell *cell = (XZTextViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TextCellID forIndexPath:indexPath];
        [cell setCellTextView:(NSString *)[self.imageArray objectAtIndex:indexPath.item] indexPath:indexPath];
        cell.tag = 999;
        
        if (_isShowKeybroad && indexPath.item == _seletedItem) {
            _isShowKeybroad = NO;
            
            //移除假textCell
            [self throwAwayTextViewFakeView];
            
            //            DLog(@"editText %zd",indexPath.item);
            NSString *cellStr = cell.textView.text;
            if (!_cellTextFakeView) {
                
                _cellTextFakeView = [[XZTextCellFakeView alloc]initWithFrame:cell.frame indexPath:indexPath];
                _cellTextFakeView.cellTextViewDelegate = self;
                _cellTextFakeView.text = cellStr;
                [collectionView addSubview:_cellTextFakeView];
//                DLog(@"gestureRecognizers = %@", _cellTextFakeView.gestureRecognizers)
                for (UIGestureRecognizer *gestureRecognizer in _cellTextFakeView.gestureRecognizers) {
                    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                        [_layoutRA.longPressGesture requireGestureRecognizerToFail:gestureRecognizer];
                    }
                }
                
                _layoutRA.panGesture.enabled = NO;
                _layoutRA.tapGesture.enabled = NO;
                _layoutRA.longPressGesture.enabled = NO;
                
            }
            
            if (!_cellTextFakeView.isFirstResponder) {
                [_cellTextFakeView becomeFirstResponder];
            }
        }
        return cell;
    } else {
        XZImageCell *cell = (XZImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
        [cell setCellImage:self.imageArray indexPath:indexPath];
        cell.tag = 888;
        return cell;
    }
    
}

#pragma mark - 第三方框架的代理
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView {
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    return XZCollectionItemSpace;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView {
    return 15.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(5.f, XZCollectionInsetVertical, BottomViewHeight + 15.f, XZCollectionInsetVertical);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section {
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(64.f, 0, BottomViewHeight, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview {
    return .3f;
}


#pragma mark - collectionView代理
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    NSLog(@"fromIndexPath = %zd toIndexPath =%zd",fromIndexPath.item,toIndexPath.item);
    //    NSLog(@"照片数组 == %@",self.imageArray);
    NSInteger fromItem = fromIndexPath.item;
    
    UIImage *image = [self.imageArray objectAtIndex:fromItem];
    [self.imageArray removeObjectAtIndex:fromItem];
    [self.imageArray insertObject:image atIndex:toIndexPath.item];
    
    CGSize cellSize = [[_layoutRA.allCellSizeArr objectAtIndex:fromItem] CGSizeValue];
    [_layoutRA.allCellSizeArr removeObjectAtIndex:fromItem];
    [_layoutRA.allCellSizeArr insertObject:[NSValue valueWithCGSize:cellSize] atIndex:toIndexPath.item];
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark 是否允许cell移动到这个indexPath
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}
#pragma mark 是否允许cell移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //    return !_isBeginEdit;
    return YES;
}
#pragma mark 全部是否允许移动
- (BOOL)canMoveCollectionView:(UICollectionView *)collectionView {
    return !_isBeginEdit;
    //    return YES;
}
#pragma mark 将要开始拖动
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    [self throwAwayTextViewFakeView];
}
#pragma mark - XZPostPhotoGroupViewControllerDelegate(全新选择图片回来)
- (void)didSelectPhotos:(NSMutableArray *)photos{
    _addTextBtn.hidden = NO;
    self.imageArray = [NSMutableArray arrayWithArray:photos];
    _layoutRA.allCellSizeArr = [NSMutableArray array];
    _layoutRA.allCellFrameArr = [NSMutableArray array];
    _seletedItem = 0;
    _collectionView.tag = 1;
    [_collectionView reloadData];
}
#pragma mark - XZOneDelegate赋值给单独的cell(选择一张图片回来)
- (void)didSelectOnePhotos:(UIImage *)image item:(NSInteger)item {
    NSLog(@"image = %@\nitem =%zd",image,item);
    [self.imageArray replaceObjectAtIndex:item withObject:image];
    [_collectionView reloadData];
}
#pragma mark - XZEditPhotoGroupViewControllerDelegate(再次去选择图片回来)
- (void)addEditSelectPhotos:(NSMutableArray *)photos {
    [self.imageArray addObjectsFromArray:photos];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 30.f;
    CGFloat CellHeightPart = 2;
    CGSize imageSize = CGSizeMake(width, width/CellHeightPart);
    for (int iii = 0; iii < photos.count; iii ++) {
        [_layoutRA.allCellSizeArr addObject:[NSValue valueWithCGSize:imageSize]];
    }
    
    [_collectionView reloadData];
}
#pragma mark - 插入图片、文字cell
- (void)insertImageCell:(UIButton *)button {
    NSLog(@"插入图片");
    if (_seletedItem == -1) {
        [self openNewPhotoListView];
        return;
    }
    XZEditPhotoListViewController *photoListVC = [XZEditPhotoListViewController new];
    NSInteger imageCount = 0;
    for (int iii = 0; iii < self.imageArray.count; iii ++) {
        if ([[self.imageArray objectAtIndex:iii]isKindOfClass:[UIImage class]]) {
            imageCount ++;
        }
    }
    photoListVC.seletedCount = imageCount;
    photoListVC.maxSelectionCount = 20;
    photoListVC.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:photoListVC] animated:YES completion:nil];
}
- (void)insertTextCell:(UIButton *)button {
    //    if (_collectionView.tag == -1) {
    //        [SVProgressHUD showInfoWithStatus:@"请先选择图片" maskType:SVProgressHUDMaskTypeClear];
    //        return;
    //    }
    
    NSInteger wantInsertItem = _seletedItem + 1;//插在选中的cell的下面
    NSLog(@"插入文字之前self.imageArray = %@",self.imageArray);
    
    NSString *stringTamp = @"";
    if (self.imageArray.count <= wantInsertItem) {//如果是最后一个，就不插入，用添加
        wantInsertItem = self.imageArray.count;
        [self.imageArray addObject:stringTamp];
    } else {
        [self.imageArray insertObject:stringTamp atIndex:wantInsertItem];
    }
    NSLog(@"插入文字之后self.imageArray = %@",self.imageArray);
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - XZCollectionInsetVertical*2;
    CGSize cellSize = CGSizeMake(cellWidth, 44);
    
    if (_layoutRA.allCellSizeArr.count <= wantInsertItem) {//如果是最后一个，就不插入，用添加
        
        [_layoutRA.allCellSizeArr addObject:[NSValue valueWithCGSize:cellSize]];//添加
    } else {
        
        [_layoutRA.allCellSizeArr insertObject:[NSValue valueWithCGSize:cellSize] atIndex:wantInsertItem];//插入
    }
    
    [_collectionView reloadData];
    
    //让刚插入的那个东西becomeFirstResponder
    _seletedItem = wantInsertItem;
    _isShowKeybroad = YES;
}
#pragma mark - layout代理事件
#pragma mark cell点击事件，系统的点击事件被我拦截了（我不是故意的）
- (void)customCollectionView:(UICollectionView *)collectionView didSeleted:(NSIndexPath *)indexPath {
    if (collectionView.tag == -1) {
        [self openNewPhotoListView];
        return;
    }
    _seletedItem = indexPath.item;
//    DLog(@"_seletedItem == %zd", _seletedItem);
    [self throwAwayTextViewFakeView];
//    DLog(@"editText %zd",indexPath.item);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XZTextViewCell class]]) {//cell上的mune是在手势layout里创建
        NSString *cellStr = [self.imageArray objectAtIndex:indexPath.item];
        if (!_cellTextFakeView) {
            _cellTextFakeView = [[XZTextCellFakeView alloc]initWithFrame:cell.frame indexPath:indexPath];
            _cellTextFakeView.cellTextViewDelegate = self;
            _cellTextFakeView.text = cellStr;
            [collectionView addSubview:_cellTextFakeView];
        }
    } else {//此时在手势layout创建了一个image类型的fakecellview(细胞假象视图)
        [self.view endEditing:YES];
    }
    
}
#pragma mark 改变输入框对齐方式（暂时不实现）
- (void)customCollectionView:(UICollectionView *)collectionView changeAlignment:(NSIndexPath *)indexPath {
    NSLog(@"changeAlignment");
}
#pragma mark 换图
- (void)customCollectionView:(UICollectionView *)collectionView changeImage:(NSIndexPath *)indexPath {
    NSLog(@"changeImage");
    XZPostPhotoListViewController *photoListVC = [[XZPostPhotoListViewController alloc]initWithSeleteType:XZOneSelete];;
    photoListVC.maxSelectionCount = 1;
    photoListVC.oneDelegate = self;
    photoListVC.view.tag = indexPath.item;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:photoListVC] animated:YES completion:nil];
}
#pragma mark 删除cell
- (void)customCollectionView:(UICollectionView *)collectionView deleteCell:(NSIndexPath *)indexPath {
    NSLog(@"deleteCell");
    //删除cell用的
    if (self.imageArray.count == 1) {
        return;
    }
    
    [self throwAwayTextViewFakeView];
    
    NSInteger item = indexPath.item;
    [_collectionView performBatchUpdates:^{
        
        [self.imageArray removeObjectAtIndex:item];
        
        [_layoutRA.allCellSizeArr removeObjectAtIndex:item];
        
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
#pragma mark 输入
- (void)customCollectionView:(UICollectionView *)collectionView editText:(NSIndexPath *)indexPath {
    _layoutRA.panGesture.enabled = NO;
    _layoutRA.tapGesture.enabled = NO;
    _layoutRA.longPressGesture.enabled = NO;
    [_cellTextFakeView becomeFirstResponder];
}
#pragma mark - 供调用
#pragma mark 打开新相册
- (void)openNewPhotoListView {
    XZPostPhotoListViewController *photoListVC = [[XZPostPhotoListViewController alloc]initWithSeleteType:XZAllSelete];;
    photoListVC.maxSelectionCount = 20;
    photoListVC.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photoListVC];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}
#pragma mark 去除textViewFakeView
- (void)throwAwayTextViewFakeView {
    if (_cellTextFakeView) {
        [_cellTextFakeView removeFromSuperview];
        _cellTextFakeView = nil;
    }
    _layoutRA.panGesture.enabled = YES;
    _layoutRA.tapGesture.enabled = YES;
    _layoutRA.longPressGesture.enabled = YES;
}
#pragma mark - textFakeViewCell代理
#pragma mark 结束编辑(编辑完的时候把得到的文字存数组)
- (void)cellTextFakeViewEndEdit:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    
    if (![[self.imageArray objectAtIndex:indexPath.item]isEqualToString:textView.text]) {
        
        [self.imageArray replaceObjectAtIndex:indexPath.item withObject:textView.text];
    }
    
    [self throwAwayTextViewFakeView];
    //    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    _isShowKeybroad = NO;
    
    [_collectionView reloadData];
}
#pragma mark 开始编辑(改变导航栏右键、上升屏幕)
- (void)cellTextFakeViewBeginEdit:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    
//    _textCellmaxY = FMGetMaxY(cell);
    _textCellmaxY = CGRectGetMaxY(cell.frame);
//    DLog(@"开始编辑 = %f", _textCellmaxY);
}
#pragma mark 正在编辑（改变textViewCell的高度）
- (void)cellTextFakeViewIsEditing:(UITextView *)textView indexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = [[_layoutRA.allCellSizeArr objectAtIndex:indexPath.item] CGSizeValue];
 
    NSLog(@"%@",NSStringFromCGSize(cellSize));
  
    CGFloat textWidth = cellSize.width - 10.f;
    CGFloat textHeight = [NSString heightFromString:textView.text withLabelWidth:textWidth andLabelFont:[UIFont systemFontOfSize:16]];
    textHeight += 15.f;
     NSLog(@"cellSizeH1:%lf--textWidth1:%lf--textHeight1:%lf",cellSize.height,textWidth,textHeight);
    NSLog(@"cellTextFake1===%@",NSStringFromCGSize(_cellTextFakeView.size));
    //编辑文字，删除或增加换行，虚拟文本框的大小调整
    if (textHeight > cellSize.height) {
//        DLog(@"增加高度");
        //        textView.h = textHeight;
        _cellTextFakeView.h = textHeight;
        cellSize.height = textHeight;
        [_layoutRA.allCellSizeArr replaceObjectAtIndex:_seletedItem withObject:[NSValue valueWithCGSize:cellSize]];
        [_layoutRA invalidateLayout];
    }else if (textHeight < cellSize.height && textHeight > 49 ){
   
        _cellTextFakeView.h = textHeight-15;
        cellSize.height = textHeight-15;
        if (cellSize.height <44) {
            cellSize.height = 44;
            _cellTextFakeView.h = 53;
        }
        
        [_layoutRA.allCellSizeArr replaceObjectAtIndex:_seletedItem withObject:[NSValue valueWithCGSize:cellSize]];
        [_layoutRA invalidateLayout];
    }
    NSLog(@"cellTextFake===%@",NSStringFromCGSize(_cellTextFakeView.size));
    NSLog(@"cellSizeH:%lf--textWidth:%lf--textHeight:%lf",cellSize.height,textWidth,textHeight);
    
}
#pragma mark - 键盘通知事件
- (void)postMainViewkeyboardWillShow:(NSNotification *)notification {
    _isBeginEdit = YES;
    NSString *title = @"";
    if (_cellTextFakeView.isFirstResponder) {
        _bottomView.hidden = YES;
        title = @"编辑正文";
    } else {
        title = @"编辑标题";
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(whenKeyboardShowNavigationLeftRightClick)];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(whenKeyboardShowNavigationLeftRightClick)];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = title;
}
- (void)postMainViewKeyboardWillHide:(NSNotification *)notification {
    _isBeginEdit = NO;
    _bottomView.hidden = NO;
    [self initNavigateBarButton];
}
#pragma mark - 点击事件
#pragma mark 导航栏左键点击
- (void)clickShow{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要放弃发布吗？" message:@"放弃并回到上一页？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续进行发布",@"回到上一页", nil];
    [alertView show];
}
#pragma mark 导航栏右键点击(继续按钮)
- (void)navigationRightClick {
    [self.view endEditing:YES];
    
    if (!_titleView.text.length) {
        [_tipsView showTipsView:@"别忘了填写一个美丽的标题~"];
        return;
    }
    
    if (_collectionView.tag == -1) {
        [_tipsView showTipsView:@"别忘了选择一张美丽的图片~"];
        return;
    }
    
    /*
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([self.arrayDataDelegate respondsToSelector:@selector(returnBackSizeArray:imageArray:title:)]) {
            [self.arrayDataDelegate returnBackSizeArray:[_layoutRA.allCellSizeArr copy] imageArray:[self.imageArray copy] title:_titleView.text];
        }
    }];
    */
    XZFashionDetailViewController *fashionViewController = [[XZFashionDetailViewController alloc] init];
    fashionViewController.imageArray = self.imageArray;
    fashionViewController.titleString = _titleView.text;
    fashionViewController.allCellArray = self.imageArray;
    fashionViewController.allCellSizeArr = _layoutRA.allCellSizeArr;
    
    [self.navigationController pushViewController:fashionViewController animated:YES];
}
#pragma mark 弹出键盘之后导航栏左右键点击
- (void)whenKeyboardShowNavigationLeftRightClick {
    [self.view endEditing:YES];
}

#pragma mark alertView事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0){
        return;
    } else {
        // 返回
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark textChange事件
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (_titleView == textView) {
        if (range.location >= 22) {
            [_tipsView showTipsView:@"输入的字数不能超过22个哟~~"];
            return NO;
        }
    }
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    //    _layoutRA.longPressGesture.enabled=YES;
    //    _layoutRA.tapGesture.enabled=YES;
    //    _layoutRA.panGesture.enabled=YES;
    [_layoutRA removeAndNilCellFakeView];
    //    [self throwAwayTextViewFakeView];
    
    NSString *toBeString = textView.text;
    NSInteger length = 35;//限制的字数
    
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString *lang=[[[UIApplication sharedApplication]textInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];//获取当前已经输入的字数
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];//获取高亮部分
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > length) textView.text = [toBeString substringToIndex:length];
        } else {}// 有高亮选择的字符串，则暂不对文字进行统计和限制
    } else {// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > length) textView.text = [toBeString substringToIndex:length];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    
    if ( textView.text.length <= 0) {
        _placeholderLabel.hidden=NO;
    }else{
        _placeholderLabel.hidden=YES;
    }
}

#pragma mark - 销毁
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
