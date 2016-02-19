//
//  ViewController.m
//  NXActionSheetDemo
//
//  Created by 蒋瞿风 on 16/2/19.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import "ViewController.h"
#import "NXActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActionSheet:(id)sender{
    [[NXActionSheet actionSheetWithCancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Item1",@"Item2",@"Item3"] handler:^(NXActionSheet *actionSheet, NSInteger buttonIndex) {
        NSLog(@"Did Selected %@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    }] showInView:self.view];
}

@end
