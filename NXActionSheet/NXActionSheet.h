//
//  NXActionSheet.h
//  nightx
//
//  Created by 蒋瞿风 on 16/2/3.
//  Copyright © 2016年 maitianer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXActionSheet : UIView

+ (NXActionSheet *)actionSheetWithCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(void (^)(NXActionSheet *actionSheet, NSInteger buttonIndex))block;

- (void)show;
- (void)showInView:(UIView *)view;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@end
