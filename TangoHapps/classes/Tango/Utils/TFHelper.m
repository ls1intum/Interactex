/*
TFHelper.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "TFHelper.h"
#import "TFConnectionLine.h"
#import "TFEditableObject.h"
#import "THWire.h"

@implementation TFHelper

+(CGPoint) tabToEditorCoordinates:(CGPoint) position{
    CGRect screen = [[UIScreen mainScreen] bounds]; 
    position.y = screen.size.width - position.y;
    return position;
}

+(void)Dec2bin:(unsigned short)dec bin:(bool*) res {
    for (int i=0; i<16; i++) {
        res[i] = 0;
    }
    
    int i=15;
    while(dec >1){
        bool bin = dec % 2;
        res[i--]=bin;
        dec /= 2;
    }
    res[i] = dec;
}

+(unsigned short) Bin2Dec:(bool[]) bits{
    unsigned short res = 0;
    for (int i=0;i<16;i++) {
        res <<= 1;
        res |= bits[15-i];
    }
    return res;
}

+(void) saveImageToFile:(UIImage*) image file:(NSString*) filePath{
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

+(void) drawRect:(CGRect) rect{
    
    /*CGPoint points[4];
    points[0] = rect.origin;
    points[1] = ccpAdd(rect.origin,ccp(rect.size.width,0));
    points[2] = ccpAdd(rect.origin,ccp(rect.size.width,rect.size.height));
    points[3] = ccpAdd(rect.origin,ccp(0,rect.size.height));
    ccDrawSolidPoly(points, 4, YES);
    */
    ccDrawSolidRect(rect.origin, ccpAdd(rect.origin,ccp(rect.size.width,rect.size.height)), ccc4f(1, 0, 0, 1));
}

+(void) drawEmptyRect:(CGRect) rect{/*
    CGPoint points[4];
    points[0] = rect.origin;
    points[1] = ccpAdd(rect.origin,ccp(rect.size.width,0));
    points[2] = ccpAdd(rect.origin,ccp(rect.size.width,rect.size.height));
    points[3] = ccpAdd(rect.origin,ccp(0,rect.size.height));
    ccDrawPoly(points, 4, YES);*/
    
    ccDrawSolidRect(rect.origin, ccpAdd(rect.origin,ccp(rect.size.width,rect.size.height)), ccc4f(1, 0, 0, 1));
}

+(void) drawLines:(NSArray *) connections{
    
    //glEnable(GL_LINE_SMOOTH);
    
    for (TFConnectionLine * line in connections) {
        if(line.obj1.visible && line.obj2.visible){
            [line draw];
        }
    }
    
    [TFHelper restoreDrawingState];
}

+(void) drawWires:(NSArray *) wires{
    
    //glEnable(GL_LINE_SMOOTH);
    
    for (THWire * wire in wires) {
        if(wire.obj1.visible && wire.obj2.visible){
            [wire draw];
        }
    }
    
    [TFHelper restoreDrawingState];
}

+(void)drawLinesForObjects:(NSArray*)objects{
    for (TFEditableObject * object in objects) {
        if(object.visible){
            NSArray * connections = object.connections;
            [TFHelper drawLines:connections];
        }
    }
}

+(void) restoreDrawingState{

    glLineWidth(1.0f);
    ccDrawColor4B(255,255,255,255);
//    glDisable(GL_LINE_SMOOTH);
}

/*
+(NSBundle*) frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"Tango.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}
*/
+(UILabel*) navBarTitleLabelNamed:(NSString*) name{
    
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(0, 5, 300, 35);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = name;
    label.textColor = [UIColor colorWithRed:0.43 green:0.47 blue:0.5 alpha:1];
    label.font = [UIFont systemFontOfSize:20];
    label.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    return label;
}

+(CGPoint) ConvertToCocos2d:(CGPoint) point{
    
    return ccp(point.x, -point.y);
}

+(CGPoint) ConvertToCocos2dView:(CGPoint) point{
    
    float diff = 768 - [CCDirector sharedDirector].view.frame.size.height;
    return ccp(point.x, 768 - point.y - diff);
}

+(CGPoint) ConvertFromCocosToUI:(CGPoint) point{
    
    return ccp(point.x, 768 - point.y);
}

/*
+(float) Constrain:(float) value min:(float) minValue max:(float) maxValue{
    value = MAX(value,minValue);
    value = MIN(value,maxValue);
    return value;
}

+(float) LinearMapping:(float)value min:(float) min max:(float) max retMin:(float) retMin retMax:(float) retMax{
    float a = (retMax - retMin) / (max - min);
    float b = retMin - (a * min);
    return a * value + b;
}
*/
+(BOOL) canConvertParam:(TFDataType) type1 toType:(TFDataType) type2{
    return (type1 == kDataTypeAny || type2 == kDataTypeAny || type1 == type2 || (type1 == kDataTypeFloat && type2 == kDataTypeInteger) || (type2 == kDataTypeFloat && type1 == kDataTypeInteger));
    
}

#pragma mark - Screenshot

CGImageRef UIGetScreenImage(void);

+(UIImage*) takeScreenshot
{
    CGImageRef screen = UIGetScreenImage();
    UIImage * image = [UIImage imageWithCGImage:screen];
    //CGImageRelease(screen);
    return image;
}

/*
+(UIImage*) screenshot{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //NSData * data = UIImagePNGRepresentation(image);
    //[data writeToFile:@"foo.png" atomically:YES];
    return image;
}*/

/*
static inline double radians (double degrees) {return degrees * M_PI/180;}

+(UIImage *) screenshot
{
    CGImageRef UIGetScreenImage(void);
    CGImageRef imagecg = UIGetScreenImage();
    //UIImage * image = [UIImage imageWithCGImage:imagecg];
    
    //UIGraphicsBeginImageContext(image.size);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextRotateCTM (context, radians(90));
    //[image drawAtPoint:CGPointMake(0, 0)];
    
    UIImage * image = [[UIImage alloc] initWithCGImage: imagecg scale: 1.0 orientation: UIImageOrientationUp];
    image = [UIImage imageWithCGImage:image.CGImage scale:0.5f orientation:UIImageOrientationLeft];
    cgaffinetransformro
    //image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRelease(imagecg);
    
    return image;
}*/


+(UIImage*) screenshot{
    UIImage *image = [self takeScreenshot];
    CGFloat navigationBarHeight = 44;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width - navigationBarHeight;
    CGFloat screenHeight = screenRect.size.height;

    
    UIGraphicsBeginImageContext(CGSizeMake(screenHeight, screenWidth));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(orientation == UIInterfaceOrientationLandscapeLeft){
        
        CGContextRotateCTM (context, M_PI/2);
        [image drawInRect:CGRectMake(-navigationBarHeight, -screenHeight, screenWidth + navigationBarHeight, screenHeight)];
        
    } else if(orientation == UIInterfaceOrientationLandscapeRight) {
        CGContextRotateCTM (context, -M_PI/2);
        [image drawInRect:CGRectMake(-screenWidth, 0, screenWidth + navigationBarHeight,screenHeight)];
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Animations


@end
