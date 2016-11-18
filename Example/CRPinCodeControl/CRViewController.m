//
//  CRViewController.m
//  CRPinCodeControl
//
//  Created by Sergey on 11/16/2016.
//  Copyright (c) 2016 Sergey. All rights reserved.
//

#import "CRViewController.h"
#import "CRPinCodeControl.h"

@interface CRViewController () <CRPinCodeControlDelegate>

@end

@implementation CRViewController


- (BOOL) isCorrectPassword:(NSString *)password {
    if ([password isEqualToString:@"111111"]) {
        return YES;
    } else {
        return NO;
    }
}

//- (void) correctPasswordAnimations {
//    NSLog(@"correctPasswordAnimations");
//}
//
//- (void) incorrectPasswordAnimations {
//    NSLog(@"incorrectPasswordAnimations");
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CRPinCodeControl *containerView = [[[NSBundle bundleForClass:[CRPinCodeControl class]] loadNibNamed:@"CRPinCodeControl" owner:self options:nil] lastObject];
    containerView.countOfNumberInPassword = 6;
    containerView.delegate = self;
    [self.view addSubview:containerView];
    [containerView setFrame:[self.view frame]];
}

@end
