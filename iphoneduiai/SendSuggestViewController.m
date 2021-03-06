//
//  SendSuggestViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-5.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SendSuggestViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"
#import "LoginViewController.h"

@interface SendSuggestViewController () <UIAlertViewDelegate>

@end

@implementation SendSuggestViewController
@synthesize contentTextView;
-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    contentTextView = [[[UITextView alloc]initWithFrame:CGRectMake(10, 20, 302, 140)]autorelease];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.delegate = self;
    [contentTextView becomeFirstResponder];
    
    
     contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 302, 130)]autorelease];
    contentLabel.textColor = RGBCOLOR(172, 172, 172);
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:16];
    contentLabel.text=@"感谢您下载使用对爱，如果您在使用过程中有任何不愉快体验,或有任何改进意见。\n请随时告知我们。\n您的意见对我们非常宝贵，再次感谢！\n\040                                               ---对爱团队";
    contentLabel.lineBreakMode = UILineBreakModeWordWrap;
    contentLabel.numberOfLines = 0;
    
    [contentLabel sizeToFit];
    [contentTextView addSubview:contentLabel];
    
    [self.view addSubview:contentTextView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[CustomBarButtonItem alloc] initRightBarButtonWithTitle:@"发送"
                                                                                                target:self
                                                                                                action:@selector(sendAction)] autorelease];

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"停用帐号"];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)sendAction
{
    
    NSMutableDictionary *dp = [Utils queryParams];
    [SVProgressHUD show];
    [[RKClient sharedClient] post:[@"/success/stop.api" stringByAppendingQueryParameters:dp] usingBlock:^(RKRequest *request){
        NSMutableDictionary *updateArgs = [NSMutableDictionary dictionary];
        updateArgs[@"sendtext"] = self.contentTextView.text;
        updateArgs[@"submitupdate"] = @"true";
        request.params = [RKParams paramsWithDictionary:updateArgs];
        
        // 请求失败时
        [request setOnDidFailLoadWithError:^(NSError *error){
            NSLog(@"Error: %@", [error description]);
        }];
        
        // 请求成功时
        [request setOnDidLoadResponse:^(RKResponse *response){

            if (response.isOK && response.isJSON)
            {
                NSDictionary *data = [response.bodyAsString objectFromJSONString];
                NSInteger code = [data[@"error"] integerValue];
                if (code == 0)
                {
                    [SVProgressHUD dismiss];
                    UIAlertView *note = [[UIAlertView alloc] initWithTitle:nil
                                                                   message:data[@"message"]
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:@"确定", nil];

                    [note show];
                    [note release];
                }
                else
                {
                    // 失败的情况
                    [SVProgressHUD showErrorWithStatus:data[@"message"]];
                }
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"网络故障"];
            }
        }];

        
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
    {
        return;
    }
    
    if (buttonIndex == 0)
    {
        // remote user info
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        LoginViewController *lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self presentModalViewController:lvc animated:YES];
        [lvc release];
    }

}

#define UITextFieldDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (contentTextView.text.length > 0)
        contentLabel.hidden = YES;
    else
        contentLabel.hidden = NO;
}

#pragma mark - key board notice
-(void)keyboardWillShow:(NSNotification*)note
{
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         CGRect r = CGRectZero;
         [[note.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] getValue:&r];
         CGRect rect = contentTextView.frame;
         rect.size.height = 460 -70-r.size.height;
         contentTextView.frame = rect;
         
     }];
    
}

@end
