//
//  DoodleViewController.m
//  GreenViewVilla
//
//  Created by jocc6 on 16/3/16.
//  Copyright © 2016年 Tousan. All rights reserved.
//
#define kNavigationBarHeight 64

#define kUndoRedoBtnSize 50

#define kBottomBtnHeight 60

#define kPromptLblHeight 40

#import "DoodleViewController.h"

@interface DoodleViewController ()

@property (strong, nonatomic)TouchDrawView *drewArea;

@end

@implementation DoodleViewController
{
    UIImageView *doodleImgView;
}

- (id)init{
    if (self=[super init])
    {
        _remark = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIBarButtonItem *confirm_Btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickBottomBtn:)];
    [self.navigationItem setRightBarButtonItem:confirm_Btn];
}

- (void)setUI
{
    [self setBg_ImgView];
    [self setTouchDrawView];
    [self setUndoAndRedoBtn];
    [self setCoverView];
}

- (void)chatBarDidBecomeActive;
{
    _drewArea.userInteractionEnabled = NO;
}

- (void)chatBarDidEndEdit;
{
    _drewArea.userInteractionEnabled = YES;
}
- (void)clickSendWithContent:(NSString *)content;
{
    _remark = content?:@"";
    [self clickBottomBtn:nil];
}

- (void)setBg_ImgView
{
    doodleImgView = [UIImageView new];
    [self.view addSubview:doodleImgView];
    [doodleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    doodleImgView.image = _image;
    doodleImgView.contentMode = UIViewContentModeScaleAspectFit;
}

//设置绘画的View
- (void)setTouchDrawView
{
    _drewArea = [[TouchDrawView alloc] init];
    [self.view addSubview:_drewArea];
    [_drewArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    [_drewArea setDrawColor:[UIColor redColor]];
}

//设置撤销和重做button
- (void)setUndoAndRedoBtn
{
    //撤销button
    UIButton *undoBtn = [UIButton new];
    [self.view addSubview:undoBtn];
    [undoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(64+10);
        make.width.height.offset(30);
    }];
    undoBtn.layer.masksToBounds = YES;
    undoBtn.layer.cornerRadius = 15;
    [undoBtn setImage:[UIImage imageNamed:@"undo_ic"] forState:UIControlStateNormal];
    [undoBtn addTarget:self action:@selector(clickUndoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //重做button
    UIButton *redoBtn = [UIButton new];
    [self.view addSubview:redoBtn];
    [redoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(64+10);
        make.width.height.offset(30);
    }];
    redoBtn.layer.masksToBounds = YES;
    redoBtn.layer.cornerRadius = 15;
    [redoBtn setImage:[UIImage imageNamed:@"redo_ic"] forState:UIControlStateNormal];
    [redoBtn addTarget:self action:@selector(clickRedo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCoverView
{
    UIView *coverView = [UIView new];
    [self.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(doodleImgView);
    }];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView:)];
    [coverView addGestureRecognizer:tapGest];
    
    UILabel *promptLbl = [UILabel new];
    [coverView addSubview:promptLbl];
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(64/2);
        make.width.offset(120);
        make.height.offset(40);
    }];
    promptLbl.font = [UIFont systemFontOfSize:14];
    promptLbl.text = @"点击开始绘制";
    promptLbl.textColor = [UIColor whiteColor];
    promptLbl.textAlignment = NSTextAlignmentCenter;
    promptLbl.backgroundColor = [UIColor blackColor];
    promptLbl.alpha = 0.6;
    promptLbl.layer.cornerRadius = 5;
    promptLbl.layer.masksToBounds = YES;
    [promptLbl sizeToFit];
}

//点击撤销
- (void)clickUndoBtn:(UIButton *)undoBtn
{
    [_drewArea undo];
}

//点击重做
- (void)clickRedo:(UIButton *)redoBtn
{
    [_drewArea redo];
}

//点击确定
- (void)clickBottomBtn:(UIButton *)bottomBtn
{
    //doodleImgView.frame.size
    UIImage *shotScreenImg = [self shotScreenView:@[doodleImgView,_drewArea] withSize:doodleImgView.frame.size];
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(DoodleViewController:DidFinishDrewWithImage:Remark:)])
    {
        [_delegate DoodleViewController:self DidFinishDrewWithImage:shotScreenImg Remark:_remark];
    }
}

//截图
- (UIImage*)shotScreenView:(NSArray *)viewArr withSize:(CGSize)size{
    //
    UIGraphicsBeginImageContextWithOptions(size, ((UIView *)(viewArr[0])).opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIView *view in viewArr) {
        [view.layer renderInContext:context];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    return image;
}


- (void)clickLeftBtn:(UIButton *)leftBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapCoverView:(UITapGestureRecognizer *)tapGest
{
    //移除coverView
    [tapGest.view removeFromSuperview];
}


@end
