//
//  THTestsHelper.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/30/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THTestsHelper : NSObject
{
    
}

+(THCustomProject*) emptyProject;
+(void) startWithEditor;
+(void) startSimulation;
+(void) stopSimulation;
+(void) stop;

+(TFMethodInvokeAction*) registerActionForObject:(TFEditableObject*) object target:(TFEditableObject*) target event:(NSString*) eventName method:(NSString*) methodName;

@end
