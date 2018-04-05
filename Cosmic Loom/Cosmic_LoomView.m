//
//  Cosmic_LoomView.m
//  Cosmic Loom
//
//  Created by Ben Hiatt on 3/11/18.
//  Copyright © 2018 Dead Horse Labs, LLC. All rights reserved.
//

#import "Cosmic_LoomView.h"

@implementation Cosmic_LoomView

const float TWO_PI = 2 * M_PI;

const float ONE_TWENTY_DEGREES = 120 * TWO_PI / 360; //in radians
const float TWO_FORTY_DEGREES = 2 * ONE_TWENTY_DEGREES; //in radians

const int THREADS = 1000;
const int SECTIONS = 10;
const int THREADS_PER_SECTION = THREADS / SECTIONS;

const float THETA = TWO_PI / THREADS; //in radians

float inner[THREADS][2];
float outer[THREADS][2];

const float LINE_WIDTH = 1.0;

const float PERIOD = 0.01; //seconds

float ITERATION = 0.0;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    for (int vertex = 0; vertex < THREADS; ++vertex) {
        float tempX = cos(THETA * vertex);
        float tempY = sin(THETA * vertex);
        inner[vertex][0] = 0.5 * tempX;
        inner[vertex][1] = 0.5 * tempY;
        outer[vertex][0] = 1.5 * tempX;
        outer[vertex][1] = 1.5 * tempY;
    }
    
    ITERATION = 0.0;
    
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        self.glView = [self createGLView];
        [self addSubview:self.glView];
        [self setAnimationTimeInterval:PERIOD];
    }
    return self;
}

- (NSOpenGLView *)createGLView {
    NSOpenGLPixelFormatAttribute attribs[] = {
        NSOpenGLPFAAccelerated,
        0
    };
    
    NSOpenGLPixelFormat* format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attribs];
    NSOpenGLView* glview = [[NSOpenGLView alloc] initWithFrame:NSZeroRect pixelFormat:format];
    
    NSAssert(glview, @"Unable to create OpenGL view!");
    
    //[format release]; //not needed thanks to ARC
    
    //return [glview autorelease]; //not needed thanks to ARC
    return glview;
}

- (void)dealloc {
    [self.glView removeFromSuperview];
    self.glView = nil;
    //[super dealloc]; //not needed thanks to ARC
}

- (void)startAnimation {
    [super startAnimation];
}

- (void)stopAnimation {
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
}

- (void)animateOneFrame {
    [self.glView.openGLContext makeCurrentContext];
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glLineWidth(LINE_WIDTH);
    glBegin(GL_LINES);
    for (int thread = 0; thread < THREADS; ++thread) {
        glColor3f(sin(TWO_PI * (thread % THREADS_PER_SECTION) / THREADS_PER_SECTION), sin(TWO_PI * (thread % THREADS_PER_SECTION) / THREADS_PER_SECTION + TWO_FORTY_DEGREES), sin(TWO_PI * (thread % THREADS_PER_SECTION) / THREADS_PER_SECTION + ONE_TWENTY_DEGREES)); //change to triangle wave for better coloring?
        // try variations of inner and outer for different shapes
        glVertex2f(outer[thread][0], outer[thread][1]); //outer
        glVertex2f(inner[(int) (ITERATION * thread) % THREADS][0], inner[(int) (ITERATION * thread) % THREADS][1]); //inner
    }
    glEnd();
    
    glFlush();
    [self setNeedsDisplay:YES];
    
    if (ITERATION < THREADS) {
        ITERATION += 0.01;
    } else {
        ITERATION = 0.01;
    }
    
    return;
}

- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    [self.glView setFrameSize:newSize];
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}

@end
