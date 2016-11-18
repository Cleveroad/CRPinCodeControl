//
//  CRPinCodeControl.m
//  CRPinCodeControl
//
//  Created by Sergey on 11/14/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

#import "CRPinCodeControl.h"
@interface CRPinCodeControl ()
    
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyBoardArray;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *separatorViewArray;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIImageView *mainPathOfLock;
@property (weak, nonatomic) IBOutlet UIImageView *centerOfLockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arcImageView;
@property (weak, nonatomic) IBOutlet UIView *defaultAnimationView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *cleanView;

@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSMutableArray <UIImageView *> *imageViewPasswordArray;
@property (strong, nonatomic) NSMutableArray *spacingConstraints;
@property (assign, nonatomic) NSInteger countOfImputPassword;
@property (assign, nonatomic) BOOL isWritePassword;
@property (assign, nonatomic) BOOL isCustomAnimation;

@end

@implementation CRPinCodeControl

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    NSBundle *bundles = [NSBundle bundleForClass:[CRPinCodeControl class]];
    [self.arcImageView setImage:[UIImage imageNamed:@"arc" inBundle:bundles compatibleWithTraitCollection:nil]];
    self.arcImageView.contentMode = UIViewContentModeCenter;
    [self.centerOfLockImageView setImage:[UIImage imageNamed:@"firstcenterOfLock" inBundle:bundles compatibleWithTraitCollection:nil]];
    [self.mainPathOfLock setImage:[UIImage imageNamed:@"mainPathOfLock" inBundle:bundles compatibleWithTraitCollection:nil]];
    self.isCustomAnimation = ([self.delegate respondsToSelector:@selector(incorrectPasswordAnimations)] && [self.delegate respondsToSelector:@selector(correctPasswordAnimations)]);
    if (self.isCustomAnimation) {
        self.defaultAnimationView.hidden = YES;
    }
    if (self.headerTextField) {
        self.headerLabel.text = self.headerTextField;
    }
    self.alpha = 0;
    self.password = [NSString new];
    self.isWritePassword = NO;
    if ((self.countOfNumberInPassword <= 0) || (self.countOfNumberInPassword > 10)) {
        self.countOfNumberInPassword = 5;
    }
    if (!self.mainColorScheme) {
        self.mainColorScheme = [UIColor colorWithRed:0.57 green:0.83 blue:0.91 alpha:1.0];
    }
    for (UIView *separator in self.separatorViewArray) {
        separator.backgroundColor = self.mainColorScheme;
    }
    [self.headerLabel setTextColor:self.mainColorScheme];
    for (int i = 0; i < self.keyBoardArray.count; i++) {
        UIButton * button = self.keyBoardArray[i];
        [button setTitleColor:self.mainColorScheme forState:UIControlStateNormal];
    }
    if (self.inputColorScheme) {
        for (int i = 0; i < self.keyBoardArray.count; i++) {
            UIButton * button = self.keyBoardArray[i];
            [button setBackgroundColor:self.inputColorScheme];
        }
        self.passwordView.backgroundColor = self.inputColorScheme;
        [self.deleteButton setBackgroundColor:self.inputColorScheme];
        self.cleanView.backgroundColor = self.inputColorScheme;
    }
    self.countOfImputPassword = 0;
    
    [self.deleteButton setImage:[[UIImage imageNamed:@"delete" inBundle:bundles compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.deleteButton setTintColor:self.mainColorScheme];
    self.centerOfLockImageView.layer.zPosition = 1000;
    [self createStars];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)createStars {
    NSBundle *bundles = [NSBundle bundleForClass:[CRPinCodeControl class]];
    self.spacingConstraints = [NSMutableArray new];
    self.imageViewPasswordArray = [NSMutableArray new];
    for (int i = 0; i < self.countOfNumberInPassword; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shape" inBundle:bundles compatibleWithTraitCollection:nil]];
        imageView.image = [imageView.image  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imageView.tintColor = self.mainColorScheme;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.alpha = 0;
        imageView.contentMode = UIViewContentModeCenter;
        [self.passwordView addSubview:imageView];
        [self.imageViewPasswordArray addObject:imageView];
        NSMutableArray *constraints = [NSMutableArray new];
        if (i == 0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.passwordView
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0
                                                                 constant:0]];
        } else {
            NSLayoutConstraint* spacingConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                                 attribute:NSLayoutAttributeLeading
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.imageViewPasswordArray[i - 1]
                                                                                 attribute:NSLayoutAttributeTrailing
                                                                                multiplier:1.0
                                                                                  constant:0];
            [constraints addObject:spacingConstraint];
            [self.spacingConstraints addObject:spacingConstraint];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.imageViewPasswordArray[0]
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0
                                                                 constant:0]];
        }
        if (i == self.countOfNumberInPassword - 1) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.passwordView
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0]];
        }
        [constraints addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.passwordView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:imageView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.passwordView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:0]];
        [NSLayoutConstraint activateConstraints:constraints];
    }
}
    
- (IBAction)keyBoardButtonTap:(UIButton *)sender {
    if (self.countOfImputPassword < self.countOfNumberInPassword) {
        for (int i = 0; i < self.keyBoardArray.count; i++) {
            UIButton *button = self.keyBoardArray[i];
            if ([button isEqual:sender]) {
                if ([self.password isEqualToString:@""]) {
                    self.password = [NSString stringWithFormat:@"%d",i];
                } else {
                    self.password = [NSString stringWithFormat:@"%@ %d",self.password,i];
                }
                [UIView animateWithDuration:0.3 animations:^{
                    self.imageViewPasswordArray[self.countOfImputPassword].alpha = 1;
                }];
                self.countOfImputPassword ++;
                NSArray *textPassword = [self.password componentsSeparatedByString:@" "];
                NSMutableString *passwordString = [NSMutableString new];
                for (int i = 0; i < textPassword.count; i++) {
                    [passwordString appendString:textPassword[i]];
                }
                if (self.countOfImputPassword == self.countOfNumberInPassword) {
                    if ([self.delegate isCorrectPassword:passwordString]) {
                        [self performSelector:@selector(openAnimation) withObject:nil afterDelay:0.3];
                    } else {
                        [self performSelector:@selector(errorAnimation) withObject:nil afterDelay:0.3];
                    }
                }
                
            }
        }
    }
}

- (IBAction)deleteButtonTap:(UIButton *)sender {
    if (self.countOfImputPassword > 0 ) {
        if (self.countOfImputPassword <= self.countOfNumberInPassword) {
            self.countOfImputPassword --;
            NSArray *textPassword = [self.password componentsSeparatedByString:@" "];
            self.password = [NSString new];
            for (int i = 0; i < textPassword.count - 1; i++) {
                if ([self.password isEqualToString:@""]) {
                    self.password = [NSString stringWithFormat:@"%@",textPassword[i]];
                } else {
                    self.password = [NSString stringWithFormat:@"%@ %@",self.password,textPassword[i]];
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.imageViewPasswordArray[self.countOfImputPassword].alpha = 0;
            }];
            if (self.countOfImputPassword == self.countOfNumberInPassword - 1) {
                [self reloadPinCodeControl];
            }
        }
    } else {
        self.countOfImputPassword = 0;
    }
}

- (void) reloadPinCodeControl {
    NSBundle *bundles = [NSBundle bundleForClass:[CRPinCodeControl class]];
    for (UIView *view in self.imageViewPasswordArray) {
        [UIView animateWithDuration:0.3 animations:^{
            view.tintColor = self.mainColorScheme;
        }];
    }
    [UIView animateWithDuration:0.15 animations:^{
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90 * M_PI / 180, 0.0f, 1.0f, 0.0f);
        self.centerOfLockImageView.layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.centerOfLockImageView.image = [UIImage imageNamed:@"firstcenterOfLock" inBundle:bundles compatibleWithTraitCollection:nil];
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / -500;
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0, 0.0f, 1.0f, 0.0f);
            self.centerOfLockImageView.layer.transform = rotationAndPerspectiveTransform;
        }];
    }];
}

- (void) openAnimation {
    NSBundle *bundles = [NSBundle bundleForClass:[CRPinCodeControl class]];
    if (self.isWritePassword != YES) {
        for (UIView *view in self.imageViewPasswordArray) {
            [UIView animateWithDuration:0.3 animations:^{
                view.tintColor = [UIColor colorWithRed:0.38 green:0.79 blue:0.36 alpha:1.0];
            }];
        }
        if (!self.isCustomAnimation) {
            [UIView animateWithDuration:0.15 animations:^{
                CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90 * M_PI / 180, 0.0f, 1.0f, 0.0f);
                self.centerOfLockImageView.layer.transform = rotationAndPerspectiveTransform;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 animations:^{
                    self.centerOfLockImageView.image = [UIImage imageNamed:@"openCenterOfLock" inBundle:bundles compatibleWithTraitCollection:nil];
                    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                    rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0, 0.0f, 1.0f, 0.0f);
                    self.centerOfLockImageView.layer.transform = rotationAndPerspectiveTransform;
                    self.isWritePassword = YES;
                }];
            }];
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint pocition = self.arcImageView.center;
                pocition.y -= 20;
                self.arcImageView.center = pocition;
            }];
        } else {
            [self.delegate correctPasswordAnimations];
        }
    }
    [self closeControl];
}

- (void) closeControl {
    [UIView animateKeyframesWithDuration:0.5 delay:0.5 options:nil animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) errorAnimation {
    NSBundle *bundles = [NSBundle bundleForClass:[CRPinCodeControl class]];
    for (UIView *view in self.imageViewPasswordArray) {
        [UIView animateWithDuration:0.3 animations:^{
            view.tintColor = [UIColor colorWithRed:0.89 green:0.35 blue:0.22 alpha:1.0];
        }];
    }
    if (!self.isCustomAnimation) {
        [UIView animateWithDuration:0.15 animations:^{
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0 / -500;
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 90 * M_PI / 180, 0.0f, 1.0f, 0.0f);
            self.centerOfLockImageView.layer.transform = rotationAndPerspectiveTransform;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.centerOfLockImageView.image = [UIImage imageNamed:@"closeCenterOfLock" inBundle:bundles compatibleWithTraitCollection:nil];
                CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 0, 0.0f, 1.0f, 0.0f);
                self.centerOfLockImageView.layer.transform = rotationAndPerspectiveTransform;
            }];
        }];
    } else {
        [self.delegate incorrectPasswordAnimations];
    }
    [UIView animateWithDuration:0.1 animations:^{
        CGPoint pocition = self.defaultAnimationView.center;
        pocition.x -= 5;
        self.defaultAnimationView.center = pocition;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            CGPoint pocition = self.defaultAnimationView.center;
            pocition.x += 10;
            self.defaultAnimationView.center = pocition;
        } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.1 animations:^{
            CGPoint pocition = self.defaultAnimationView.center;
            pocition.x -= 7;
            self.defaultAnimationView.center = pocition;
             } completion:^(BOOL finished) {
                 [UIView animateWithDuration:0.1 animations:^{
                     CGPoint pocition = self.defaultAnimationView.center;
                     pocition.x += 2;
                 }];
             }];
        }];
    }];
}

@end
