//
//  CSPLoginViewController.h
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//error kind for login view
typedef NS_ENUM (NSUInteger, LoginErrorType) {
    LoginErrorTypeNoUserName,
    LoginErrorTypeNoPassword,
    LoginErrorTypeUserNamePasswordNoMatch
};

@interface CSPLoginViewController : UIViewController<UITextFieldDelegate>

@end
