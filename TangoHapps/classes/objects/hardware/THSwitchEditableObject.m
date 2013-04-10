//
//  THSwitchEditableObject.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSwitchEditableObject.h"
#import "THSwitch.h"
#import "THElementPinEditable.h"
#import "THElementPin.h"
#import "THResistorExtension.h"

@implementation THSwitchEditableObject


-(id) init{
    self = [super init];
    if(self){
    }
    return self;
}

-(THElementPinEditable*) plusPin{
    return [self.pins objectAtIndex:0];
}

-(THElementPinEditable*) minusPin{
    return [self.pins objectAtIndex:1];
}

-(THElementPinEditable*) digitalPin{
    return [self.pins objectAtIndex:2];
}

@end
