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

#import "TFFileUtils.h"

@implementation TFFileUtils

#pragma mark - Data File Management

+(NSArray*) filesInDirectory:(NSString*) directory{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * path = [self dataDirectory:directory];
    NSArray * dirContents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    return dirContents;
}

+(NSString*)dataFile:(NSString*)filename
         inDirectory:(NSString*)subfolder
{
    NSString *directory = [self dataDirectory:subfolder];
    NSString *filepath = [directory stringByAppendingPathComponent:filename];
    return filepath;
}

+(NSString*)dataDirectory:(NSString*)subfolder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:subfolder];
    NSError *error;
    if (![fm fileExistsAtPath:path]){
        if (![fm createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]){
            NSLog(@"Create directory error: %@", error);
        }
    }
    return path;
}

+(BOOL)dataFile:(NSString*)filename
existsInDirectory:(NSString*)subfolder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filepath = [self dataFile:filename inDirectory:subfolder];
    return [fm fileExistsAtPath:filepath];
}

+(void)deleteDataFile:(NSString*)filename
        fromDirectory:(NSString*)subfolder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filepath = [self dataFile:filename inDirectory:subfolder];
    NSError *error;
    if([self dataFile:filename existsInDirectory:subfolder])
        if(![fm removeItemAtPath:filepath error:&error])
            NSLog(@"Unable to delete data file: %@", error);
}

+(BOOL)renameDataFile:(NSString*)filename
                   to:(NSString*)newFilename
          inDirectory:(NSString*)subfolder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filepath = [self dataFile:filename inDirectory:subfolder];
    NSString *newFilepath = [self dataFile:newFilename inDirectory:subfolder];
    NSError *error;
    if([self dataFile:filename existsInDirectory:subfolder]){
        if(![fm moveItemAtPath:filepath toPath:newFilepath error:&error]){
            NSLog(@"Unable to rename data file: %@", error);
            return NO;
        }
    }
    return YES;
}

+(BOOL) isProjectNameOccupied:(NSString*) name{
    
    return [TFFileUtils dataFile:name existsInDirectory:kProjectsDirectory];
}

+(BOOL) isPaletteNameOccupied:(NSString*) name{
    
    return [TFFileUtils dataFile:name existsInDirectory:kPaletteItemsDirectory];
}

+(NSString*) resolveProjectNameConflictFor:(NSString*) originalName{
    NSString * name = [NSString stringWithString:originalName];
    NSInteger i = 2;
    while([TFFileUtils isProjectNameOccupied:name]){
        name = [NSString stringWithFormat:@"%@%d",originalName,i++];
    }
    
    return name;
}

+(NSString*) resolvePaletteNameConflictFor:(NSString*) originalName{
    NSString * name = [NSString stringWithString:originalName];
    NSInteger i = 2;
    while([TFFileUtils isPaletteNameOccupied:name]){
        name = [NSString stringWithFormat:@"%@%d",originalName,i++];
    }
    
    return name;
}

#pragma mark - Image File Management

+(void) saveImageToFile:(UIImage*) image file:(NSString*) filePath{
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

CGImageRef UIGetScreenImage(void);

+(UIImage*)screenshot
{
    CGImageRef screen = UIGetScreenImage();
    UIImage * image = [UIImage imageWithCGImage:screen];
    CGImageRelease(screen);
    return image;
}

+(void)screenshotToFile:(NSString*)filePath{
    UIImage *img = [self screenshot];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(screenHeight, screenWidth));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextRotateCTM (context, M_PI/2);
    [img drawInRect:CGRectMake(0, -screenHeight, screenWidth, screenHeight)];
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImageToFile:ret file:filePath];
}

@end
