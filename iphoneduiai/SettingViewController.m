//
//  SettingViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-9-30.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SettingViewController.h"
#import "RemindViewController.h"
#import "PreventSetViewController.h"
#import "ChangePasswordViewController.h"
#import "StopAccountViewController.h"
#import "AboutViewController.h"
#import "AddPicViewController.h"
#import "BlockUsersViewController.h"
#import "AsyncImageView.h"
#import "CustomBarButtonItem.h"
#import "SendSuggestViewController.h"
#import "DigoUsersViewController.h"
#import "SVProgressHUD.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "LoginViewController.h"

#define kActionChooseImageTag 201
static int behindImgTag = 103;

@interface SettingViewController ()

@property (strong, nonatomic) NSArray *entries;
@property (strong, nonatomic) AsyncImageView *avatarImageView;

@end

@implementation SettingViewController
@synthesize entries = _entries;

- (void)dealloc
{
    [_showPhotoView release];
    //    [_photos release];
    [_entries release];
    [_avatarImageView release];
    [super dealloc];
}

- (NSArray *)entries
{
    if (_entries == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"settingEntries" withExtension:@"plist"];
        _entries = [[NSArray alloc] initWithContentsOfURL:url];
    }
    
    return _entries;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(10, 50, 300, 44);
    exitButton.backgroundColor =RGBCOLOR(226, 86, 89);
    
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    exitButton.titleLabel.text = @"退出";
    exitButton.titleLabel.textColor = [UIColor whiteColor];
    [exitButton addTarget:self action:@selector(resginAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:exitButton];
    self.tableView.tableFooterView = footView;
    [footView release];
    
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.entries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [(NSArray *)[self.entries objectAtIndex:section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    
    int frontImgTag = 101;
    int bigLabelTag = 102;
    
    int smallImgTag= 104;
    int lineTag = 105;
    int bgViewTag = 106;
    int arrowTag = 107;
    
    UIImageView* frontImg = nil;
    UILabel* bigLabel=nil;
    UILabel* smallLabel=nil;
    AsyncImageView* behindImg=nil;
    UIImageView* lineView=nil;
    UIView* bgView = nil;
    UIImageView* arrowImgView = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        bgView = [[[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)] autorelease];
        bgView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:bgView];
        
        frontImg = [[[UIImageView alloc] initWithFrame: CGRectMake(10, 13, 18, 18)] autorelease];
        frontImg.tag = frontImgTag;
        
        lineView= [[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 300, 1)]autorelease];
        lineView.image =  [UIImage imageNamed:@"line.png"];
        lineView.tag = lineTag;
        [bgView addSubview:lineView];
        
        behindImg = [[[AsyncImageView alloc]initWithFrame:CGRectZero] autorelease];
        behindImg.tag=behindImgTag;
        
        behindImg.frame = CGRectMake(230, 4, 36, 36);
        [bgView addSubview:behindImg];
        
        
        bigLabel = [[[UILabel alloc]initWithFrame:CGRectZero] autorelease];
        bigLabel.backgroundColor=[UIColor clearColor];
        bigLabel.font = [UIFont systemFontOfSize:14.0f];
        bigLabel.tag=bigLabelTag;
        [bgView addSubview:bigLabel];
        
        smallLabel = [[[UILabel alloc]initWithFrame:CGRectMake(230, 15, 50, 14)] autorelease];
        smallLabel.backgroundColor=[UIColor clearColor];
        [bgView addSubview:smallLabel];
        smallLabel.tag=smallImgTag;
        smallLabel.font = [UIFont systemFontOfSize:12];
        smallLabel.textColor = [UIColor grayColor];
        
        arrowImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(280, 15, 14, 14)] autorelease];
        [cell addSubview:arrowImgView];
        
    }
    
    if (bgView == nil)
        bgView = (UIView*)[cell viewWithTag:bgViewTag];
    
    if (lineView == nil)
        lineView = (UIImageView*)[cell viewWithTag:lineTag];
    
    if (frontImg == nil)
        frontImg= (UIImageView*)[cell viewWithTag:frontImgTag];
    
    if (behindImg == nil)
        behindImg= (AsyncImageView*)[cell viewWithTag:behindImgTag];
    
    if (bigLabel == nil)
        bigLabel = (UILabel*)[cell viewWithTag:bigLabelTag];
    
    if (smallLabel == nil)
        smallLabel = (UILabel*)[cell viewWithTag:smallImgTag];
    if (arrowImgView ==nil) {
        arrowImgView = (UIImageView*)[cell viewWithTag:arrowTag];
    }
    
    NSDictionary *data = [[self.entries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIImage *img = nil;
    UIImage *headImg = nil;
    UIImage *arrowImg = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    
    if (![[data objectForKey:@"logo"] isEqualToString:@""]) {
        bigLabel.frame = CGRectMake(40, 0, 200, 44);
        img = [UIImage imageNamed:[data objectForKey:@"logo"]];
        
    } else{
        bigLabel.frame = CGRectMake(10, 0, 200, 44);
    }
    
    bigLabel.text = [data objectForKey:@"text"];
    [bgView addSubview:lineView];
    frontImg.image = img;
    [bgView addSubview:frontImg];
    
    if ([[data objectForKey:@"haveNext"] boolValue]) {
        arrowImgView.image = arrowImg;
    } else{
        arrowImgView.image = nil;
    }
    behindImg.image = headImg;
    if ([[data objectForKey:@"label"] isEqualToString:@"set_avatar"]) {
        NSDictionary *info = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"info"];
        [behindImg loadImage:info[@"photo"]];
        self.avatarImageView = behindImg;
    }else if([[data objectForKey:@"label"] isEqualToString:@"my_photo"])
    {
        smallLabel.text = [NSString stringWithFormat:@"共%d张", self.showPhotoView.photos.count];
    }else if([[data objectForKey:@"label"] isEqualToString:@"up_person"])
    {
        smallLabel.text = @"共13人";
    } else{
        smallLabel.text = @"";
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 15;
    else
        return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header= [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
    if (section == 0)
        header.frame = CGRectMake(0, 0, 320, 15);
    else
        header.frame = CGRectMake(0, 0, 320, 25);
    return header;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [[self.entries objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *label = data[@"label"];
    if ([label isEqualToString:@"set_avatar"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"从资源库",@"拍照",nil];
            actionSheet.tag=kActionChooseImageTag;
            [actionSheet showInView:self.view];
            [actionSheet release];
            
        } else {
            
            UIImagePickerController *picker = [[[UIImagePickerController alloc] init]autorelease];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    } else if ([label isEqualToString:@"my_photo"]){
        
        AddPicViewController *addPicViewController  = [[[AddPicViewController alloc]init]autorelease];
        //        addPicViewController.photos = self.photos;
        addPicViewController.showPhotoView = self.showPhotoView;
        [self.navigationController pushViewController:addPicViewController animated:YES];
        
    } else if ([label isEqualToString:@"set_notify"]){
        
        RemindViewController *remindViewController = [[[RemindViewController alloc]initWithNibName:@"RemindViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:remindViewController animated:YES];
        
    } else if ([label isEqualToString:@"set_nowarn"]){
        
        PreventSetViewController *preventSetViewController = [[[PreventSetViewController alloc]initWithNibName:@"PreventSetViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:preventSetViewController animated:YES];
        
    } else if ([label isEqualToString:@"update_pass"]){
        
        ChangePasswordViewController *changePasswordViewController = [[[ChangePasswordViewController alloc]initWithNibName:@"ChangePasswordViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:changePasswordViewController animated:YES];
        
    } else if ([label isEqualToString:@"stop_account"]){
        
        StopAccountViewController *stopAccountViewController = [[[StopAccountViewController alloc]init]autorelease];
        [self.navigationController pushViewController:stopAccountViewController animated:YES];
        
    } else if ([label isEqualToString:@"about"]){
        
        AboutViewController *aboutViewController = [[[AboutViewController alloc]init]autorelease];
        [self.navigationController pushViewController:aboutViewController animated:YES];
        
    } else if([label isEqualToString:@"black_list"]){
        BlockUsersViewController *buvc = [[[BlockUsersViewController alloc] initWithNibName:@"BlockUsersViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:buvc animated:YES];
        
    } else if ([label isEqualToString:@"feedback"]){
        SendSuggestViewController *sendSuggestViewController = [[[SendSuggestViewController alloc]init]autorelease];
        [self.navigationController pushViewController:sendSuggestViewController animated:YES];
    } else if ([label isEqualToString:@"up_person"]){
        DigoUsersViewController *duvc = [[[DigoUsersViewController alloc] initWithNibName:@"DigoUsersViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:duvc animated:YES];
    }
    
}

- (IBAction)resginAction
{
    NSLog(@"log out");
    
    NSMutableDictionary *dParams = [Utils queryParams];
    
    [[RKClient sharedClient] get:[@"/reg/getstatus.api"
                                  stringByAppendingQueryParameters:dParams] usingBlock:^(RKRequest *request){
        [request setOnDidLoadResponse:^(RKResponse *response){
            if (response.isOK &&response.isJSON) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                LoginViewController *lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                [self presentModalViewController:lvc animated:YES];
                [lvc release];
                
            }
        }
         
         ];
        
    }];
}

#pragma mark - ActionSheet Delegate Methods
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==kActionChooseImageTag) {
        UIImagePickerController* imagePickerController = [[[UIImagePickerController alloc] init]autorelease];
        
        if (buttonIndex == 0)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        else  if(buttonIndex==1)
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        else if(buttonIndex==2)
            return;
        
        imagePickerController.delegate=self;
        //        imagePickerController.allowsEditing = YES;
        [self presentModalViewController: imagePickerController
                                animated: YES];
    }
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark –  Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSData *data = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
    [Utils uploadImage:data type:@"userface" block:^(NSDictionary *res){
        
        if (res) {
            //            NSLog(@"hello doyou do: %@", res);
            //            NSMutableDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            //            user[@"info"][@"photo"] =
            self.avatarImageView.image = [UIImage imageWithData:data];
        }
    }];
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

@end
