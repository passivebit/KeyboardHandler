//
//  KeyboardHandler.m
//  TestCollectionDate
//
//  Created by Ritu Raj on 07/04/17.
//  Copyright © 2017 Acknown Technologies. All rights reserved.
//

#import "KeyboardHandler.h"

@interface KeyboardHandler ()<UITextFieldDelegate>

{
    UIViewController *controller;
    UITapGestureRecognizer *tapGestureRecognizer;
    UIView *activeResponder;
}

@end

@implementation KeyboardHandler

CGFloat viewOffset = 0.0f;

-(instancetype)initWithViewController:(UIViewController*)viewController {
    
    if (self = [super init]) {
        
        controller = viewController;
        
    }
    
//    [self perpareKeyboard];
    
    return  self;
}

-(void)perpareKeyboard {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionToDismissKeyboard:)];
    
    [controller.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)dealloc {
    
    NSLog(@"deinit called great!!!");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard notification methods

-(void)keyboardWillShow:(NSNotification*)notification {
    
    activeResponder = [self findCurrentResponder:controller.view];
    
    if ([activeResponder isKindOfClass:[UITextField class]]){
        [(UITextField*)activeResponder setDelegate:self];
    }
    
    CGPoint activeResponderOrigin = activeResponder.frame.origin;
    
    activeResponderOrigin.y += activeResponder.frame.size.height;
    
    CGPoint textFieldPosition = [activeResponder.superview convertPoint:activeResponderOrigin toView:[[[UIApplication sharedApplication] delegate] window]];
    
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat keyboardOffsetFromActiveResponder = textFieldPosition.y - (controller.view.frame.size.height - keyboardSize.height);
    
    if (keyboardOffsetFromActiveResponder > 0) {
        
        viewOffset += keyboardOffsetFromActiveResponder;
        
        [self animateViewByOffset: (-keyboardOffsetFromActiveResponder)];
        
    }
    
}

-(void)keyboardWillHide:(NSNotification*)notification {
    
    [self animateViewByOffset:viewOffset];
    viewOffset = 0.0;
}

-(void)functionToDismissKeyboard:(UITapGestureRecognizer*)tapGesture {
    
    NSLog(@"functionToDismissKeyboard");
    
//    [controller.view endEditing:YES];
    
    [activeResponder resignFirstResponder];
}

#pragma mark - UITextField delegate
//TODO: if want to handle uitextfield delegates in uiviewcontroller just create protocols and handle them there.
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    //TODO: uncomment the below if want to go to next responder on return press
    
//    NSInteger nextTag = textField.tag + 1;
//    // Try to find next responder
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    if (nextResponder) {
//        // Found next responder, so set it.
//        [nextResponder becomeFirstResponder];
//    } else {
//        // Not found, so remove keyboard.
//        [textField resignFirstResponder];
//    }
//    return NO; // We do not want UITextField to insert line-breaks.
    [self functionToDismissKeyboard:nil];
    
    if([self.delegate respondsToSelector:@selector(keyboardHandlerTextFieldShouldReturn:)]){
        [self.delegate keyboardHandlerTextFieldShouldReturn:textField];
    }
    
    
    return NO;
}

#pragma mark - Miscellaneous methods

-(UIView*)findCurrentResponder:(UIView*)rootView {
    
    if(rootView.isFirstResponder && ([rootView isKindOfClass:[UITextField class]]||[rootView isKindOfClass:[UITextView class]])) {
        
        return rootView;
        
    } else {
        
        if (rootView.subviews.count == 0) {
            
            return nil;
            
        } else {
            
            for (UIView *responder in rootView.subviews) {
                
                UIView *v = [self findCurrentResponder:responder];
                if (v) {
                    return v;
                }
            }
            
            return nil;
        }
        
    }
}

-(void)animateViewByOffset:(CGFloat)distance {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        controller.view.frame = CGRectOffset(controller.view.frame, 0.0f, distance);
        
    }];
}


@end
