//
//  SCImageEditViewController.m
//  GreenViewVilla
//
//  Created by 唐绍成 on 16/8/16.
//  Copyright © 2016年 Tousan. All rights reserved.
//

#import "SCImageEditViewController.h"

@interface SCImageEditViewController ()

@end

@implementation SCImageEditViewController
{
    UITableView *bg_TableView;
    RepairTextViewCell *textViewCell;
}
#pragma mark - 初始化
- (id)init;
{
    self = [super init];
    if (self)
    {
        ;
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarAttibute];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 初始化UI
- (void)setUI;
{
    bg_TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    bg_TableView.delegate = self;
    bg_TableView.dataSource = self;
    [self.view addSubview:bg_TableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.row)
    {
        case 0:
        {
            return [UIScreen mainScreen].bounds.size.width;
        }
        case 1:
        {
            return 180.0f;
        }
        default:
            break;
    }
    return 0.1f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    switch (indexPath.row)
    {
        case 0:
        {
            UITableViewCell *imageCell = [[UITableViewCell alloc] init];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
            _imageView.image = _image;
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView.userInteractionEnabled = YES;
            [imageCell.contentView addSubview:_imageView];
            
            UIButton *edit_Btn = [UIButton new];
            [_imageView addSubview:edit_Btn];
            [edit_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_imageView.mas_right);
                make.bottom.equalTo(_imageView.mas_bottom);
                make.width.offset(40.0f);
                make.height.offset(40.0f);
            }];
            [edit_Btn setImage:[UIImage imageNamed:@"edit_image_ic"] forState:UIControlStateNormal];
            [edit_Btn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
            return imageCell;
        }
        case 1:
        {
            textViewCell = [[RepairTextViewCell alloc] init];
            textViewCell.title_Label.text = @"添加图片描述";
            textViewCell.textView.text = @"";
            textViewCell.textView.placeHolder = @"最多输入500字";
            textViewCell.textView.maxCount = 500;
            textViewCell.textView.myDelegate = self;
            return textViewCell;
        }
    }
    return [UITableViewCell new];
}

- (void)setNavigationBarAttibute;
{
    UIBarButtonItem *confirm_Btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickDoneBtn)];
    [self.navigationItem setRightBarButtonItem:confirm_Btn];
}

#pragma mark - 加载UI
- (void)loadUI;
{
    
}

#pragma mark - 交互响应方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self.view endEditing:NO];
}

- (void)SCTextViewShouldBeginEditing:(SCTextView *)textView;
{
    [UIView animateWithDuration:0.2 animations:^{
        bg_TableView.contentOffset = CGPointMake(0,[UIScreen mainScreen].bounds.size.width);
    }];
}
- (void)SCTextViewShouldEndEditing:(SCTextView *)textView;
{
    [UIView animateWithDuration:0.2 animations:^{
        bg_TableView.contentOffset = CGPointMake(0,0);
    }];
}
- (void)SCTextViewDidChange:(SCTextView *)textView;
{
    textViewCell.count_Label.text = [NSString stringWithFormat:@"%d/%d",textView.text.length,textView.maxCount];
}

- (IBAction)clickEditBtn:(id)sender {
    DoodleViewController *doodle_vc = [[DoodleViewController alloc] init];
    doodle_vc.image = self.image;
    doodle_vc.delegate = self;
    [self.navigationController pushViewController:doodle_vc animated:YES];
}

- (void)clickDoneBtn;
{
    if (_delegate && [_delegate respondsToSelector:@selector(SCImageEditViewController:DidEndEdit:Remark:)])
    {
        [_delegate SCImageEditViewController:self DidEndEdit:_imageView.image Remark:textViewCell.textView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)DoodleViewController:(DoodleViewController*)viewController DidFinishDrewWithImage:(UIImage*)image Remark:(NSString*)remark;
{
    _imageView.image = image;
}

#pragma mark - 其他

@end
