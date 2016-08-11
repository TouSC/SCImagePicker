//
//  SCImagePicker.m
//  CardAppSample
//
//  Created by 唐绍成 on 16/3/14.
//  Copyright © 2016年 唐绍成. All rights reserved.
//

#import "SCImagePicker.h"
#import <objc/runtime.h>

@interface SCImagePicker ()

@property(nonatomic,strong)NSMutableArray *imageView_Arr;
@property(nonatomic,strong)NSMutableArray *image_Arr;

@end

@implementation SCImagePicker
{
    UIButton *add_Btn;
    UIButton *last_ImageView;
    SCAlbumController *albumController;
    NSDateFormatter *dateFormatter;
    NSInteger choseCount;
    
    UIAlertView *delete_Alert;
    UIAlertView *camera_Alert;
}

- (NSMutableArray*)image_Arr;
{
    if (!_image_Arr)
    {
        _image_Arr = [[NSMutableArray alloc] init];
    }
    return _image_Arr;
}

- (NSMutableArray*)imageURL_Arr;
{
    if (!_imageURL_Arr)
    {
        _imageURL_Arr = [[NSMutableArray alloc] init];
    }
    return _imageURL_Arr;
}

- (NSMutableArray*)remark_Arr;
{
    if (!_remark_Arr)
    {
        _remark_Arr = [[NSMutableArray alloc] init];
    }
    return _remark_Arr;
}

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView_Arr = [[NSMutableArray alloc] init];
        _scale = 0.0f;
        _maxCount = 9;
        choseCount = 0;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMddHHmmssSSS"];
        add_Btn = [UIButton new];
        [add_Btn addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        add_Btn.translatesAutoresizingMaskIntoConstraints = NO;
        [add_Btn setImage:[UIImage imageNamed:@"add_image_ic"] forState:UIControlStateNormal];
        _image_width = 40.0;
        _image_height = 40.0;
        self.clipsToBounds = YES;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 16+_image_height);
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setImage_width:(CGFloat)image_width;
{
    _image_width = image_width;
    [self layoutIfNeeded];
}

- (void)setImage_height:(CGFloat)image_height;
{
    _image_height = image_height;
    [self layoutIfNeeded];
}

- (id)init;
{
    return [self initWithFrame:CGRectZero];
}

- (void)layoutIfNeeded;
{
    self.userInteractionEnabled = NO;
    [add_Btn removeFromSuperview];
    [self addSubview:add_Btn];
    NSString *h_ConstrainsFormat;
    NSString *v_ConstrainsFormat;
    NSDictionary *view_Dic;
    if (!last_ImageView)
    {
        h_ConstrainsFormat = [NSString stringWithFormat:@"H:|-[add_Btn(==%.2f)]",_image_width];
        v_ConstrainsFormat = [NSString stringWithFormat:@"V:|-[add_Btn(==%.2f)]",_image_height];
        view_Dic = NSDictionaryOfVariableBindings(add_Btn);
    }
    else
    {
        view_Dic = NSDictionaryOfVariableBindings(last_ImageView,add_Btn);
        if (last_ImageView.frame.origin.x+last_ImageView.frame.size.width+8+_image_width>[UIScreen mainScreen].bounds.size.width)//换行
        {
            h_ConstrainsFormat = [NSString stringWithFormat:@"H:|-[add_Btn(==%.2f)]",_image_width];
            v_ConstrainsFormat = [NSString stringWithFormat:@"V:[last_ImageView]-[add_Btn(==%.2f)]",_image_height];
        }
        else
        {
            h_ConstrainsFormat = [NSString stringWithFormat:@"H:[last_ImageView]-[add_Btn(==%.2f)]",_image_width];
            v_ConstrainsFormat = [NSString stringWithFormat:@"V:[add_Btn(==%.2f)]",_image_width];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:add_Btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:last_ImageView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        NSArray *add_h_Constraints = [NSLayoutConstraint constraintsWithVisualFormat:h_ConstrainsFormat options:0 metrics:nil views:view_Dic];
        [self addConstraints:add_h_Constraints];
        if (v_ConstrainsFormat)
        {
            NSArray *add_v_Constraints = [NSLayoutConstraint constraintsWithVisualFormat:v_ConstrainsFormat options:0 metrics:nil views:view_Dic];
            [self addConstraints:add_v_Constraints];
        }
        [add_Btn layoutIfNeeded];
        [self layoutSubviews];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, add_Btn.frame.origin.y+add_Btn.frame.size.height+8);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        if (_imageView_Arr.count>=_maxCount)
        {
            [UIView animateWithDuration:0.5 animations:^{
                add_Btn.alpha = 0;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                add_Btn.alpha = 1;
            }];
        }
    }];
}

- (void)addImage:(UIImage*)image AtIndex:(NSUInteger)index WithRemark:(NSString*)remark;
{
    choseCount++;
    UIButton *imageView = [UIButton new];
    imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageView];
    imageView.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
        imageView.alpha = 1;
    } completion:nil];
    [imageView setImage:image forState:UIControlStateNormal];
    imageView.frame = add_Btn.frame;
    last_ImageView = imageView;
    [self layoutIfNeeded];
    [self.imageView_Arr addObject:imageView];
    [self.image_Arr addObject:image];
    [self.remark_Arr addObject:remark];
    
    imageView.tag = 100+_imageView_Arr.count;
    
    if (_editable)
    {
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 2.0f;
        UIButton *edit_Btn = [[UIButton alloc] initWithFrame:CGRectMake(_image_height, 0, _image_width-_image_height, _image_height)];
        edit_Btn.backgroundColor = [UIColor whiteColor];
        [edit_Btn setTitle:remark.length?remark:@"编辑" forState:UIControlStateNormal];
        [edit_Btn setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
        [edit_Btn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:edit_Btn];
    }
    if (_deleteStyle==SCImagePickerDeleteStyleButton)
    {
        UIButton *remove_Btn = [[UIButton alloc] initWithFrame:CGRectMake(_image_width-30, _image_height-30, 30, 30)];
        remove_Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        remove_Btn.backgroundColor = [UIColor redColor];
        [remove_Btn addTarget:self action:@selector(clickRemoveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:remove_Btn];
    }
}

- (void)addImage:(UIImage*)image AtIndex:(NSUInteger)index;
{
    [self addImage:image AtIndex:index WithRemark:@""];
}

- (void)removeImageAtIndex:(NSUInteger)index;
{
    if (index+1>_imageView_Arr.count)
    {
        return;
    }
    choseCount--;
    NSArray *followImageView_Arr = [_imageView_Arr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, _imageView_Arr.count-index)]];
    followImageView_Arr = [[followImageView_Arr reverseObjectEnumerator] allObjects];
    for (UIImageView *imageView in followImageView_Arr)
    {
        imageView.tag--;
        NSUInteger imageIndex = [_imageView_Arr indexOfObject:imageView];
        if (imageIndex>=1)
        {
            UIImageView *pre_ImageView = _imageView_Arr[imageIndex-1];
            [UIView animateWithDuration:0.5 animations:^{
                imageView.frame = pre_ImageView.frame;
            }];
        }
    }
    [self.imageView_Arr[index] removeFromSuperview];
    [self.imageView_Arr removeObjectAtIndex:index];
    [self.image_Arr removeObjectAtIndex:index];
    last_ImageView = [_imageView_Arr lastObject];
    [self layoutIfNeeded];
}

#pragma mark - ges
- (void)upload:(NSString* (^)(NSString *byte))progress Complete:(void (^)(void))complete;
{
    DACircularProgressView *hud = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40.0, 40.0)];
    hud.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    hud.roundedCorners = YES;
    hud.trackTintColor = [UIColor clearColor];
    [[(UIViewController*)_delegate view]addSubview:hud];
    [hud setProgress:0.1 animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<self.image_Arr.count; i++)
        {
            UIImage *image = _image_Arr[i];
            NSData *imageData = [self dataWithImage:image];
            NSString *imageDataStr = [imageData base64EncodedStringWithOptions:0];
            NSString *url = progress(imageDataStr);
            if ([url isKindOfClass:[NSString class]])
            {
                if (url.length)
                {
                    [self.imageURL_Arr addObject:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud setProgress:(float)(i+1)/(float)self.image_Arr.count animated:YES];
                    });
                    continue;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud setHidden:YES];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud setHidden:YES];
            });
        });
    });
}

- (void)clickImage:(UIButton*)image;
{
    NSUInteger index = image.tag-101;
    
    UIViewController *viewController = (UIViewController*)_delegate;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIView *bg_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    bg_View.backgroundColor = [UIColor blackColor];
    bg_View.alpha = 0;
    [viewController.view addSubview:bg_View];
    
    UIImageView *open_ImageView = self.imageView_Arr[index];
    open_ImageView.hidden = YES;
    __block CGRect rect = [viewController.view convertRect:open_ImageView.frame fromView:open_ImageView.superview];
    UIImageView *copyImageView = [[UIImageView alloc] initWithFrame:rect];
    copyImageView.contentMode = UIViewContentModeScaleAspectFill;
    copyImageView.image = _image_Arr[index];
    copyImageView.clipsToBounds = YES;
    [viewController.view addSubview:copyImageView];
    [UIView animateWithDuration:0.5 animations:^{
        bg_View.alpha = 1;
        copyImageView.frame = CGRectMake(0, 0, screenWidth, screenWidth/copyImageView.image.size.width*copyImageView.image.size.height);
        copyImageView.center = CGPointMake(screenWidth/2, screenHeight/2);
    }completion:^(BOOL finished) {
        __block UIImageView *close_ImageView;
        NSMutableArray *image_Arr = [NSMutableArray array];
        for (UIImage *image in _image_Arr)
        {
            if (image.size.width)
            {
                [image_Arr addObject:image];
            }
        }
        albumController = [[SCAlbumController alloc]initWithImageArray:image_Arr Page:index DismissProgress:^(NSUInteger page) {
            close_ImageView = self.imageView_Arr[page];
            copyImageView.image = self.image_Arr[page];
        } Complete:^{
            [bg_View removeFromSuperview];
            [UIView animateWithDuration:0.5 animations:^{
                copyImageView.contentMode = UIViewContentModeScaleAspectFill;
                copyImageView.frame = [viewController.view convertRect:close_ImageView.frame fromView:close_ImageView.superview];
            }completion:^(BOOL finished) {
                open_ImageView.hidden = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    copyImageView.alpha = 0;
                }completion:^(BOOL finished) {
                    [copyImageView removeFromSuperview];
                }];
            }];
        }];
        
        if (_deleteStyle==SCImagePickerDeleteStyleInner)
        {
            UIButton *remove_Btn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-70, 20, 60, 60)];
            remove_Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [remove_Btn setTitle:@"删除" forState:UIControlStateNormal];
            [remove_Btn addTarget:self action:@selector(clickRemoveBtn:) forControlEvents:UIControlEventTouchUpInside];
            [albumController.view addSubview:remove_Btn];
        }
        
        [viewController presentViewController:albumController animated:NO completion:nil];
    }];
}

- (void)clickAddButton:(UIButton*)btn;
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    if ([_delegate isKindOfClass:[UIViewController class]])
    {
        [actionSheet showInView:[(UIViewController*)_delegate view]];
    }
}

- (void)clickRemoveBtn:(UIButton*)btn;
{
    if (_deleteStyle==SCImagePickerDeleteStyleInner)
    {
        albumController.dismissProgress(albumController.page);
        [albumController dismissViewControllerAnimated:NO completion:^{
            albumController.dismissComplete();
            [self removeImageAtIndex:albumController.page];
        }];
    }
    else
    {
        delete_Alert = [[UIAlertView alloc] initWithTitle:@"确认删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        objc_setAssociatedObject(delete_Alert, 0x00, @(btn.superview.tag-101), OBJC_ASSOCIATION_RETAIN);
        [delete_Alert show];
    }
}

- (void)clickEditBtn:(UIButton*)btn;
{
    DoodleViewController *doodle_vc = [[DoodleViewController alloc] init];
    doodle_vc.image = _image_Arr[btn.superview.tag-101];
    doodle_vc.delegate = self;
    doodle_vc.remark = btn.titleLabel.text;
    doodle_vc.view.tag = btn.superview.tag;
    [(UIViewController*)_delegate presentViewController:doodle_vc animated:YES completion:nil];
}
- (void)DoodleViewController:(DoodleViewController *)viewController DidFinishDrewWithImage:(UIImage *)image Remark:(NSString *)remark;
{
    [self removeImageAtIndex:viewController.view.tag-101];
    [self addImage:image AtIndex:viewController.view.tag-101 WithRemark:remark];
    [self.remark_Arr addObject:remark];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        __block NSUInteger i = choseCount;
        for (ALAsset *asset in assets)
        {
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = [assetRep fullResolutionImage];
            UIImage *result = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
            if (result.size.width > 0)
            {
                [self addImage:result AtIndex:i];
            }
            i++;
        }
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController;
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle;
{
    [self addImage:image AtIndex:choseCount];
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_scale)//需要裁剪
    {
        UIView *bg_View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        bg_View.backgroundColor = [UIColor blackColor];
        [[(UIViewController*)_delegate view] addSubview:bg_View];
        TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
        cropViewController.defaultAspectRatio = _scale?:1;
        cropViewController.aspectRatioLocked = YES;
        cropViewController.delegate = self;
        [picker dismissViewControllerAnimated:NO completion:nil];
        [(UIViewController*)_delegate presentViewController:cropViewController animated:NO completion:^{
            [bg_View removeFromSuperview];
        }];
    }
    else
    {
        [self addImage:image AtIndex:choseCount];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSData*)dataWithImage:(UIImage*)image;
{
    BOOL isPNG = NO;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if (imageData==nil)
    {
        isPNG = YES;
        imageData = UIImagePNGRepresentation(image);
    }
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin/1024;
    if (sizeOriginKB > 200)
    {
        float a = 200.00000;
        float b = (float)sizeOriginKB;
        float q = sqrt(a/b);
        CGSize sizeImage = [image size];
        CGFloat iwidthSmall = sizeImage.width * q;
        CGFloat iheightSmall = sizeImage.height * q;
        CGSize itemSizeSmall = CGSizeMake(iwidthSmall, iheightSmall);
        UIGraphicsBeginImageContext(itemSizeSmall);
        CGRect imageRectSmall = CGRectMake(0.0f, 0.0f, itemSizeSmall.width, itemSizeSmall.height);
        [image drawInRect:imageRectSmall];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *dataImageSend = isPNG?UIImagePNGRepresentation(smallImage):UIImageJPEGRepresentation(smallImage, 0.5);
        imageData = dataImageSend;
    }
    return imageData;
}

#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView==camera_Alert)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                break;
            }
            case 1:
            {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                break;
            }
        }
    }
    else if (alertView==delete_Alert)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                break;
            }
            case 1:
            {
                NSNumber *index = objc_getAssociatedObject(delete_Alert, 0x00);
                [self removeImageAtIndex:[index integerValue]];
                break;
            }
        }
    }
}

#pragma mark - actionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSUInteger leftCount = _maxCount-choseCount;
    if (leftCount<=0)
    {
        return;
    }
    switch (buttonIndex)
    {
        case 0:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
            {
                camera_Alert = [[UIAlertView alloc]initWithTitle:@"请在设置里打开允许访问相机" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[[UIDevice currentDevice].systemVersion compare:@"8.0.0" options:NSNumericSearch]==NSOrderedAscending?nil:@"设置", nil];
                [camera_Alert show];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [(UIViewController*)_delegate presentViewController:picker animated:YES completion:nil];
            break;
        }
        case 1:
        {
            ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (authStatus!=ALAuthorizationStatusAuthorized && authStatus!=ALAuthorizationStatusNotDetermined)
            {
                camera_Alert = [[UIAlertView alloc]initWithTitle:@"请在设置里打开允许访问相册" message:nil delegate:self cancelButtonTitle:@"SCIMAGEPICKER_CANCEL" otherButtonTitles:[[UIDevice currentDevice].systemVersion compare:@"8.0.0" options:NSNumericSearch]==NSOrderedAscending?nil:@"设置", nil];
                [camera_Alert show];
                return;
            }
            if (!_scale)
            {
                QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.maximumNumberOfSelection = leftCount;
                imagePickerController.showsNumberOfSelectedAssets = YES;
                [(UIViewController*)_delegate presentViewController:imagePickerController animated:YES completion:nil];
            }
            else
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [(UIViewController*)_delegate presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - function

- (NSString*)getFileNameWithImage:(UIImage*)image Identifier:(NSString*)identifier;
{
    NSString *append_Str = @".png";
    @autoreleasepool {
        if (UIImageJPEGRepresentation(image, 0.5))
        {
            append_Str = @".jpg";
        }
    }
    NSString *dtNow = [dateFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@%@%@",identifier,dtNow,append_Str];
}

@end
