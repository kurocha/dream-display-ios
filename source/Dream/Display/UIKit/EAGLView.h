//
//  Display/UIKit/EAGLView.h
//  This file is part of the "Dream" project, and is released under the MIT license.
//
//  Created by Samuel Williams on 18/04/09.
//  Copyright Samuel Williams 2009. All rights reserved.
//
//

// This is a private header, and should not be used as public API.

#import <UIKit/UIKit.h>

#include "Renderer.h"

/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView {
	/* The pixel dimensions of the backbuffer */
	BOOL _resize_buffers;
	GLint _backing_width;
	GLint _backing_height;

	EAGLContext * _context;

	/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
	GLuint _default_framebuffer, _color_renderbuffer;

	/* OpenGL name for the depth buffer that is attached to view_framebuffer, if it exists (0 if it does not exist) */
	GLuint _depth_renderbuffer;

	// The display link and associated render thread.
	NSThread * _render_thread;
	NSConditionLock * _render_thread_lock;
}

@property (nonatomic, retain) EAGLContext * context;

// Internally used to setup the view - called during object construction for both init_with_frame: and init_with_coder:
- (void) setup;

- (void) makeCurrentContext;
- (BOOL) flushBuffers;

- (void) start;
- (void) stop;

@end
