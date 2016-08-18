//
//  SCImagePicker.h
//  CardAppSample
//
//  Created by 唐绍成 on 16/3/14.
//  Copyright © 2016年 唐绍成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QBImagePickerController.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <DACircularProgressView.h>
#import "SCAlbumController.h"
#import "TOCropViewController.h"
#import "SCImageEditViewController.h"
#import <MBProgressHUD.h>
typedef enum{
    SCImagePickerDeleteStyleInner = 0,
    SCImagePickerDeleteStyleButton,
}SCImagePickerDeleteStyle;

@class SCImagePicker;

@protocol SCImagePickerDelegate <NSObject>

- (void)SCImagePicker:(SCImagePicker*)picker DidUpdateFrame:(CGRect)frame;

@end

@interface SCImagePicker : UIView <QBImagePickerControllerDelegate,TOCropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,SCImageEditViewControllerDelegate>

@property(nonatomic,assign)NSUInteger maxCount;

@property(nonatomic,assign)BOOL editable;
@property(nonatomic,assign)CGFloat scale;
@property(nonatomic,assign)SCImagePickerDeleteStyle deleteStyle;

@property(nonatomic,strong)NSMutableArray *imageURL_Arr;
@property(nonatomic,strong)NSMutableArray *remark_Arr;

@property(nonatomic,assign)id<SCImagePickerDelegate>delegate;

@property(nonatomic,assign)CGFloat image_width;
@property(nonatomic,assign)CGFloat image_height;

@property(nonatomic,strong)NSString *default_remark;

- (void)upload:(NSString* (^)(NSString *byte, NSString *name))progress Complete:(void (^)(BOOL isSuccess, NSArray *url_Arr, NSArray *remark_Arr))complete;
- (NSString*)getFileNameWithImage:(UIImage*)image Identifier:(NSString*)identifier;

- (void)addImage:(UIImage*)image AtIndex:(NSUInteger)index WithRemark:(NSString*)remark;

@end
