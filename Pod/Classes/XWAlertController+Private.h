//
//  XWAlertController+Private.h
//  XWAlertController
//
//  Created by suninrain086 on 4/5/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import "XWAlertController.h"
#import "XWAlertView.h"

#ifndef isIOS8OrLater
    #define isIOS8OrLater() ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#endif // isIOS8OrLater

#ifndef isIOS9OrLater
    #define isIOS9OrLater() ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#endif // isIOS9OrLater

@interface XWAlertController () <UIAlertViewDelegate, UIActionSheetDelegate, XWAlertViewDelegate> {
    NSMutableArray<XWAlertAction *> __strong *_internalActions;
}

@property(nonatomic, strong) id internalAlert;

@end

@interface XWAlertController (Private)

/*!
 * @ brief internal alert containers for different platforms & styles
 */
- (UIAlertController *)asAlertController;
- (UIAlertView *)asAlertView;
- (UIActionSheet *)asActionSheet;
- (XWAlertView *)asCustomAlertView;

/*!
 * @brief add alert controller to target controller
 */
- (void)addToTargetController:(UIViewController *)controller;

/*!
 * @brief remove from target controller
 */
- (void)removeFromTargetController;

@end
