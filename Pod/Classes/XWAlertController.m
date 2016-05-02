//
//  XWAlertController.m
//  XWAlertController
//
//  Created by suninrain086 on 4/5/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import "XWAlertController.h"
#import "XWAlertController+Private.h"

/*!
 * @brief AlertActionHandler type
 */
typedef void (^ XWAlertActionHandler)(XWAlertAction * _Nonnull action);

@interface XWAlertAction ()

@property(nonatomic, copy) id internalAction;
@property(nonatomic, copy) XWAlertActionHandler handler;
@property(nonatomic, weak) XWAlertController *weakController;

@end

@implementation XWAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XWAlertActionStyle)style handler:(void (^ __nullable)(XWAlertAction *action))handler {
    return [[self alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(XWAlertActionStyle)style handler:(void (^)(XWAlertAction * __nullable action))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
        
        if (isIOS8OrLater()) {
            __weak typeof(self) weakSelf = self;
            void (^ actionHandler)(UIAlertAction *action) = ^(UIAlertAction *action) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (_handler) {
                    _handler(strongSelf);
                }
                
                if (strongSelf.weakController) {
                    [strongSelf.weakController removeFromTargetController];
                }
            };
            self.internalAction = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyle)style handler:actionHandler];
        }
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[XWAlertAction class]]) {
        XWAlertAction *other = (XWAlertAction *)object;
        return (([self.title isEqual:other.title]) &&
                (self.style == other.style) &&
                (self.isEnabled == other.isEnabled) &&
                ([self.handler isEqual:other.handler]));
    }
    else if ([object isKindOfClass:[UIAlertAction class]]) {
        return (self.internalAction == object);
    }
    
    return NO;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] actionWithTitle:self.title style:self.style handler:self.handler];
}

@end

#pragma mark - XWAlertController

@implementation XWAlertController

@dynamic title;
@synthesize preferredAction = _preferredAction;
@synthesize preferredStyle = _preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(XWAlertControllerStyle)preferredStyle {
    return [[self alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(XWAlertControllerStyle)preferredStyle {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.title = title;
        _message = message;
        _preferredStyle = preferredStyle;
        
        _internalActions = [NSMutableArray<XWAlertAction *> new];
        
        if (preferredStyle == XWAlertControllerStyleCustomAlert) {
            self.internalAlert = [[XWAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        }
        else {
            if (isIOS8OrLater()) {
                self.internalAlert = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:(UIAlertControllerStyle)preferredStyle];
            }
            else {
                if (preferredStyle == XWAlertControllerStyleActionSheet) {
                    self.internalAlert = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                }
                else {
                    self.internalAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                    
                }
            }
        }
    }
    
    return self;
}

- (void)addAction:(XWAlertAction *)action {
    action.weakController = self;
    if (action) {
        [_internalActions addObject:action];
    }
    
    [[self asAlertController] addAction:action.internalAction];
    [[self asAlertView] addButtonWithTitle:action.title];
    [[self asCustomAlertView] addButtonWithTitle:action.title];
    [[self asActionSheet] addButtonWithTitle:action.title];
    
    if ([self asCustomAlertView]) {
        XWAlertView *customAlert = [self asCustomAlertView];
        if (action.style == XWAlertActionStyleDestructive) {
            [customAlert setTitleColor:[UIColor redColor] forButtonAtIndex:customAlert.numberOfButtons - 1];
        }
    }
}

- (NSArray<XWAlertAction *> *)actions {
    return _internalActions;
}

- (void)setPreferredAction:(XWAlertAction *)preferredAction {
    _preferredAction = preferredAction;
    
    if (isIOS9OrLater()) {
        [self.asAlertController setPreferredAction:preferredAction.internalAction];
    }
}

- (XWAlertAction *)preferredAction {
    return _preferredAction;
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    [[self asAlertController] addTextFieldWithConfigurationHandler:configurationHandler];
}

- (NSArray<UITextField *> *)textFields {
    return [[self asAlertController] textFields];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    [[self asAlertController] setTitle:title];
    [[self asAlertView] setTitle:title];
    [[self asActionSheet] setTitle:title];
    [[self asCustomAlertView] setTitle:title];
}

- (NSString *)title {
    return [super title];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    
    [[self asAlertController] setMessage:message];
    [[self asAlertView] setMessage:message];
    [[self asCustomAlertView] setMessage:message];
}

- (XWAlertControllerStyle)preferredStyle {
    return (XWAlertControllerStyle)_preferredStyle;
}

- (void)handlerActionAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.actions count]) {
        XWAlertAction *action = self.actions[index];
        if (action.handler) {
            action.handler(action);
        }
    }
    
    [self removeFromTargetController];
}

#pragma mark - UIAlertViewDelegate && XWAlertViewDelegate
- (void)alertView:(id)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self handlerActionAtIndex:buttonIndex];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self handlerActionAtIndex:buttonIndex];
}

@end
