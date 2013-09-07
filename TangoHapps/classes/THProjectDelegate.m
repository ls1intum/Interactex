//
//  THProjectDelegate.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import "THProjectDelegate.h"
#import "THCustomProject.h"
#import "THCustomEditor.h"
#import "THCustomSimulator.h"
#import "THServerController.h"

@implementation THProjectDelegate

-(id) init{
    self = [super init];
    if(self){
    }
    return self;
}

#pragma Mark - Project Controller Delegate

-(TFProject*) newCustomProject{
    return [THCustomProject newProject];
}

-(TFProject*) newCustomProjectNamed:(NSString*) name {
    return [THCustomProject projectNamed:name];
}

-(TFEditor*) customEditor{
    
    return [THCustomEditor node];
}

-(TFSimulator*) customSimulator{
    return [THCustomSimulator node];
}

-(void) willStopEditingProject:(TFProject*) project{
    
}
-(void) willStartEditingProject:(TFProject*) project{
    
}

/*
#pragma Mark - Grid View Delegate

-(CGSize) gridItemSizeForGridView:(THClientGridView*) view{
    return CGSizeMake(329,241);
}

-(CGPoint) gridItemPaddingForGridView:(THClientGridView*) view{
    return CGPointMake(10,2);
}

-(CGPoint) gridPaddingForGridView:(THClientGridView*) view{
    return CGPointMake(5,-5);
}
*/
@end
