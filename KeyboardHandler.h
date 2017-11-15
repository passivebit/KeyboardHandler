//
//  KeyboardHandler.h
//  TestCollectionDate
//
//  Created by Ritu Raj on 07/04/17.
//  Copyright © 2017 Acknown Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardHandlerDelegate <NSObject>

-(BOOL)keyboardHandlerTextFieldShouldReturn:(UITextField*)textField;

@end

@interface KeyboardHandler : NSObject

@property(nonatomic, weak) id<KeyboardHandlerDelegate>delegate;
-(instancetype)initWithViewController:(UIViewController*)viewController;
-(void)perpareKeyboard;
-(void)functionToDismissKeyboard:(UITapGestureRecognizer*)tapGesture;

@end
