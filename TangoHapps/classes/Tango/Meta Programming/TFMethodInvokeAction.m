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

#import "TFMethodInvokeAction.h"
#import "TFMethod.h"
#import "TFPropertyInvocation.h"
#import "TFProperty.h"

@implementation TFMethodInvokeAction

+(id) actionWithTarget:(id) target method:(TFMethod*) method{
    return [[TFMethodInvokeAction alloc] initWithTarget:target method:method];
}

-(id) initWithTarget:(id) target method:(TFMethod*) method{
    self = [super init];
    if(self){
        self.target = target;
        self.method = method;
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    
    self.method = [decoder decodeObjectForKey:@"method"];
    self.firstParam = [decoder decodeObjectForKey:@"firstParam"];

    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.method forKey:@"method"];
    [coder encodeObject:self.firstParam forKey:@"firstParam"];
}

-(id)copyWithZone:(NSZone *)zone {
    TFMethodInvokeAction * copy = [super copyWithZone:zone];
    
    copy.method = self.method;
    copy.firstParam = [self.firstParam copy];
    
    return copy;
}

#pragma mark - Methods

-(BOOL) isEqualToAction:(TFMethodInvokeAction*)action {
    if(self.target == action.target && [self.method isEqualToMethod:action.method]) return YES;
    return NO;
}

-(void) startAction {
    
    SEL selector = NSSelectorFromString(self.method.signature);
    
    NSMethodSignature *signature = [self.target methodSignatureForSelector:selector];
    
    NSAssert(signature != nil, @"signature not found for method %@ on target %@",self.method,self.target);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self.target];
    [invocation setSelector:selector];
    if(signature.numberOfArguments > 2){
        id result = [self.firstParam invoke];
        
        //NSLog(@"sending b: %@",result);
        
        if(self.method.firstParamType == kDataTypeBoolean){
            NSNumber * number = result;
            BOOL b = number.boolValue;
            [invocation setArgument:&b atIndex:2];
        } else if(self.method.firstParamType == kDataTypeInteger){
            NSNumber * number = result;
            NSInteger i = number.integerValue;
            if(self.method.firstParamType == kDataTypeInteger){
                [invocation setArgument:&i atIndex:2];
            } else if(self.method.firstParamType == kDataTypeFloat){
                float f = (float) i;
                [invocation setArgument:&f atIndex:2];
            }
            
        } else if(self.method.firstParamType == kDataTypeFloat){
            NSNumber * number = result;
            float f = number.floatValue;
            if(self.method.firstParamType == kDataTypeInteger){
                NSInteger intValue = (NSInteger) f;
                [invocation setArgument:&intValue atIndex:2];
            } else if(self.method.firstParamType == kDataTypeFloat){
                [invocation setArgument:&f atIndex:2];
            }
        } else {
            [invocation setArgument:&result atIndex:2];
        }
    }
    [invocation invoke];
}

-(void) finishAction{
    
}

-(NSString*) description{
    return [NSString stringWithFormat:@"%@ on %@",self.method, self.target];
}

@end
