//
//  VOHViewController.h
//  AVApp
//
//  Created by KitamuraShogo on 2015/02/15.
//  Copyright (c) 2015年 北村 彰悟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LAWalkthroughViewController.h"


@interface VOHViewController : UIViewController{
    LAWalkthroughViewController *walkthrough;
}
@property (weak, nonatomic) IBOutlet UIButton *clbtn;
- (IBAction)closeButton:(id)sender;

@end
