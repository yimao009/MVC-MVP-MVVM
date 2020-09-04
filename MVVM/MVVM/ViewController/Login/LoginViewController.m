//
//  LoginViewController.m
//  MVVM
//
//  Created by guoruize on 2020/8/23.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginInputView.h"
//#import <FBKVOController.h>
#import <Masonry.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UIView *inputBaseView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/// 输入框
@property (nonatomic, readwrite, weak) LoginInputView *inputView;

// viewModel
@property (nonatomic, readwrite, strong) LoginViewModel *viewModel;
@end

@implementation LoginViewController
{
    
}
- (instancetype) initWithViewModel:(LoginViewModel *)viewModel
{
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupNavigationItem];
    
    [self _setupSubViews];
    
    [self _bindViewModel];
}


- (void)_fillupTextField
{
    self.inputView.phoneTextField.text = @"13331135676";
    self.inputView.verifyTextField.text = @"1234";
    
    [self _textFieldValueDidChange:nil];
}

/// textField数据改变
- (void)_textFieldValueDidChange:(UITextField *)tf
{
    self.viewModel.mobilePhone = self.inputView.phoneTextField.text;
    self.viewModel.verifyCode  = self.inputView.verifyTextField.text;
    self.loginBtn.enabled  = self.viewModel.valildLogin;
}

#pragma mark - BindModel
- (void)_bindViewModel
{
    [self.viewModel addObserver:self forKeyPath:@"avatarUrlString" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSKeyValueObservingOptionNew
    NSString *userAvatarURL = change[NSKeyValueChangeNewKey];
    NSLog(@"url %@", userAvatarURL);
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"填充" style:UIBarButtonItemStylePlain target:self action:@selector(_fillupTextField)];
}

- (void)_setupSubViews
{
    LoginInputView *inputView = [LoginInputView inputView];
    self.inputView = inputView;
    [self.inputBaseView addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    
    
    
    [inputView.phoneTextField addTarget:self action:@selector(_textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    [inputView.verifyTextField addTarget:self action:@selector(_textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];

}

@end
