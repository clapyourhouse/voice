//
//  VOHelpViewController.m
//  AVApp
//
//  Created by KitamuraShogo on 2015/02/02.
//  Copyright (c) 2015年 北村 彰悟. All rights reserved.
//

#import "VOHelpViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VOLicenseViewController.h"
#import "VOHViewController.h"
#import "appCCloud.h"
@interface VOHelpViewController ()

@end

@implementation VOHelpViewController

- (void)viewDidLoad {
    //メディアキー指定
    [appCCloud setupAppCWithMediaKey:@"71261d256ebdc9b01bbab1ce1efc1080cfd75a52" option:APPC_CLOUD_AD];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    NSLog( @"%ld",(long)touch.view.tag );
    switch (touch.view.tag) {
        case 0:
            NSLog(@"HELPやがな！");
            voh = [[VOHViewController alloc]init];
            [self presentViewController:voh animated:YES completion:nil];
            // 1のタグがタップされた場合の処理を記述
            break;
        case 1:
            //AppC広告表示
            [self appAdEventCreat];
            break;
        case 2:
            vol = [[VOLicenseViewController alloc]init];
            [self presentViewController:vol
                               animated:YES completion:nil];
            // 3のタグがタップされた場合の処理を記述
            break;
        default:
            break;
    }
    
}
- (void)appAdEventCreat{
    // スプラッシュ設定(YES:表示 NO:非表示)
    [appCCloud setSplashLogo:NO];
    // リストビュー表示
    [appCCloud openWebView];
    }
+ (void)isMicAccessEnableWithIsShowAlert:(BOOL)_isShowAlert
                              completion:(IsMicAccessEnableWithIsShowAlertBlock)_completion
{
    //    // メソッドの存在チェック。存在しない場合はiOS7未満なのでYESを返す なぜか動作しなかった
    //    if (![AVCaptureDevice instancesRespondToSelector:@selector(authorizationStatusForMediaType:)]) {
    //        return YES;
    //    }
    
    IsMicAccessEnableWithIsShowAlertBlock completion = [_completion copy];
    
    // iOS7.0未満
    NSString *iOsVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"iOsVersion = %@", iOsVersion);
    if ( [iOsVersion compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending ) {
        completion(YES);
        return;
    }
    
    // このアプリマイクへの認証状態を取得する
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized: // マイクへのアクセスが許可されている
            completion(YES);
            break;
        case AVAuthorizationStatusNotDetermined: // マイクへのアクセスを許可するか選択されていない
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio
                                     completionHandler:
             ^(BOOL granted) {
                 // メインスレッド
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     if(granted){
                         //許可完了
                         completion(YES);
                     } else {
                         //許可されなかった
                         completion(NO);
                         
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"エラー"
                                                   message:@"マイクへのアクセスが許可されていません。\n設定 > プライバシー > マイクで許可してください。"
                                                   delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
                         [alertView show];
                     }
                 });
             }];
            
        }
            break;
        case AVAuthorizationStatusRestricted: // 設定 > 一般 > 機能制限で利用が制限されている
        {
            if (_isShowAlert) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"エラー"
                                          message:@"マイクへのアクセスが許可されていません。\n設定 > 一般 > 機能制限で許可してください。"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            completion(NO);
        }
            break;
        case AVAuthorizationStatusDenied: // 設定 > プライバシー > で利用が制限されている
        {
            if (_isShowAlert) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"エラー"
                                          message:@"マイクへのアクセスが許可されていません。\n設定 > プライバシー > マイクで許可してください。"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            completion(NO);
        }
            break;
            
        default:
            break;
    }
}
@end
