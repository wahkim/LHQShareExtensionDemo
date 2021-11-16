//
//  ShareActViewController.h
//  LHQAppExtensionDemo
//
//  Created by Xhorse_iOS3 on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareActViewController : UITableViewController

@property (nonatomic, copy) void(^clickBlock)(NSString *text);

@end

NS_ASSUME_NONNULL_END
