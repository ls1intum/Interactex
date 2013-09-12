/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
    //glColor4ub(255,255,255,255);
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
    CGImageRelease(screen);
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
