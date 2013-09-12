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

#import "THCustomPaletteItem.h"
#import "TFEditableObject.h"

@implementation THCustomPaletteItem

+(id) customPaletteItemWithArchiveName:(NSString*) name{
    THCustomPaletteItem * item = [NSKeyedUnarchiver unarchiveObjectWithFile:name];
    return item;
}

+(id) customPaletteItemWithName:(NSString*) name object:(TFEditableObject*) object{
    THCustomPaletteItem * item = [[THCustomPaletteItem alloc] initWithName:name object:object];
    item.isEditable = YES;
    return item;
}

-(id) initWithName:(NSString *)name object:(TFEditableObject*) object{
    self = [super initWithName:name];
    if(self){
        self.object = [object copy];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    
    self = [super initWithCoder:decoder];
    if(self){
        self.paletteName = [decoder decodeObjectForKey:@"paletteName"];
        self.object = [decoder decodeObjectForKey:@"object"];
        self.isEditable = YES;
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.paletteName forKey:@"paletteName"];
    [aCoder encodeObject:self.object forKey:@"object"];
}

-(void) save{
    
    NSString * filePath = [TFFileUtils dataFile:self.name inDirectory:kPaletteItemsDirectory];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

#pragma mark Droppable

- (void) dropAt:(CGPoint)location {
    TFEditableObject * object = [self.object copy];
    object.position = location;
    [object addToWorld];
}

#pragma mark Arguments

-(void) renameTo:(NSString *)name{
    NSString * newName = [TFFileUtils resolvePaletteNameConflictFor:name];
    [TFFileUtils renameDataFile:self.name to:newName inDirectory:kPaletteItemsDirectory];
    self.name = newName;
    [self save];
}

-(void) deleteArchive{
    [TFFileUtils deleteDataFile:self.name fromDirectory:kPaletteItemsDirectory];
}

-(void) prepareToDie{
    
}

@end
