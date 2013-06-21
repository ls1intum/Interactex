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

#import "TFProperty.h"


@implementation TFProperty

+(id) propertyWithName:(NSString*) name andType:(TFDataType) type{
    return [[TFProperty alloc] initWithName:name andType:type];
}

-(id) initWithName:(NSString*) name andType:(TFDataType) type{
    self = [super init];
    if(self){
        self.name = name;
        self.type = type;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
        
    self.name = [decoder decodeObjectForKey:@"name"];
    self.type = [decoder decodeIntegerForKey:@"type"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.type forKey:@"type"];
}

-(id)copyWithZone:(NSZone *)zone {
    
    TFProperty * copy = [[TFProperty alloc] init];
    copy.name = self.name;
    copy.type = self.type;
    return copy;
}

#pragma mark - Methods

-(NSString*) description{
    
    return [NSString stringWithFormat:@"(%@) %@",dataTypeStrings[self.type],self.name];
}

@end
