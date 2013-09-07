//
//  THHelper.m
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THHelper.h"

@implementation THHelper

+(ccColor3B) color3BFromUIColor:(UIColor*) color{
    float red;
    float green;
    float blue;
    float alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return ccc3(red * 255, green * 255, blue * 255);
}

+(UIColor*) uicolorFromColor3B:(ccColor3B) color{
    ccColor4F color4f = ccc4FFromccc3B(color);
    
    return [UIColor colorWithRed:color4f.r green:color4f.g blue:color4f.b alpha:color4f.a];
}


+(CGSize) currentSize
{
    return [THHelper sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end
