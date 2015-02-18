//
//  AppDelegate.m
//  AVApp
//
//  Created by 北村 彰悟 on 2014/10/18.
//  Copyright (c) 2014年 北村 彰悟. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate (){
    MPMoviePlayerViewController *MPMPlayerController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSURL *filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"202" ofType:@"MP4"]];
//    
//    MPMPlayerController = [[MPMoviePlayerViewController alloc]initWithContentURL:filePath ];
//    MPMPlayerController.moviePlayer.backgroundView.backgroundColor = [UIColor whiteColor];
//    MPMPlayerController.moviePlayer.controlStyle = MPMovieControlStyleNone;
//    MPMPlayerController.view.frame = self.window.frame;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(splashMoviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:MPMPlayerController
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification
//                                                  object:MPMPlayerController.moviePlayer];
//    
//    MPMPlayerController.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
//    [MPMPlayerController.moviePlayer setFullscreen:YES animated:NO];
//    
//    [self.window.rootViewController.view addSubview:MPMPlayerController.view];
//    [self.window makeKeyAndVisible];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[ViewController alloc] init];
//    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

//詳細な再生時間。
- (void)splashMoviePlayBackDidFinish:(NSNotification *)notification
{
    UIView *fadeView = [[UIView alloc]initWithFrame:self.window.frame];
    fadeView.backgroundColor = [UIColor blackColor];
    fadeView.alpha = 0.0f;
    [self.window.rootViewController.view addSubview:fadeView];
    
    // Fadeout & remove
    [UIView animateWithDuration:0.5f
                     animations:^{
                         fadeView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [fadeView removeFromSuperview];
                         
                         [[NSNotificationCenter defaultCenter] removeObserver:self];
                         [MPMPlayerController.view removeFromSuperview];
                     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
