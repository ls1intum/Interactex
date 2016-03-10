//
//  THMeanExtractorEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 09/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@interface THMeanExtractorEditable : THProgrammingElementEditable

@property (nonatomic) float mean;

-(void) addSample:(float)value;

@end
