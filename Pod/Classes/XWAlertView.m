//
//  XWAlertView.m
//  XWAlertController
//
//  Created by suninrain086 on 4/22/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import "XWAlertView.h"

#import <Masonry/Masonry.h>

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#endif // SCREEN_WIDTH

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif // SCREEN_HEIGHT

static CGFloat const kDefaultAlertHeight = 40.0f;
static CGFloat const kDefautButtonHeight = 50.0f;
static CGFloat const kTitleFontSize = 16.0f;
static CGFloat const kLabelLineSpacing = 5.0f;
static CGFloat const kMessageTitleSpacing = 22.0f;
static CGFloat const kCornerRadius = 2.0f;

static CGFloat const kTopMargin = 16.0f;
static CGFloat const kLeftMargin = 30.0f;

@interface XWAlertView ()

@property(nonatomic, copy) NSString *cancelButtonTitle;
@property(nonatomic, strong) NSMutableArray<NSString *> *buttonTitlesArray;
@property(nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;

@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *messageLabel;
@property(nonatomic, strong) UIView *hSeparator;
@property(nonatomic, strong) UIView *vSeparator;
@property(nonatomic, strong) NSMutableArray<UIButton *> *buttonsArray;
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *buttonsTitleColorDict;

@end

@implementation XWAlertView

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                     delegate:(nullable id<XWAlertViewDelegate>)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    if (self = [self initWithFrame:CGRectZero]) {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        
        if (otherButtonTitles) {
            _firstOtherButtonIndex = 0;
            [self.buttonTitlesArray addObject:otherButtonTitles];
            
            va_list args;
            NSString *title;
            va_start(args, otherButtonTitles);
            while ((title = va_arg(args, NSString *)) != nil) {
                [self.buttonTitlesArray addObject:title];
            }
        }
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cancelButtonIndex = -1;
        _firstOtherButtonIndex = -1;
        _visible = NO;
    }
    
    return self;
}

- (nullable instancetype) initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // to be implemented
    }
    
    return self;
}

- (void)dealloc {
    if (self.window) {
        self.window = nil;
    }
}

- (NSMutableArray *)buttonTitlesArray {
    if (!_buttonTitlesArray) {
        _buttonTitlesArray = [NSMutableArray new];
    }
    
    return _buttonTitlesArray;
}

- (NSInteger)addButtonWithTitle:(nullable NSString *)title {
    NSAssert(title != nil, @"title can not be nil!");
    
    NSInteger index = [self.buttonTitlesArray count];
    [self.buttonTitlesArray addObject:title];
    
    return index;
}

- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == self.cancelButtonIndex) {
        return self.cancelButtonTitle;
    }
    else if (buttonIndex >= 0 && buttonIndex < [self.buttonTitlesArray count]) {
        return self.buttonTitlesArray[buttonIndex];
    }
    else {
        return nil;
    }
}

- (NSInteger)numberOfButtons {
    return [self.buttonTitlesArray count];
}

- (void)show {
    [self showAnimated:YES];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [self dismissWithButtonIndex:buttonIndex animated:YES notifiyDelegate:NO];
}

- (nullable UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex {
    NSAssert(NO, @"to be implemented!");
    return nil;
}

- (void)setTitleColor:(UIColor *)color forButtonAtIndex:(NSInteger)buttonIndex {
    if (!color || buttonIndex < -1 || buttonIndex >= self.numberOfButtons) {
        return;
    }
    
    if (!self.buttonsTitleColorDict) {
        self.buttonsTitleColorDict = [NSMutableDictionary new];
    }
    self.buttonsTitleColorDict[@(buttonIndex)] = color;
}

#pragma mark - Private Methods

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelAlert;
        _window.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _window.hidden = NO;
    }
    
    return _window;
}

- (void)setupUI {
    [self loadSubviews];
    [self displaySubviews];
}

- (void)loadSubviews {
    if (self.title) {
        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
            _titleLabel.textColor = [UIColor blackColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.numberOfLines = 0;
            
            [self setText:self.title forLabel:_titleLabel];
        }
        
        [self addSubview:_titleLabel];
    }
    
    if (self.message) {
        if (!_messageLabel) {
            _messageLabel = [UILabel new];
            _messageLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            _messageLabel.textColor = [UIColor blackColor];
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.numberOfLines = 0;
            
            [self setText:self.message forLabel:_messageLabel];
        }
        
        [self addSubview:_messageLabel];
    }
    
    NSInteger buttonCount = self.numberOfButtons;
    if (self.cancelButtonTitle) {
        buttonCount += 1;
    }
    if (buttonCount > 0) {
        if (!self.buttonsArray) {
            self.buttonsArray = [NSMutableArray new];
        }
        [self.buttonsArray removeAllObjects];
    }
    for (NSInteger i = 0; i < buttonCount; i++) {
        
        UIButton *button = [UIButton new];
        button.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor colorWithRed:11.0f/255.0f green:95.0f/255.0f blue:254.0f/255.0f alpha:1.0f]
                     forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i < self.numberOfButtons) {
            [button setTitle:self.buttonTitlesArray[i] forState:UIControlStateNormal];
            button.tag = i;
        }
        else {
            [button setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
            button.tag = self.cancelButtonIndex;
        }
        if (self.buttonsTitleColorDict[@(button.tag)]) {
            [button setTitleColor:self.buttonsTitleColorDict[@(button.tag)] forState:UIControlStateNormal];
        }
        
        [self.buttonsArray addObject:button];
        [self addSubview:button];
    }
    
    if (!_hSeparator) {
        _hSeparator = [UIView new];
        _hSeparator.hidden = YES;
        _hSeparator.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
        
        [self addSubview:_hSeparator];
    }
    
    if (!_vSeparator) {
        _vSeparator = [UIView new];
        _vSeparator.hidden = YES;
        _vSeparator.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
        
        [self addSubview:_vSeparator];
    }
}

- (void)displaySubviews {
    CGFloat x = SCREEN_WIDTH >= 375.0f ? 40.0f : 30.0f;
    CGFloat y = 0;
    CGFloat w = SCREEN_WIDTH - 2 * x;
    CGFloat h = kDefaultAlertHeight;
    
    self.layer.cornerRadius = kCornerRadius;
    
    if (self.titleLabel) {
        CGFloat textHeight = [self caculateTextHeightForLabel:self.titleLabel width:(w - 2 * kLeftMargin)];
        h += textHeight;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kLeftMargin));
            make.top.equalTo(@(kTopMargin));
            make.right.equalTo(@(-kLeftMargin));
            make.height.equalTo(@(textHeight));
        }];
    }
    
    if (self.messageLabel) {
        BOOL hasTitleLabel = self.titleLabel !=  nil;
        CGFloat textHeight = [self caculateTextHeightForLabel:self.messageLabel width:(w - 2 * kLeftMargin)];
        h += textHeight;
        if (hasTitleLabel) {
            h += kMessageTitleSpacing;
        }
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kLeftMargin));
            make.right.equalTo(@(-kLeftMargin));
            make.height.equalTo(@(textHeight));
            
            if (hasTitleLabel) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(kMessageTitleSpacing);
            }
            else {
                make.top.equalTo(@(kTopMargin));
            }
        }];
    }
    
    NSInteger buttonCount = self.numberOfButtons;
    if (self.cancelButtonTitle) {
        buttonCount += 1;
    }
    
    if (buttonCount > 0) {
        self.hSeparator.hidden = NO;
        self.vSeparator.hidden = buttonCount != 2; // 2 个button时一行显示分割线
        
        [self.hSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(@(-kDefautButtonHeight));
        }];
        [self.vSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kDefautButtonHeight));
            make.bottom.equalTo(@0);
            make.width.equalTo(@0.5);
            make.centerX.equalTo(@0);
        }];
        
        if (buttonCount <= 2) {
            h += kDefautButtonHeight;
        }
        else {
            h += buttonCount * kDefautButtonHeight;
        }
        
        if (buttonCount == 2) {
            for (NSInteger index = 0; index < buttonCount; index++) {
                UIButton *button = self.buttonsArray[index];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@(index * (w / buttonCount)));
                    make.width.equalTo(@(w / buttonCount));
                    make.height.equalTo(@(kDefautButtonHeight));
                    make.bottom.equalTo(@0);
                }];
            }
        }
        else {
            for (NSInteger index = 0; index < buttonCount; index++) {
                UIButton *button = self.buttonsArray[index];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@0);
                    make.width.equalTo(@(w));
                    make.height.equalTo(@(kDefautButtonHeight));
                    make.bottom.equalTo(@((buttonCount - 1 - index) * kDefautButtonHeight));
                }];
            }
        }
    }
    
    y = ceilf((SCREEN_HEIGHT - h) / 2);
    CGRect frame = CGRectMake(x, y, w, h);
    self.frame = frame;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        _paragraphStyle = [NSMutableParagraphStyle new];
        _paragraphStyle.alignment = NSTextAlignmentCenter;
        _paragraphStyle.lineSpacing = kLabelLineSpacing;
        _paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return _paragraphStyle;
}

- (void)setText:(NSString *)title forLabel:(UILabel *)label {
    if (title == nil || label == nil) {
        return;
    }
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:title
                                                                           attributes:@{NSFontAttributeName: label.font}];
    [as addAttribute:NSParagraphStyleAttributeName value:[self paragraphStyle] range:NSMakeRange(0, as.length)];
    
    label.attributedText = as;
}

- (CGFloat)caculateTextHeightForLabel:(UILabel *)label width:(CGFloat)width {
    if (label == nil || label.attributedText == nil) {
        return 0;
    }
    
    CGSize size = CGSizeZero;
    CGSize labelsize = [label.attributedText boundingRectWithSize:CGSizeMake(width, INFINITY)
                                                          options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size = CGSizeMake(ceilf(labelsize.width), ceilf(labelsize.height));
    
    return size.height;
}

- (void)buttonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:button.tag];
    }
    
    [self dismissWithButtonIndex:button.tag animated:YES notifiyDelegate:YES];
}

- (void)showAnimated:(BOOL)animated {
    [self setupUI];
    
    [self.window addSubview:self];
    
    if (animated) {
        self.alpha = 0;
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1.0;
        }];
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = @[@0.01f, @1.1f, @1.0f];
        bounceAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
        bounceAnimation.duration = 0.3;
        [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
    }
}

- (void)dismissWithButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated notifiyDelegate:(BOOL)notifiyDelegate {
    __weak typeof(self) weakSelf = self;
    void (^ willDismiss)() = ^() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (notifiyDelegate) {
            if ([strongSelf.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
                [strongSelf.delegate alertView:strongSelf willDismissWithButtonIndex:buttonIndex];
            }
        }
    };
    
    void (^ didDismiss)() = ^() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (notifiyDelegate) {
            if ([strongSelf.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
                [strongSelf.delegate alertView:strongSelf didDismissWithButtonIndex:buttonIndex];
            }
        }
        
        strongSelf.window.hidden = YES;
        [strongSelf removeFromSuperview];
    };
    
    willDismiss();
    
    if (animated) {
        self.alpha = 1.0;
        self.window.alpha = 1.0;
        
        self.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.1;
            self.window.alpha = 0.1;
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            didDismiss();
        }];
    }
    else {
        didDismiss();
    }
}

@end
