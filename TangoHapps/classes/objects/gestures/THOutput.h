//
//  THOutput.h
//  TangoHapps
//
//  Created by Timm Beckmann on 10.06.14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "TFSimulableObject.h"

@interface THOutput : TFSimulableObject

@property (nonatomic) NSInteger value;
-(void) setOutput:(NSObject*) object;
-(void) setPropertyType:(TFDataType) type;

@end
