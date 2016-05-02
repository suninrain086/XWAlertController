//
//  XWAlertController.h
//  XWAlertController
//
//  Created by suninrain086 on 4/5/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import <UIKit/UIViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XWAlertActionStyle) {
    XWAlertActionStyleDefault = 0,
    XWAlertActionStyleCancel,
    XWAlertActionStyleDestructive
} NS_ENUM_AVAILABLE_IOS(7_0);

typedef NS_ENUM(NSInteger, XWAlertControllerStyle) {
    XWAlertControllerStyleActionSheet = 0,
    XWAlertControllerStyleAlert,
    XWAlertControllerStyleCustomAlert
} NS_ENUM_AVAILABLE_IOS(7_0);

NS_CLASS_AVAILABLE_IOS(7_0) @interface XWAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XWAlertActionStyle)style handler:(void (^ __nullable)(XWAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) XWAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

/*!
 * @brief XWAlertController for all platforms such as iOS7, iOS8 or higher
 * 
 * @brief use it like iOS8 UIAlertController
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface XWAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(XWAlertControllerStyle)preferredStyle;

- (void)addAction:(XWAlertAction *)action;
@property (nonatomic, readonly) NSArray<XWAlertAction *> *actions;

@property (nonatomic, strong, nullable) XWAlertAction *preferredAction NS_AVAILABLE_IOS(7_0);

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) XWAlertControllerStyle preferredStyle;

@end

NS_ASSUME_NONNULL_END
