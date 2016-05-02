//
//  UIViewController+XWAlertController.m
//  XWAlertController
//
//  Created by suninrain086 on 4/5/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import "UIViewController+XWAlertController.h"
#import "XWAlertController+Private.h"

#import <JRSwizzle/JRSwizzle.h>

@implementation UIViewController (XWAlertController)

+ (void)load {
    NSError *error;
    [self jr_swizzleMethod:@selector(presentViewController:animated:completion:) withMethod:@selector(xw_presentViewController:animated:completion:) error:&error];
    if (error) {
        NSLog(@"swizzle viewDidLoad failed. error = %@", error.localizedDescription);
    }
}

- (void)xw_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    if ([viewControllerToPresent isKindOfClass:[XWAlertController class]]) {
        XWAlertController *controller = (XWAlertController *)viewControllerToPresent;
        if (controller) {
            [controller addToTargetController:self];
        }
        
        if ([controller asAlertController]) {
            [self xw_presentViewController:[controller asAlertController] animated:flag completion:completion];
        }
        else if ([controller asAlertView]) {
            [[controller asAlertView] show];
            if (completion) {
                completion();
            }
        }
        else if ([controller asActionSheet]) {
            [[controller asActionSheet] showInView:self.view];
            if (completion) {
                completion();
            }
        }
        else if ([controller asCustomAlertView]) {
            [[controller asCustomAlertView] show];
            if (completion) {
                completion();
            }
        }
    }
    else {
        [self xw_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end
