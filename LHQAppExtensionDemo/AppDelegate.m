//
//  AppDelegate.m
//  LHQAppExtensionDemo
//
//  Created by Xhorse_iOS3 on 2021/11/9.
//

#import "AppDelegate.h"

@interface AppDelegate () <UIDocumentInteractionControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"openURL : %@", url);
    if ([url.description hasPrefix:@"extensionShare"]) {
        NSLog(@"分享跳转");
        
        NSString *fileUrlString = [[url.absoluteString componentsSeparatedByString:@"://"] lastObject];
        
        UIDocumentInteractionController *vc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:fileUrlString]];
        vc.delegate = self;
        [vc presentPreviewAnimated:YES];
    }
    return YES;
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self.window.rootViewController;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.window.rootViewController.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.window.rootViewController.view.frame;
}

@end
