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

#import "TFEvent.h"
#import "TFMethod.h"
#import "TFPropertyInvocation.h"
#import "TFProperty.h"

@implementation TFEvent

+(id) eventNamed:(NSString*) name{
    return [[TFEvent alloc] initWithName:name];
}

-(id) initWithName:(NSString*) name{
    self = [super init];
    if(self){
        self.name = name;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.name = [decoder decodeObjectForKey:@"name"];
    self.param1 = [decoder decodeObjectForKey:@"propertyInvocation"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.param1 forKey:@"propertyInvocation"];
}

-(id)copyWithZone:(NSZone *)zone {
    
    TFEvent * copy = [[TFEvent alloc] init];
    copy.name = self.name;
    copy.param1 = self.param1;
    
    return copy;
}

-(BOOL) canTriggerMethod:(TFMethod*) method{
    if(self.param1 == nil){
        if(method.numParams == 0){
            return YES;
        } else {
            return NO;
        }
    } else {
        if(method.numParams == 1 && [method acceptsParemeterOfType:self.param1.property.type]){
            return YES;
        } else {
            return NO;
        }
    }
}

-(NSString*) description{
    if(self.param1){
        NSString * param1 = self.param1.property.name;
        return [NSString stringWithFormat:@"%@ (%@)",self.name,param1];
    } else {
        return [NSString stringWithFormat:@"%@",self.name];
    }
}

@end
