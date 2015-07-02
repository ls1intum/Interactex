//
//  THCustomComponent.m
//  TangoHapps
//
//  Created by Juan Haladjian on 23/06/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THCustomComponent.h"
#import "Interactex-Swift.h"
#import "THAccelerometerData.h"
@import JavaScriptCore;

@implementation THCustomComponent


-(id) init{
    self = [super init];
    if(self){
        [self loadCustomComponent];
        
    }
    return self;
}

-(void) loadCustomComponent{
    TFMethod * method = [TFMethod methodWithName:@"execute"];
    method.numParams = 1;
    method.firstParamType = kDataTypeAny;
    
    self.methods = [NSMutableArray arrayWithObjects:method,nil];
    
    TFEvent * event = [TFEvent eventNamed:kEventExecutionFinished];
    TFProperty * property = [[TFProperty alloc] initWithName:@"result" andType:kDataTypeAny];
    
    event.param1 = [TFPropertyInvocation invocationWithProperty:property target:self];
    self.events = [NSMutableArray arrayWithObjects:event,nil];
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        self.name = [decoder decodeObjectForKey:@"name"];
        self.code = [decoder decodeObjectForKey:@"code"];
        
        [self loadCustomComponent];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.code forKey:@"code"];
}

-(id)copyWithZone:(NSZone *)zone {
    THCustomComponent * copy = [super copyWithZone:zone];
    copy.name = self.name;
    copy.code = self.code;
    return copy;
}

-(NSString*) expandJavascriptWithInputFrom:(id) param{
    if([param isKindOfClass:[NSArray class]]){
        NSString * string = @"var data = [";
        
        NSArray * data = param;
        for (THAccelerometerData * acceleration in data) {
            string = [string stringByAppendingFormat:@"%f,",acceleration.y];
        }
        
        return [string stringByAppendingFormat:@"];\n%@",self.code];
    }
    
    return self.code;
}

-(NSString*) expandJSWithFunctionCall:(NSString*) code{
    
    return [NSString stringWithFormat:@"function myFunction(data){%@} myFunction(data);",code];
}

-(void) execute:(id) param{
    
    NSString * newCode = [self expandJavascriptWithInputFrom:param];
    //newCode = [self expandJSWithFunctionCall:newCode];
    
    THJavascriptRunner * javascriptRunner = [THJavascriptRunner sharedInstance];

    JSValue * result = [javascriptRunner execute:newCode];
    _result = result.description;
    
    [super triggerEventNamed:kEventExecutionFinished];
}


-(NSString*) description{
    return @"customComponent";
}

@end
