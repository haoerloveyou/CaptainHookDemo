//
//  CaptainHookDemo.mm
//  CaptainHookDemo
//
//  Created by ZeroX on 13-5-1.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#import <Foundation/Foundation.h>
#import "CaptainHook/CaptainHook.h"
#include <notify.h> // not required; for examples only

// Objective-C runtime hooking using CaptainHook:
//   1. declare class using CHDeclareClass()
//   2. load class using CHLoadClass() or CHLoadLateClass() in CHConstructor
//   3. hook method using CHOptimizedMethod()
//   4. register hook using CHHook() in CHConstructor
//   5. (optionally) call old method using CHSuper()


@interface CaptainHookDemo : NSObject

@end

@implementation CaptainHookDemo

-(id)init
{
	if ((self = [super init]))
	{
	}

    return self;
}

@end


@class NSFileManager;

CHDeclareClass(NSFileManager);

#pragma mark - NSFileManager Hooker

CHOptimizedMethod(1, self, BOOL, NSFileManager, fileExistsAtPath, NSString*, arg1)
{
	NSLog(@"detect Path : %@", arg1);
	return CHSuper(1, NSFileManager, fileExistsAtPath, arg1);
}

CHOptimizedClassMethod(0, self, id, NSFileManager, defaultManager)
{
    NSLog(@"call Class Method : + (id)defaultManager");
    return CHSuper(0, NSFileManager, defaultManager);
}

#pragma mark - CHConstructor

CHConstructor // code block that runs immediately upon load
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	CHLoadLateClass(NSFileManager);  // load class (that will be "available later")
    
    CHHook(1, NSFileManager, fileExistsAtPath); // register hook
    CHHook(0, NSFileManager, defaultManager);
	
	[pool drain];
}
