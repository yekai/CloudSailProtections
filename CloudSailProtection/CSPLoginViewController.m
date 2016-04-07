//
//  CSPLoginViewController.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPLoginViewController.h"
#import "CSPGlobalConstants.h"
#import "AMSmoothAlertView.h"
#import "MBProgressHUD.h"
#import "AFAppDotNetAPIClient.h"
#import "CSPGlobalViewControlManager.h"
#import "Post.h"


@interface CSPLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@end

@implementation CSPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set username and password left view
    UIView *(^createLeftView)(NSString *) = ^(NSString *viewType)
    {
        UIView *view = [[UIView alloc]init];
        UIImage *image = [UIImage imageNamed:viewType];
        view.frame = CGRectMake(0, 0, 20 + image.size.width, image.size.height);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(10, 0, image.size.width, image.size.height);
        [view addSubview:imageView];
        return view;
    };
    
    self.userName.leftView = createLeftView(@"user");
    self.password.leftView = createLeftView(@"password");
    self.userName.leftViewMode = UITextFieldViewModeAlways;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnTapped:(id)sender
{
    NSString *username = self.userName.text;
    NSString *password = self.password.text;
    
    if (!username || username.length == 0)
    {
        //todo: alert user name should not be empty
        [self presentAlertErrorWithErrorType:LoginErrorTypeNoUserName];
        return;
    }
    
    if (!password || password.length == 0)
    {
        //todo: alert password should not be empty
        [self presentAlertErrorWithErrorType:LoginErrorTypeNoPassword];
        return;
    }
    
    if (username && password)
    {
        //show loading view
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __block CSPLoginViewController *weakSelf = self;
        //create pull request to log in with user name and password
        [Post loginWithUserId:username
                     password:password
                     andBlock:^(BOOL isSuccess){
                            //present fail alert to tell customer
                              if (!isSuccess)
                              {
                                  [weakSelf loginFail];
                              }
                              else
                              {
                                  //login success, dismiss login view, display default dash view
                                  [weakSelf dismissView];
                              }
                     }
              andFailureBlock:^{
                         [weakSelf loginFail];
                     }];
    }
}

- (void)dismissView
{
    //hide loading view
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginFail
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //display login in fail alert
    [self presentAlertErrorWithErrorType:LoginErrorTypeUserNamePasswordNoMatch];
}

//reset username and password
- (IBAction)resetBtnTapped:(id)sender
{
    self.userName.text = @"";
    self.password.text = @"";
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

-(void)presentAlertErrorWithErrorType:(LoginErrorType)type
{
    NSString *message = @"";
    UITextField *focusText = nil;
    switch (type)
    {
        case LoginErrorTypeNoUserName:
            message = @"请输入用户名";
            focusText = self.userName;
            break;
            
        case LoginErrorTypeNoPassword:
            message = @"请输入密码";
            focusText = self.password;
            break;
            
        case LoginErrorTypeUserNamePasswordNoMatch:
            message = @"用户名或者密码错误";
            [self resetBtnTapped:nil];
            focusText = self.userName;
            break;
            
        default:
            break;
    }
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"错误" andText:message andCancelButton:NO forAlertType:AlertFailure];
    [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
    alert.cornerRadius = 3.0f;
    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
        [focusText becomeFirstResponder];
    };

    [alert show];

}

@end
