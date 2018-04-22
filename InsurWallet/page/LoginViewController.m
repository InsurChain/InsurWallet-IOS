//
//  LoginViewController.m
//  InsurWallet
//
//  Created by 宗宇辰 on 2018/2/5.
//  Copyright © 2018年 sinosoft. All rights reserved.
//

#import "LoginViewController.h"
#define kCountDownTime 59

@interface LoginViewController (){
    NSUInteger      _countDownTime;
    NSTimer         *_timer;
}
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *Pwd;
@property (weak, nonatomic) IBOutlet UIButton *TestGetCode;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *imgId;
@property (weak, nonatomic) IBOutlet UITextField *Image;
@property (weak, nonatomic) IBOutlet UIButton *ImageCode;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setUpNav:self.navigationController.navigationBar
                                   navColor:[UIColor clearColor]
                                   navImage:@""];
    [self.navigationController setNavigationBarHidden:NO];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {  
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;  
    } 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(returnWithCliked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"关闭"] style:UIBarButtonItemStylePlain target:self action:@selector(returnWithCliked)];
    
    [_Phone setValue:ARGBCOLOR(138, 141, 161, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_Pwd setValue:ARGBCOLOR(138, 141, 161, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_Image setValue:ARGBCOLOR(138, 141, 161, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self imgCodeUrlStr];
}
- (void)returnWithCliked{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginBtnClicked:(UIButton *)sender {
    NSString *SmsUrlStr = @"api/v1/login/sms";
    NSString *LoginUrlStr = @"api/v1/user/login";
    NSString *StartUrlStr = @"api/v1/app/activate";
    
    NSMutableDictionary *SmsDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *LoginDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *StartDic = [[NSMutableDictionary alloc]init];
    switch (sender.tag) {
        case 100:
        {
            if (_Phone.text.length != 0) {
                LoginDic [@"telephone"] = _Phone.text;
                LoginDic [@"smsCode"] = _Pwd.text;
                LoginDic [@"imgCode"] = _Image.text;
                __weak typeof(self) weakSelf = self;
                [[XBNetCenter share] sendRequestWithMethods:YES withURL:LoginUrlStr withParams:LoginDic withImagePath:nil withCompletion:^(id responseData, NSError *error, NSInteger Code) {
                    NSLog(@"%ld=====%@",(long)Code,responseData);
                    NSString *state = [NSString stringWithFormat:@"%@",responseData[@"state"]];
                    if ([state isEqualToString:@"0"]) {
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:responseData[@"data"][@"token"] forKey:@"token"];
                        [userDefaults synchronize];
                        
                        NSNotification *notification =[NSNotification notificationWithName:@"Login" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        [weakSelf returnWithCliked];
                    }else{
                        [CustomTools showView:self.view Str:responseData[@"msg"]];
                        [self imgCodeUrlStr];
                    }
                    StartDic [@"Authentication"] = responseData[@"token"];
                    [[XBNetCenter share] sendRequestWithMethods:YES withURL:StartUrlStr withParams:StartDic withImagePath:nil withCompletion:^(id responseData, NSError *error, NSInteger Code) {
                    }];
                }];
            }else{
                [CustomTools showView:self.view Str:@"请输入正确的手机号"];
            }
        }
            break;
        case 110:
            break;
        case 120:
        {
            if (_Phone.text.length != 0) {
                if (_Image.text.length != 0) {
                    [self startCountDown];
                    SmsDic [@"telephone"] = _Phone.text;
                    SmsDic [@"imgCode"] = _Image.text;
                    SmsDic [@"imgId"] = _imgId;
                    [[XBNetCenter share] sendRequestWithMethods:YES withURL:SmsUrlStr withParams:SmsDic withImagePath:nil withCompletion:^(id responseData, NSError *error, NSInteger Code){
                        NSLog(@"%ld=====%@",(long)Code,responseData);
                        NSString *state = [NSString stringWithFormat:@"%@",responseData[@"state"]];
                        if (![state isEqualToString:@"0"]) {
                            [CustomTools showView:self.view Str:responseData[@"msg"]];
                            [self imgCodeUrlStr];
                        }
                    }];
                }else{
                    [CustomTools showView:self.view Str:@"请输入图片验证码"];
                }
                
            }else{
                [CustomTools showView:self.view Str:@"请输入正确的手机号"];
            }
        }
            break;
        case 130:
        {
            [self imgCodeUrlStr];
        }
            break;
        default:
            break;
    }
}
-(void)startCountDown
{
    _countDownTime = kCountDownTime;
    [self.TestGetCode setAdjustsImageWhenHighlighted:NO];
    [self.TestGetCode setTitle:[NSString stringWithFormat:@"%lu秒重新发送",(unsigned long)_countDownTime] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    self.TestGetCode.enabled = NO;
}
-(void)changeTime
{
    _countDownTime--;
    _TestGetCode.titleLabel.text = [NSString stringWithFormat:@"%lu秒重新发送",(unsigned long)_countDownTime];
    [self.TestGetCode setTitle:[NSString stringWithFormat:@"%lu秒重新发送",(unsigned long)_countDownTime] forState:UIControlStateNormal];
    if (_countDownTime <= 0)
    {
        [self.TestGetCode setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer invalidate];
        self.TestGetCode.enabled = YES;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)imgCodeUrlStr{
    NSString *imgCodeUrlStr = @"api/v1/login/imgCode";
    [[XBNetCenter share] sendRequestWithMethods:YES withURL:imgCodeUrlStr withParams:nil withImagePath:nil withCompletion:^(id responseData, NSError *error, NSInteger Code) {
        NSLog(@"====%@",responseData);
        [_ImageCode sd_setBackgroundImageWithURL:[NSURL URLWithString:responseData[@"data"][@"img"]] forState:UIControlStateNormal];
        _imgId = responseData[@"data"][@"imgId"];
    }];
}
@end
