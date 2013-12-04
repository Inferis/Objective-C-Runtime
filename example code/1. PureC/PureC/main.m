//
//  main.m
//  PureC
//
//  Created by Tom Adriaenssen on 03/12/13.
//  Copyright (c) 2013 Tom Adriaenssen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

//there doesn't need to be a main.m because of this little beauty here.
int main(int argc, char** argv)
{
    //Initialize a valid app delegate object just like [NSApplication sharedApplication];
    initAppDel();
    //Initialize the run loop, just like [NSApp run];  this function NEVER returns until the app closes successfully.
    init_app();
    //We should close acceptably.
    return EXIT_SUCCESS;
}