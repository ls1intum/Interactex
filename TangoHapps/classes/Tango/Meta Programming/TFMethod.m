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
#import "TFMethod.h"

@implementation TFMethod


#pragma mark - Initialization

+(id) methodWithName:(NSString*) name {
    return [[TFMethod alloc] initWithName:name];
}

-(id) initWithName:(NSString*) name {
    self = [super init];
    if(self){
        _name = name;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.name = [decoder decodeObjectForKey:@"name"];
    self.returnType = [decoder decodeIntegerForKey:@"returnType"];
    self.firstParamType = [decoder decodeIntegerForKey:@"firstParamType"];
    self.returnsData = [decoder decodeBoolForKey:@"returnsData"];
    self.numParams = [decoder decodeIntegerForKey:@"numParams"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.returnType forKey:@"returnType"];
    [coder encodeInteger:self.firstParamType forKey:@"firstParamType"];
    [coder encodeBool:self.returnsData forKey:@"returnsData"];
    [coder encodeInteger:self.numParams forKey:@"numParams"];
}

-(id)copyWithZone:(NSZone *)zone {
    
    TFMethod * copy = [[TFMethod alloc] init];
    copy.name = self.name;
    copy.returnType = self.returnType;
    copy.firstParamType = self.firstParamType;
    copy.returnsData = self.returnsData;
    copy.numParams = self.numParams;
    return copy;
}

#pragma mark - Methods

-(BOOL) isEqualToMethod:(TFMethod*)method {
    if([self.name isEqualToString:method.name] && self.returnType == method.returnType && self.firstParamType == method.firstParamType && self.returnsData == method.returnsData && self.numParams == method.numParams){
        return YES;
    }
    return NO;
}

-(NSString*) signature {
    NSString * signature = [NSString stringWithFormat:@"%@",self.name];
    if(self.numParams == 1){
        signature = [signature stringByAppendingFormat:@":"];
    }
    return signature;
}

-(BOOL) acceptsParemeterOfType:(TFDataType) type {
    if(self.numParams == 1 && [THClientHelper canConvertParam:type toType:self.firstParamType]){
        return YES;
    }
    return NO;
}

-(NSString*) description {
    NSString * returnString = self.returnsData ? [NSString stringWithFormat:@" (%@)",dataTypeStrings[self.returnType]] : @"";
    NSString * firstParamString = self.numParams > 0 ? [NSString stringWithFormat:@" (%@)",dataTypeStrings[self.firstParamType]] : @"";
 
    return [NSString stringWithFormat:@"%@%@%@",returnString,self.name,firstParamString];
}

@end
