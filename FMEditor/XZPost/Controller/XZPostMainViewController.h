//
//  XZViewController.h
//  XZMoveCollectIon
//
//  Created by admin on 16/3/17.
//  Copyright © 2016年 XieZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZPostMainViewControllerDelegate  <NSObject>

- (void)returnBackSizeArray:(NSArray *)sizeAray imageArray:(NSArray *)imageArray title:(NSString *)title;

@end

@interface XZPostMainViewController : UIViewController

@property (nonatomic, weak) id <XZPostMainViewControllerDelegate> arrayDataDelegate;

@end
