//
//  CRPinCodeControl.h
//  CRPinCodeControl
//
//  Created by Sergey on 11/14/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRPinCodeControlDelegate <NSObject>
@required

- (BOOL) isCorrectPassword:(NSString *) password;

@optional

- (void) correctPasswordAnimations;
- (void) incorrectPasswordAnimations;

@end

@interface CRPinCodeControl : UIControl

@property (weak, nonatomic) IBOutlet UIView *viewForAnimation;
@property (assign, nonatomic) id <CRPinCodeControlDelegate> delegate;
@property (strong, nonatomic) UIColor *mainColorScheme;
@property (strong, nonatomic) UIColor *inputColorScheme;
@property (assign, nonatomic) NSInteger countOfNumberInPassword;
@property (strong, nonatomic) NSString *headerTextField;

@end
