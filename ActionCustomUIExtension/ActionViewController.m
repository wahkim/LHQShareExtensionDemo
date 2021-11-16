//
//  ActionViewController.m
//  ActionCustomUIExtension
//
//  Created by Xhorse_iOS3 on 2021/11/11.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 全屏显示
     <key>NSExtensionActionWantsFullScreenPresentation</key>
     <true/>
     */
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:UTTypeImage.identifier]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:UTTypeImage.identifier options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [imageView setImage:image];
                        }];
                    }
                }];
                
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.

//    UIResponder* responder = self;
//    while ((responder = [responder nextResponder]) != nil)
//    {
//        NSLog(@"responder = %@", responder);
//        if([responder respondsToSelector:@selector(openURL:)] == YES)
//        {
//            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"extensionShare://"]];
//        }
//    }
    
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
