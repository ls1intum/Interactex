//
//  THUtils.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/2/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THUtils.h"

@implementation THUtils

static AVAudioPlayer * _backgroundMusicPlayer;

+(void) playAudio:(NSString*) name{
    NSError *error;
    
    NSBundle * bundle = [NSBundle mainBundle];
    
    NSString * path = [bundle pathForResource:name ofType:@"mp3"];
    path = [path stringByExpandingTildeInPath];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                              initWithContentsOfURL:url error:&error];
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}

+(void) stopPlaying{
    [_backgroundMusicPlayer stop];
}

CGImageRef UIGetScreenImage(void);

+(UIImage*)screenshot
{
    CGImageRef screen = UIGetScreenImage();
    UIImage * image = [UIImage imageWithCGImage:screen];
    CGImageRelease(screen);
    return image;
}

+(UIImage*) croppedImage:(UIImage*) image rect:(CGRect) rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

+(UIImage*) rotatedImage:(UIImage*) image{
    
    float imageHeight = image.size.height;
    float imageWidth = image.size.width;
    
    UIGraphicsBeginImageContext(CGSizeMake(imageHeight, imageWidth));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRotateCTM (context, M_PI/2);
    [image drawInRect:CGRectMake(0, -imageHeight, imageWidth, imageHeight)];
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

@end
