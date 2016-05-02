//
//  XWAlertController+Private.m
//  XWAlertController
//
//  Created by suninrain086 on 4/5/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import "XWAlertController+Private.h"

@implementation XWAlertController (Private)

#pragma mark - Private Methods
- (UIAlertController *)asAlertController {
    if (isIOS8OrLater() && self.preferredStyle != XWAlertControllerStyleCustomAlert) {
        return (UIAlertController *)self.internalAlert;
    }
    
    return nil;
}

- (UIAlertView *)asAlertView {
    if ([self asCustomAlertView]) { // if style is XWAlertControllerStyleCustomAlert, force return nil
        return nil;
    }
    if (!isIOS8OrLater() && self.preferredStyle == XWAlertControllerStyleAlert) {
        return (UIAlertView *)self.internalAlert;
    }
    
    return nil;
}

- (UIActionSheet *)asActionSheet {
    if (!isIOS8OrLater() && self.preferredStyle == XWAlertControllerStyleActionSheet) {
        return (UIActionSheet *)self.internalAlert;
    }
    
    return nil;
}

- (XWAlertView *)asCustomAlertView {
    if (self.preferredStyle == XWAlertControllerStyleCustomAlert) {
        return (XWAlertView *)self.internalAlert;
    }
    
    return nil;
}

- (void)addToTargetController:(UIViewController *)controller {
    [self willMoveToParentViewController:controller];
    [controller.view addSubview:self.view];
    [controller addChildViewController:self];
    [self didMoveToParentViewController:controller];
}

- (void)removeFromTargetController {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
