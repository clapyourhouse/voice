//
//  VOHViewController.m
//  AVApp
//
//  Created by KitamuraShogo on 2015/02/15.
//  Copyright (c) 2015年 北村 彰悟. All rights reserved.
//

#import "VOHViewController.h"

@interface VOHViewController ()

@end

@implementation VOHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//説明画面。
- (void) loadView {
    [super loadView];
    // Create the walkthrough view controller
    walkthrough = LAWalkthroughViewController.new;
    walkthrough.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    walkthrough.backgroundImage = [UIImage imageNamed:@"explain004.png"];

    // Create pages of the walkthrough
    [walkthrough addPageWithBody:@"声でFacebook / Twitterへ投稿できるアプリです。"];
    [walkthrough addPageWithBody:@"トップに戻って話かけてみましょう。"];
    [walkthrough addPageWithBody:@"Picture / Facebook / Twitter...反応する言葉は全5種類。"];
    [walkthrough addPageWithBody:@"随時、バージョンアップしていきます!"];




    // Use the default next button
    walkthrough.nextButtonText = nil;
    // Add the walkthrough view to your view controller's view
    [self addChildViewController:walkthrough];
    [self.view addSubview:walkthrough.view];

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
        [walkthrough.view addSubview:_clbtn];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButton:(id)sender {
    [walkthrough.view removeFromSuperview];
}
@end
