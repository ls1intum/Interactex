//
//  THUtils.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/2/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface THUtils : NSObject
{
}

+(void) playAudio:(NSString*) name;
+(void) stopPlaying;
+(UIImage*)screenshot;
+(UIImage*) croppedImage:(UIImage*) image rect:(CGRect) rect;
+(UIImage*) rotatedImage:(UIImage*) image;

@end
