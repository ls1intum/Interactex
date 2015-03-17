//
//  THSignalDeviationEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 15/03/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@interface THSignalDeviationEditable : THProgrammingElementEditable

@property (nonatomic) float deviation;

-(void) addSample:(float)value;

@end
