//
//  NXActionSheet.m
//  nightx
//
//  Created by 蒋瞿风 on 16/2/3.
//  Copyright © 2016年 maitianer. All rights reserved.
//

#import "NXActionSheet.h"

@interface NXSheetButton : UIButton
@property (assign, nonatomic) NSInteger index;

@end

@implementation NXSheetButton

@end

#define ButtonHeight                             55
#define PaddingBetweenCancelButtonAndOtherButton 6
#define PaddingBetweenButtons                    1

@interface NXActionSheet ()

@property (assign, nonatomic) BOOL          isAnimating;
@property (strong, nonatomic) NSString      *cancelTitle;
@property (strong, nonatomic) NSArray       *buttonTitles;
@property (strong, nonatomic) UIView        *actionBackgroundView;

@property (strong, nonatomic) void (^DismissWithClickedButtonAtIndexBlock)(NXActionSheet *action, NSInteger buttonIndex);

@end

@implementation NXActionSheet

+ (NXActionSheet *)actionSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(void (^)(NXActionSheet *action, NSInteger buttonIndex))block{
    NXActionSheet *actionSheet                       = [[NXActionSheet alloc] init];
    actionSheet.buttonTitles                         = otherButtonTitles;
    actionSheet.cancelTitle                          = cancelButtonTitle;
    actionSheet.DismissWithClickedButtonAtIndexBlock = block;
    return actionSheet;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSheet)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.actionBackgroundView];
}

- (void)setupUI{
    CGRect  frame            = self.frame;
    CGFloat width            = frame.size.width;
    CGFloat buttonCount      = (CGFloat)self.buttonTitles.count;
    CGFloat contentHeight    = self.cancelTitle?(PaddingBetweenCancelButtonAndOtherButton + ButtonHeight * (buttonCount + 1)  - PaddingBetweenButtons * (buttonCount - 1)):((ButtonHeight + PaddingBetweenButtons) * buttonCount - PaddingBetweenButtons);
    self.actionBackgroundView.frame = CGRectMake(0, frame.size.height, width, contentHeight);
    
    for (int i = 0; i < buttonCount; i++) {
        NXSheetButton *button = [self createButtonWithTitle:[self.buttonTitles objectAtIndex:i] frame:CGRectMake(0, (ButtonHeight + PaddingBetweenButtons) * i , width, ButtonHeight) atIndex:i];
        [self.actionBackgroundView addSubview:button];
    }
    
    if (self.cancelTitle) {
        NXSheetButton *cancelButton = [self createButtonWithTitle:self.cancelTitle frame:CGRectMake(0, (ButtonHeight + PaddingBetweenButtons) * buttonCount +PaddingBetweenCancelButtonAndOtherButton, width, ButtonHeight) atIndex:-1];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.actionBackgroundView addSubview:cancelButton];
    }
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.0]];
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        CGRect oldFrame                 = self.actionBackgroundView.frame;
        oldFrame.origin.y               = frame.size.height - contentHeight;
        self.actionBackgroundView.frame = oldFrame;
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

#pragma IBAction
- (IBAction)hiddenSheet{
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame                    = self.actionBackgroundView.frame;
        frame.origin.y                  += frame.size.height;
        self.actionBackgroundView.frame = frame;
        [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.0]];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        [self removeFromSuperview];
    }];
}

- (IBAction)hiddenSheetWithClickedButtonAtIndex:(NSInteger)index{
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame                    = self.actionBackgroundView.frame;
        frame.origin.y                  += frame.size.height;
        self.actionBackgroundView.frame = frame;
        [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.0]];
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        if (self.DismissWithClickedButtonAtIndexBlock) {
            self.DismissWithClickedButtonAtIndexBlock(self,index);
        }
        [self removeFromSuperview];
    }];
}

- (IBAction)didPressedButton:(NXSheetButton *)sender{
    if (self.isAnimating) {
        return;
    }
    
    [self hiddenSheetWithClickedButtonAtIndex:sender.index];
}

- (void)show{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showInView:(UIView *)view{
    self.frame = view.bounds;
    [view addSubview:self];
    [self setupUI];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == -1) {
        return self.cancelTitle;
    }
    
    return [self.buttonTitles objectAtIndex:buttonIndex];
}

- (NXSheetButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame atIndex:(NSInteger)index{
    NXSheetButton *button = [[NXSheetButton alloc] initWithFrame:frame];
    button.index = index;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
    [button setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(didPressedButton:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    return button;
}

- (UIView *)actionBackgroundView{
    if (!_actionBackgroundView) {
        _actionBackgroundView                  = [[UIView alloc] init];
        _actionBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    }
    return _actionBackgroundView;
}

- (UIImage * _Nonnull)imageWithColor:(UIColor * _Nonnull)color {
    CGRect rect          = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);
    UIImage *image       = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
