//
//  ShareViewController.m
//  shareExtension
//
//  Created by Xhorse_iOS3 on 2021/11/9.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ShareActViewController.h"
#import "LHQHeader.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     
     Share 扩展最多可以支持十张图片、一部电影和一个网页 URL
     <key>NSExtensionAttributes</key>
         <dict>
             <key>NSExtensionActivationRule</key>
             <dict>
                 <key>NSExtensionActivationSupportsImageWithMaxCount</key>
                 <integer>10</integer>
                 <key>NSExtensionActivationSupportsMovieWithMaxCount</key>
                 <integer>1</integer>
                 <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
                 <integer>1</integer>
             </dict>
         </dict>
     
     */
    self.placeholder = @"请填写内容";
}

/// 内容是否可用
- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {

    NSLog(@"share 文本：%@", self.contentText);
    
    NSExtensionItem *imageItem = [self.extensionContext.inputItems firstObject];
    NSItemProvider *imageItemProvider = [[imageItem attachments] firstObject];

    if([imageItemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeFileURL]) {

        [imageItemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeFileURL options:nil completionHandler:^(__kindof id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
            
            NSLog(@"收到的文件 : %@",item);
            if ([(NSObject *)item isKindOfClass:[NSURL class]]) {
                NSURL *url = (NSURL *)item;
                
                NSData *data = [NSData dataWithContentsOfURL:url];
                [KSuiteUserDefault(kSuiteShareName) setObject:data forKey:kShareFileData];
                [KSuiteUserDefault(kSuiteShareName) synchronize];
                
                NSString *urlString = [url absoluteString];
                [KSuiteUserDefault(kSuiteShareName) setObject:urlString forKey:kShareFileKey];
                [KSuiteUserDefault(kSuiteShareName) synchronize];
                
                UIResponder* responder = self;
                while ((responder = [responder nextResponder]) != nil)
                {
                    NSLog(@"responder = %@", responder);
                    if([responder respondsToSelector:@selector(openURL:)] == YES)
                    {
                        [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:[NSString stringWithFormat:@"extensionShare://%@",[url absoluteString]]]];
                    }
                }
            }
            
            
            
        }];

    }
//
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    __weak typeof(self) weakSelf = self;
    
    SLComposeSheetConfigurationItem *item1 = [[SLComposeSheetConfigurationItem alloc] init];
    item1.title = @"发送给朋友";
    item1.value = @"请选择";
    item1.tapHandler = ^{
        NSLog(@"发送给朋友");
        [self validateContent];
    };
    
    SLComposeSheetConfigurationItem *item2 = [[SLComposeSheetConfigurationItem alloc] init];
    item2.title = @"发送到朋友圈";
    item2.value = @"点我";
    item2.tapHandler = ^{
        NSLog(@"发送到朋友圈");
        ShareActViewController *vc = [ShareActViewController new];
        [weakSelf pushConfigurationViewController:vc];
        
        vc.clickBlock = ^(NSString * _Nonnull text) {
            [weakSelf popConfigurationViewController];
            weakSelf.textView.text = text;
        };
    };
    
    return @[item1, item2];
}

@end
