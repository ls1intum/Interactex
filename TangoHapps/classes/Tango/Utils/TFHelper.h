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

#import <Foundation/Foundation.h>

@interface TFHelper : NSObject {
    
}

+(CGPoint)tabToEditorCoordinates:(CGPoint) position;

+(void)Dec2bin:(unsigned short)dec bin:(bool*) res;
+(unsigned short) Bin2Dec:(bool[]) bits;

+(void) saveImageToFile:(UIImage*) image file:(NSString*) filePath;

//draw
+(void) drawRect:(CGRect) rect;
+(void) drawEmptyRect:(CGRect) rect;
+(void) drawLines:(NSArray *) connections;
+(void) drawWires:(NSArray *) wires;
+(void) restoreDrawingState;
+(void) drawLinesForObjects:(NSArray*)objects;

//+(NSBundle *)frameworkBundle;
+(UILabel*) navBarTitleLabelNamed:(NSString*) name;

+(CGPoint) ConvertToCocos2d:(CGPoint) point;
+(CGPoint) ConvertToCocos2dView:(CGPoint) point;
+(CGPoint) ConvertFromCocosToUI:(CGPoint) point;

/*
+(float) Constrain:(float) value min:(float) minValue max:(float) maxValue;
+(float) LinearMapping:(float)value min:(float) min max:(float) max retMin:(float) retMin retMax:(float) retMax;
 */
+(BOOL) canConvertParam:(TFDataType) type1 toType:(TFDataType) type2;

+(UIImage*) screenshot;

@end
