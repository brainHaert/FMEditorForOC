//
//  XZFashionDetailViewController.h
//  FMB
//
//  Created by admin on 16/3/29.
//  Copyright © 2016年 ICompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZFashionDetailViewController : UIViewController

@property (nonatomic, copy) NSMutableArray  *allCellArray;    /**< 包含图、文的网络数组 */

@property (nonatomic, copy) NSMutableArray  *imageArray;      /**< 图片数组 */



@property (nonatomic, copy) NSMutableArray  *allCellSizeArr;

@property (nonatomic, copy) NSString *titleString;

- (instancetype)initWithID:(NSInteger)tid;

- (instancetype)initWithTID:(NSInteger)tid userID:(NSString *)uid;

@end
