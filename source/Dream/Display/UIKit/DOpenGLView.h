//
//  Display/UIKit/DOpenGLView.h
//  This file is part of the "Dream" project, and is released under the MIT license.
//
//  Created by Samuel Williams on 29/04/09.
//  Copyright (c) 2009 Samuel Williams. All rights reserved.
//
//

// This is a private header, and should not be used as public API.

#import "EAGLView.h"

#include "../Context.h"
#include "../MultiFingerInput.h"

@interface DOpenGLView : EAGLView<UITextFieldDelegate>{
	Dream::Display::MultiFingerInput * _multi_finger_input;

	UITextField * _text_field;
	BOOL _keyboard_visible;

	Dream::Display::Context * _display_context;
}

@property (nonatomic, assign) Dream::Display::Context * displayContext;

- (BOOL) isKeyboardVisible;
- (void) showKeyboard;
- (void) hideKeyboard;

@end
