//
//  VOHelpViewController.h
//  AVApp
//
//  Created by KitamuraShogo on 2015/02/02.
//  Copyright (c) 2015年 北村 彰悟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VOLicenseViewController;
@class VOHViewController;

@interface VOHelpViewController : UIViewController{
    VOLicenseViewController *vol;
    VOHViewController *voh;
}
- (IBAction)backBtn:(id)sender;

typedef void (^IsMicAccessEnableWithIsShowAlertBlock)(BOOL isMicAccessEnable);

//マイクONOFFの制御
+ (void)isMicAccessEnableWithIsShowAlert:(BOOL)_isShowAlert
                              completion:(IsMicAccessEnableWithIsShowAlertBlock)_completion;

@end
