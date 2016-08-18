//
//  SCImageEditViewController.h
//  GreenViewVilla
//
//  Created by 唐绍成 on 16/8/16.
//  Copyright © 2016年 Tousan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTextView.h"
#import <Masonry.h>
#import "DoodleViewController.h"
#import "RepairTextViewCell.h"
@class SCImageEditViewController;
@protocol SCImageEditViewControllerDelegate <NSObject>

- (void)SCImageEditViewController:(SCImageEditViewController*)viewController DidEndEdit:(UIImage*)image Remark:(NSString*)remark;

@end

@interface SCImageEditViewController : UIViewController <DoodleViewControllerDelegate,SCTextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIImage *image;
@property (strong, nonatomic)UIImageView *imageView;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,assign)id<SCImageEditViewControllerDelegate>delegate;

@end
