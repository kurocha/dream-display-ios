//
//  Display/UIKit/Context.mm
//  This file is part of the "Dream" project, and is released under the MIT license.
//
//  Created by Samuel Williams on 20/04/09.
//  Copyright (c) 2009 Samuel Williams. All rights reserved.
//
//

#include "Context.h"
#import "DOpenGLView.h"

#include "Renderer.h"

namespace Dream
{
	namespace Display
	{
		namespace UIKit
		{
		
			ViewContext::ViewContext ()
				: _graphics_view(nil)
			{
			
			}
			
			ViewContext::ViewContext (DOpenGLView * graphicsView)
				: _graphics_view(graphicsView)
			{
				[_graphics_view retain];
				[_graphics_view setDisplayContext:this];
			}
			
			ViewContext::~ViewContext ()
			{
				if (_graphics_view) {
					[_graphics_view release];
					_graphics_view = nil;
				}
			}
			
			void ViewContext::start ()
			{
				[_graphics_view start];
			}
			
			void ViewContext::stop ()
			{
				[_graphics_view stop];
			}
			
			Vec2u ViewContext::size ()
			{
				CGRect frame = [_graphics_view frame];
				CGFloat scale = [_graphics_view contentScaleFactor];
				
				return Vec2u(frame.size.width * scale, frame.size.height * scale);
			}
			
			static const char * get_symbolic_error (GLenum error) {
				switch (error) {
					case GL_NO_ERROR:
						return "No error has occurred.";
					case GL_INVALID_ENUM:
						return "An invalid value has been specified (GL_INVALID_ENUM)!";
					case GL_INVALID_VALUE:
						return "A numeric argument is out of range (GL_INVALID_VALUE)!";
					case GL_INVALID_OPERATION:
						return "The specified operation is not allowed (GL_INVALID_OPERATION)!";
					//case GL_STACK_OVERFLOW:
					//	return "The specified command would cause a stack overflow (GL_STACK_OVERFLOW)!";
					//case GL_STACK_UNDERFLOW:
					//	return "The specified command would cause a stack underflow (GL_STACK_UNDERFLOW)!";
					case GL_OUT_OF_MEMORY:
						return "There is not enough free memory left to run the command (GL_OUT_OF_MEMORY)!";
					default:
						return "An unknown error has occurred!";
				}
			}
		
// MARK: -
		
			void WindowContext::setup_graphics_view (Ptr<Dictionary> config, CGRect frame)
			{
				if (config->get("Cocoa.View", _graphics_view)) {
					// Graphics view from configuration.
					[_graphics_view retain];
				} else {
					_graphics_view = [[DOpenGLView alloc] initWithFrame:frame];
				}

				// Create the OpenGLES context:
				EAGLContext *graphicsContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
				
				DREAM_ASSERT(graphicsContext != NULL);
				
				[_graphics_view setContext:graphicsContext];
				[graphicsContext release];
				
				[EAGLContext setCurrentContext:graphicsContext];
				
				glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
				glPixelStorei(GL_PACK_ALIGNMENT, 1);
				
				LogBuffer buffer;
				buffer << "OpenGL Context Initialized..." << std::endl;
				buffer << "\tOpenGL Vendor: " << glGetString(GL_VENDOR) << std::endl;
				buffer << "\tOpenGL Renderer: " << glGetString(GL_RENDERER) << " " << glGetString(GL_VERSION) << std::endl;
				buffer << "\tOpenGL Shading Language Version: " << glGetString(GL_SHADING_LANGUAGE_VERSION) << std::endl;
				logger()->log(LOG_INFO, buffer);
				
				// Clear current context.
				[EAGLContext setCurrentContext:nil];
			}
			
			WindowContext::WindowContext (Ptr<Dictionary> config)
			{
				UIScreen * mainScreen = [UIScreen mainScreen];
				
				_window = [[UIWindow alloc] initWithFrame:[mainScreen bounds]];
				
				CGRect frame = [[UIScreen mainScreen] applicationFrame];
				setup_graphics_view(config, frame);
				
				if (_graphics_view) {
					[_graphics_view setDisplayContext:this];
					[_window addSubview:_graphics_view];
					
					[_graphics_view setContentScaleFactor:[mainScreen scale]];
				} else {
					logger()->log(LOG_ERROR, "Couldn't initialize graphics view!");
				}
			}
			
			WindowContext::~WindowContext ()
			{
				if (_window) {
					[_window release];
					_window = nil;
				}
			}
		
			void WindowContext::start ()
			{
				logger()->log(LOG_INFO, LogBuffer() << "Starting graphics context: " << _graphics_view << " window: " << _window);
				
				[_window makeKeyAndVisible];
				ViewContext::start();
			}
			
			void WindowContext::stop ()
			{
				ViewContext::stop();
				[_window resignKeyWindow];
			}
			
		}
	}
}
