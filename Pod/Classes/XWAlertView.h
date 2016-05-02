//
//  XWAlertView.h
//  XWAlertController
//
//  Created by suninrain086 on 4/22/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XWAlertViewStyle) {
    XWAlertViewStyleDefault = 0,
    XWAlertViewStyleSecureTextInput,        // not implemented
    XWAlertViewStylePlainTextInput,         // not implemented
    XWAlertViewStyleLoginAndPasswordInput   // not implemented
};

@protocol XWAlertViewDelegate;

@interface XWAlertView : UIView

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id<XWAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;

- (id)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (nullable instancetype) initWithCoder:(nonnull NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@property(nullable,nonatomic,weak) id<XWAlertViewDelegate> delegate;
@property(nonatomic,copy) NSString *title;
@property(nullable,nonatomic,copy) NSString *message;   // secondary explanation text


// adds a button with the title. returns the index (0 based) of where it was added. buttons are displayed in the order added except for the
// cancel button which will be positioned based on HI requirements. buttons cannot be customized.
- (NSInteger)addButtonWithTitle:(nullable NSString *)title;    // returns index of button. 0 based.
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
@property(nonatomic,readonly) NSInteger numberOfButtons;
@property(nonatomic) NSInteger cancelButtonIndex;      // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1

@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used
@property(nonatomic,readonly,getter=isVisible) BOOL visible;

// shows popup alert animated.
- (void)show;

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

// Alert view style - defaults to XWAlertViewStyleDefault
@property(nonatomic,assign) XWAlertViewStyle alertViewStyle;

// Retrieve a text field at an index
// The field at index 0 will be the first text field (the single field or the login field), the field at index 1 will be the password field. */
- (nullable UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

// set specify color for button at |buttonIndex|
- (void)setTitleColor:(UIColor *)color forButtonAtIndex:(NSInteger)buttonIndex;

@end

@protocol XWAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(XWAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(XWAlertView *)alertView;

- (void)willPresentAlertView:(XWAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(XWAlertView *)alertView;  // after animation

- (void)alertView:(XWAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(XWAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(XWAlertView *)alertView; // not implemented


@end

NS_ASSUME_NONNULL_END
