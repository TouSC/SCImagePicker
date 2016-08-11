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
#import "ChatBarContainer.h"

@interface DoodleViewController () <ChatBarContainerDelegate>

@property (strong, nonatomic)TouchDrawView *drewArea;

@end

@implementation DoodleViewController
{
    UIImageView *doodleImgView;
    ChatBarContainer *chat_Bar;
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
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    [chat_Bar.txtView resignFirstResponder];
}

- (void)setUI
{
    [self setBg_ImgView];
    [self setTouchDrawView];
    [self setUndoAndRedoBtn];
    [self setCoverView];
    chat_Bar = [[ChatBarContainer alloc]init];
    chat_Bar.max_Count = 140;
    chat_Bar.delegate = self;
    chat_Bar.isTextRequired = NO;
    chat_Bar.txtView.text = _remark;
    chat_Bar.txtView.placeHolder = @"";
    [self.view addSubview:chat_Bar];
    [chat_Bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(chat_Bar.frame.size.height);
    }];
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
        make.edges.insets(UIEdgeInsetsMake(kNavigationBarHeight, 0, kBottomBtnHeight, 0));
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
        make.edges.insets(UIEdgeInsetsMake(kNavigationBarHeight, 0, kBottomBtnHeight, 0));
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
        make.top.offset(20+10);
        make.width.height.offset(30);
    }];
    undoBtn.layer.masksToBounds = YES;
    undoBtn.layer.cornerRadius = 15;
    undoBtn.backgroundColor = [UIColor lightGrayColor];
    [undoBtn addTarget:self action:@selector(clickUndoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //重做button
    UIButton *redoBtn = [UIButton new];
    [self.view addSubview:redoBtn];
    [redoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(20+10);
        make.width.height.offset(30);
    }];
    redoBtn.layer.masksToBounds = YES;
    redoBtn.layer.cornerRadius = 15;
    redoBtn.backgroundColor = [UIColor lightGrayColor];
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
        make.center.equalTo(self.view);
        make.width.offset(120);
        make.height.offset(30);
    }];
    promptLbl.font = [UIFont systemFontOfSize:12];
    promptLbl.text = @"点击开始绘制";
    promptLbl.textColor = [UIColor blackColor];
    promptLbl.textAlignment = NSTextAlignmentCenter;
    promptLbl.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    promptLbl.layer.cornerRadius = 8;
    promptLbl.layer.masksToBounds = YES;
    [promptLbl sizeToFit];
}

- (void)setBottomBtn
{
    UIButton *bottomBtn = [UIButton new];
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(kBottomBtnHeight);
    }];
    [bottomBtn setTitle:@"完成" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
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
