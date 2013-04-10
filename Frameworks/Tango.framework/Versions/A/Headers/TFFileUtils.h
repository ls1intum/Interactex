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

@interface TFFileUtils : NSObject

+(NSArray*) filesInDirectory:(NSString*) directory;
+(NSString*)dataFile:(NSString*)filename inDirectory:(NSString*)subfolder;
+(NSString*)dataDirectory:(NSString*)subfolder;

+(BOOL)dataFile:(NSString*)filename existsInDirectory:(NSString*)subfolder;
+(void)deleteDataFile:(NSString*)filename fromDirectory:(NSString*)subfolder;
+(BOOL)renameDataFile:(NSString*)filename to:(NSString*)newFilename inDirectory:(NSString*)subfolder;

//palette
+(BOOL) isPaletteNameOccupied:(NSString*) name;
+(NSString*) resolvePaletteNameConflictFor:(NSString*) originalName;

//projects
+(BOOL) isProjectNameOccupied:(NSString*) name;
+(NSString*) resolveProjectNameConflictFor:(NSString*) originalName;

+(void)screenshotToFile:(NSString*)filePath;
+(UIImage*)screenshot;
+(void) saveImageToFile:(UIImage*) image file:(NSString*) filePath;

@end
