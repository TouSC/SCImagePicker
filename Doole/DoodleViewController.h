//
//  DoodleViewController.h
//  GreenViewVilla
//
//  Created by jocc6 on 16/3/16.
//  Copyright © 2016年 Tousan. All rights reserved.
//

#import "TouchDrawView.h"
#import <UIKit/UIKit.h>
#import <Masonry.h>
@class DoodleViewController;
@protocol DoodleViewControllerDelegate <NSObject>

- (void)DoodleViewController:(DoodleViewController*)viewController DidFinishDrewWithImage:(UIImage*)image Remark:(NSString*)remark;

@end

@interface DoodleViewController : UIViewController

@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,assign)BOOL isFromProblemDetailVC; //是否模态自添加事项界面
@property (nonatomic,weak)id<DoodleViewControllerDelegate>delegate;

@end