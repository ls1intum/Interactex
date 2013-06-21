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

#import "TFAction.h"
#import "TFMethod.h"

@implementation TFAction

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    self.source = [decoder decodeObjectForKey:@"source"];
    self.target = [decoder decodeObjectForKey:@"target"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.source forKey:@"source"];
    [coder encodeObject:self.target forKey:@"target"];
}

-(id)copyWithZone:(NSZone *)zone {
    TFAction * copy = [[[self class] alloc] init];
    copy.source = self.source;
    copy.target = self.target;
    
    return copy;
}

#pragma mark - Protocols

-(void) startAction{
    NSLog(@"don't call startAction on THAction");
}

-(void) finishAction{
    NSLog(@"don't call finishAction on THAction");
}

-(NSMutableArray*) invokableMethodList{
    
    return [NSMutableArray arrayWithObject:[TFMethod methodWithName:@"startAction"]];
}

#pragma mark - Methods

-(BOOL) isEqualToAction:(TFAction*)action{
    NSLog(@"don't call isEqualToAction on THAction");
    return YES;
}

-(NSString*) description{
    return [NSString stringWithFormat:@"trigger the action"];
}

-(void) dealloc{
    
}
@end
