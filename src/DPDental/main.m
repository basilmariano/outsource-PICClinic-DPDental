//
//  main.m
//  DPDental
//
//  Created by Wong Johnson on 9/4/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DPAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        isiPhone5Device = IS_IPHONE_5;
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([DPAppDelegate class]));
    }
}
