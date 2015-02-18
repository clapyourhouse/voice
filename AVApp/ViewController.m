//
//  ViewController.m
//  AVApp
//
//  Created by 北村 彰悟 on 2014/10/18.
//  Copyright (c) 2014年 北村 彰悟. All rights reserved.
//

//TODO:　誤動作のエラー処理
//TODO:　端末がSNSに未ログイン時、投稿表示がされない。
//TODO:　使い方
//TODO:　何度かストップを繰り返すと動かなくなるバグ。
//TODO:　UI/UX
//TODO:　デザイン
//TODO:　アプリアイコン



#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadView];
    //広告系の表示
    [self adLoadView];
    
    
    //create an instance of the radial menu and set ourselves as the delegate.
    self.radialMenu = [[ALRadialMenu alloc] init];
    self.radialMenu.delegate = self;
    
    self.socialMenu = [[ALRadialMenu alloc] init];
    self.socialMenu.delegate = self;
    
    
    self.fliteController = [[FliteController alloc]init];
    self.slt = [[Slt alloc]init];
//    [self.fliteController say:@"Hello!ALL OVER THE WORLD!" withVoice:self.slt];
    
    NSString *resourcePath = [[NSBundle mainBundle]resourcePath];
    self.amPath = [AcousticModel pathToModel:@"AcousticModelEnglish"];
    self.lmPath = [NSString stringWithFormat:@"%@/%@",resourcePath,@"OpenEars1.languagemodel"];
    self.dicPath = [NSString stringWithFormat:@"%@/%@", resourcePath, @"OpenEars1.dic"];
    
    self.pocketsphinxController = [[PocketsphinxController alloc]init];
    self.openEarsEvents = [[OpenEarsEventsObserver alloc]init];
    [self.openEarsEvents setDelegate:self];

    NSArray *words = @[
                       @"PICTURE",
                       @"POST",
                       @"FACEBOOK",
                       @"TWITTER",
                       @"HELP"];
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc]init];
    NSError *error = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:@"OpenEarsDynamicGrammar" forAcousticModelAtPath:self.amPath];
    if (error.code != noErr) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }else{
        NSDictionary *languageGeneratorResults = [error userInfo];
        self.lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        self.dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
        
    }
    
    
    [VOHelpViewController isMicAccessEnableWithIsShowAlert:YES
                                    completion:
     ^(BOOL isMicAccessEnable) {
         if (isMicAccessEnable == YES) {
             [self startListening];             
         }
         // アクセス許可がある場合はisMicAccessEnableがYES
     }];
     //音声認識スタート前に、ONになっていればいける？OFFからONになったタイミングでStart。ONの場合はスタート的な。
//    //音声認識スタート

    
//iOS7からの音声合成
//    AVSpeechSynthesizer *speechSynthe = [[AVSpeechSynthesizer alloc]init];
//    NSString *speaking = @"するとそこへ、大きな桃がBounce with me！！！Bounce with me！！！";
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speaking];
//    AVSpeechSynthesisVoice *JVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ja-JP"];
//    utterance.voice = JVoice;
//    utterance.rate =0.2f;
//    [speechSynthe speakUtterance:utterance];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)adLoadView{
    //バナーユニットID
    NSString *MY_BANNER_UNIT_ID = @"ca-app-pub-1971820013713991/8417251860";
    
    // 画面上部に標準サイズのビューを作成する
    // 利用可能な広告サイズの定数値は GADAdSize.h で説明されている
    CGPoint origin = CGPointMake(0.0, self.view.frame.size.height -GAD_SIZE_320x50.height);//書く場所注意
    bannerView_ = [[GADBannerView alloc] initWithAdSize:GADAdSizeFullWidthPortraitWithHeight(GAD_SIZE_320x50.height) origin:origin];
    
    // 広告ユニット ID を指定する
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    // ユーザーに広告を表示した場所に後で復元する UIViewController を
    // ランタイムに知らせてビュー階層に追加する
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // 一般的なリクエストを行って広告を読み込む
    [bannerView_ loadRequest:[GADRequest request]];
    
}
//発話を検出するたびに認証処理が走り、ReceiveHypothesisが呼ばれる。
- (void)startListening{
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.lmPath dictionaryAtPath:self.dicPath acousticModelAtPath:self.amPath languageModelIsJSGF:NO];
}
- (void)stopListening{
    [self.pocketsphinxController stopListening];
}
//台詞
//- (void)voiveSpeech:(NSString *)speee{
//    AVSpeechSynthesizer *speechSynthe = [[AVSpeechSynthesizer alloc]init];
//    NSString *speaking = speee;
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speaking];
//    AVSpeechSynthesisVoice *JVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ja-JP"];
//    utterance.voice = JVoice;
//    utterance.rate =0.2f;
//    [speechSynthe speakUtterance:utterance];
//}
- (void)pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID{
    if (![hypothesis isEqualToString:@"POST"] && ![hypothesis isEqualToString:@"TWITTER"] && ![hypothesis isEqualToString:@"FACEBOOK"] && ![hypothesis isEqualToString:@"PICTURE"] && ![hypothesis isEqualToString:@"HELP"]) {
        _recognitionLabel.text = @"";
        return;
    }
    _recognitionLabel.font = [UIFont fontWithName:@"Zapfino" size:30];
    _recognitionLabel.text = hypothesis;
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@",
          hypothesis, recognitionScore, utteranceID);
    if ([hypothesis isEqualToString:@"POST"]) {
//        [self voiveSpeech:hypothesis];
    }else if ([hypothesis isEqualToString:@"PICTURE"]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else if ([hypothesis isEqualToString:@"TWITTER"]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) { //利用可能チェック
            NSString *serviceType = SLServiceTypeTwitter;
            SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
            [composeCtl addImage:self.imgView.image];
            [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
                if (result == SLComposeViewControllerResultDone) {
                    //投稿成功時の処理
                }
            }];
            [self presentViewController:composeCtl animated:YES completion:nil];
            NSLog(@"%@",composeCtl);
        }else{
            _alertTitle = @"Twitter";
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
                [self alertMessageFaceTwit:_alertTitle];
            } else {
                [self alertTentative:_alertTitle];
            }
        }

    } else if ([hypothesis isEqualToString:@"FACEBOOK"]){
//        [self stopListening];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) { //利用可能チェック
            NSString *serviceType = SLServiceTypeFacebook;
            SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
            [composeCtl addImage:self.imgView.image];
            [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
                if (result == SLComposeViewControllerResultDone) {
                    //投稿成功時の処理
                }
            }];
            [self presentViewController:composeCtl animated:YES completion:nil];
        }else{
            _alertTitle = @"Facebook";
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
                [self alertMessageFaceTwit:_alertTitle];
            } else {
                [self alertTentative:_alertTitle];
            }
        }
    }else if ([hypothesis isEqualToString:@"HELP"]){
        VOHelpViewController *vohView = [[VOHelpViewController alloc]init];
        [self presentViewController:vohView animated:YES completion:nil];
    }

}

- (void)alertMessageFaceTwit:(NSString*)title{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"No %@ Account",title]
                                                        message:[NSString stringWithFormat:@"設定>%@ から%@へサインインしてください",title,title]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"はい", nil];
    [alertView show];
}
//iOS7以前
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // cancelボタンが押された時の処理
//            [self cancelButtonPushed];
            break;
//        case 1:
//            // otherボタンが押されたときの処理
//            [self otherButtonPushed];
//            break;
    }
}
//暫定的なAlert(iOS8のみ)
- (void)alertTentative:(NSString*)alertTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"No %@ Account",alertTitle]
                                                                             message:[NSString stringWithFormat:@"設定>%@ から%@へサインインしてください",alertTitle,alertTitle] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController :(UIImagePickerController *)picker
        didFinishPickingImage :(UIImage *)image editingInfo :(NSDictionary *)editingInfo {
    NSLog(@"selected");
    [self.imgView setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
    //FIXME: dipshit, change one of these variable names
    if (radialMenu == self.radialMenu) {
        return 9;
    } else if (radialMenu == self.socialMenu) {
        return 3;
    }
    
    return 0;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
    if (radialMenu == self.radialMenu) {
        return 360;
    } else if (radialMenu == self.socialMenu) {
        return 90;
    }
    
    return 0;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
    if (radialMenu == self.radialMenu) {
        return 200;
    } else if (radialMenu == self.socialMenu) {
        return 80;
    }
    
    return 0;
}


- (ALRadialButton *) radialMenu:(ALRadialMenu *)radialMenu buttonForIndex:(NSInteger)index {
    ALRadialButton *button = [[ALRadialButton alloc] init];
    if (radialMenu == self.radialMenu) {
        if (index == 1) {
            [button setImage:[UIImage imageNamed:@"dribbble"] forState:UIControlStateNormal];
        } else if (index == 2) {
            [button setImage:[UIImage imageNamed:@"youtube"] forState:UIControlStateNormal];
        } else if (index == 3) {
            [button setImage:[UIImage imageNamed:@"vimeo"] forState:UIControlStateNormal];
        } else if (index == 4) {
//            [button setImage:[UIImage imageNamed:@"pinterest"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];

        } else if (index == 5) {
            [button setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
        } else if (index == 6) {
//            [button setImage:[UIImage imageNamed:@"instagram500"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"facebook500"] forState:UIControlStateNormal];
        } else if (index == 7) {
//            [button setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];

        } else if (index == 8) {
            [button setImage:[UIImage imageNamed:@"googleplus-revised"] forState:UIControlStateNormal];
        } else if (index == 9) {
            [button setImage:[UIImage imageNamed:@"facebook500"] forState:UIControlStateNormal];
        }
        
    }
    if (button.imageView.image) {
        return button;
    }
    
    return nil;
}


- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
//    if (radialMenu == self.radialMenu) {
    if (index == 4) {
        VOHelpViewController *vohView = [[VOHelpViewController alloc]init];
        [self presentViewController:vohView animated:YES completion:nil];
    } else if (index == 5) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) { //利用可能チェック
            NSString *serviceType = SLServiceTypeTwitter;
            SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
            [composeCtl addImage:self.imgView.image];
            [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
                if (result == SLComposeViewControllerResultDone) {
                    //投稿成功時の処理
                }
            }];
            [self presentViewController:composeCtl animated:YES completion:nil];
        }else{
            _alertTitle = @"Twitter";
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
                [self alertMessageFaceTwit:_alertTitle];
            } else {
                [self alertTentative:_alertTitle];
            }
        }
    }else if (index == 6) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) { //利用可能チェック
            NSString *serviceType = SLServiceTypeFacebook;
            SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
            [composeCtl addImage:self.imgView.image];
            [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
                if (result == SLComposeViewControllerResultDone) {
                    //投稿成功時の処理
                }
            }];
            [self presentViewController:composeCtl animated:YES completion:nil];
        }else{
            _alertTitle = @"Facebook";
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
                [self alertMessageFaceTwit:_alertTitle];
            } else {
                [self alertTentative:_alertTitle];
            }
        }
    }else if (index == 7){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
        [self.radialMenu itemsWillDisapearIntoButton:self.mainBtn];

    
}
- (IBAction)buttonPress:(id)sender {
        [self.radialMenu buttonsWillAnimateFromButton:sender withFrame:self.mainBtn.frame inView:self.view];
}

////説明画面。
//- (void) loadView {
//    [super loadView];
//    // Create the walkthrough view controller
//    walkthrough = LAWalkthroughViewController.new;
//    walkthrough.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    walkthrough.backgroundImage = [UIImage imageNamed:@"explain001.png"];
//    walkthrough.backgroundImage = [UIImage imageNamed:@"explain002.png"];
//
//    // Create pages of the walkthrough
//    [walkthrough addPageWithBody:@"こうやって使うんやで。"];
//    [walkthrough addPageWithBody:@"ほな始めるで。"];
//
//    
//    // Use the default next button
//    walkthrough.nextButtonText = nil;
//    
//    // Add the walkthrough view to your view controller's view
//    [self addChildViewController:walkthrough];
//    [self.view addSubview:walkthrough.view];
//    
//    // ボタンを作成
//    UIButton *button =
//    [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    // ボタンの位置を設定
//    button.center = CGPointMake(100, 200);
//    
//    // キャプションを設定
//    [button setTitle:@"Start"
//            forState:UIControlStateNormal];
//    
//    // キャプションに合わせてサイズを設定
//    [button sizeToFit];
//    // ボタンがタップされたときに呼ばれるメソッドを設定
//    [button addTarget:self
//               action:@selector(button_Tapped:)
//     forControlEvents:UIControlEventTouchUpInside];
////    [walkthrough addPageWithView:button];
//
//    // ボタンをビューに追加
//    [walkthrough.view addSubview:button];
//    
//}
//- (void)button_Tapped:(id)sender
//{
//         UIAlertView *alertView = [[UIAlertView alloc]
//                                   initWithTitle:@"タップありがとう！"
//                                   message:@""
//                                   delegate:nil
//                                   cancelButtonTitle:@"OK"
//                                   otherButtonTitles:nil];
//         [alertView show];
//        [walkthrough.view removeFromSuperview];
//
//         // アクセス許可がある場合はisMicAccessEnableがYES
//}

@end
