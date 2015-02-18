//
//  ViewController.h
//  AVApp
//
//  Created by 北村 彰悟 on 2014/10/18.
//  Copyright (c) 2014年 北村 彰悟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/AcousticModel.h>
#import <Social/Social.h>
#import "ALRadialMenu.h"
#import "GADBannerView.h"
#import "VOHelpViewController.h"


@interface ViewController : UIViewController<OpenEarsEventsObserverDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,ALRadialMenuDelegate,GADBannerViewDelegate>{
    GADBannerView *bannerView_;
    NSString *_alertTitle;

}
@property (strong, nonatomic)FliteController *fliteController;
@property (strong, nonatomic)Slt *slt;

@property (strong, nonatomic)NSString *amPath;
@property (strong, nonatomic)NSString *lmPath;
@property (strong, nonatomic)NSString *dicPath;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic)PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic)OpenEarsEventsObserver *openEarsEvents;
@property (weak, nonatomic) IBOutlet UILabel *recognitionLabel;
@property (strong, nonatomic) IBOutlet UIButton *mainBtn;

@property (strong, nonatomic) ALRadialMenu *radialMenu;
@property (strong, nonatomic) ALRadialMenu *socialMenu;
- (IBAction)buttonPress:(id)sender;

typedef void (^IsMicAccessEnableWithIsShowAlertBlock)(BOOL isMicAccessEnable);



@end

