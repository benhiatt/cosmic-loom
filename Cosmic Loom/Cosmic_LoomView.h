//
//  Cosmic_LoomView.h
//  Cosmic Loom
//
//  Created by Ben Hiatt on 3/11/18.
//  Copyright © 2018 Dead Horse Labs, LLC. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <OpenGL/gl.h>

@interface Cosmic_LoomView : ScreenSaverView

@property (nonatomic, retain) NSOpenGLView* glView;

- (NSOpenGLView *)createGLView;

@end
