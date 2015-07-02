//
//  THCustomComponent.h
//  TangoHapps
//
//  Created by Juan Haladjian on 23/06/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THProgrammingElement.h"

@interface THCustomComponent : THProgrammingElement
{
    
}

@property (nonatomic) NSString * name;
@property (nonatomic) NSString * code;
@property (nonatomic, readonly) id result;

-(void) execute:(id) param;

@end
