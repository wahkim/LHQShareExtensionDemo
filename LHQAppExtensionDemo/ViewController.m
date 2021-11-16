//
//  ViewController.m
//  LHQAppExtensionDemo
//
//  Created by Xhorse_iOS3 on 2021/11/9.
//

#import "ViewController.h"
#import "LHQHeader.h"

@interface ViewController () <UIDocumentInteractionControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton new];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitle:@"查看新分享的文件" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showFile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = self.view.center;
    button.bounds = CGRectMake(0, 0, 180, 35);
}

- (void)showFile:(UIButton *)sender {
    
    
    NSString *fileUrlString = [KSuiteUserDefault(kSuiteShareName) objectForKey:kShareFileKey];
    NSLog(@"新接收的文件：%@", fileUrlString);

    NSString *domainPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [fileUrlString componentsSeparatedByString:@"/"].lastObject;
    NSString *filePath = [domainPath stringByAppendingPathComponent:fileName];

//    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileUrlString]];
    NSData *fileData = [KSuiteUserDefault(kSuiteShareName) objectForKey:kShareFileData];
    BOOL result = [fileData writeToFile:filePath atomically:YES];

    if (result) {
        NSLog(@"保存本地成功");
    } else {
        NSLog(@"保存本地失败");
    }


    UIDocumentInteractionController *vc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:fileUrlString]];
    vc.delegate = self;
    [vc presentPreviewAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}


@end
