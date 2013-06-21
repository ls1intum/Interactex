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

#import "TFPropertyInvocation.h"
#import "TFProperty.h"

@implementation TFPropertyInvocation

+(id) invocationWithProperty:(TFProperty*) property target:(id) target{
    return [[TFPropertyInvocation alloc] initWithProperty:property target:target];
}

-(id) initWithProperty:(TFProperty*) property target:(id) target{
    self = [super init];
    if(self){
        self.property = property;
        self.target = target;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    _property = [decoder decodeObjectForKey:@"property"];
    _target = [decoder decodeObjectForKey:@"target"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:_property forKey:@"property"];
    [coder encodeObject:_target forKey:@"target"];
}

-(id)copyWithZone:(NSZone *)zone {
    TFPropertyInvocation * copy = [[TFPropertyInvocation alloc] init];
    
    copy.property = [self.property copy];
    copy.target = self.target;
    
    return copy;
}

#pragma mark - Methods

-(id) invoke{
    NSObject * object = self.target;
    return [object valueForKey:self.property.name];
}

@end
