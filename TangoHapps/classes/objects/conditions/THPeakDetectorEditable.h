//
//  THPeakDetectorEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 01/02/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THProgrammingElementEditable.h"

@interface THPeakDetectorEditable : THProgrammingElementEditable

@property (nonatomic, readonly) NSInteger peakIdx;
@property (nonatomic, readonly) float peak;

-(void) addSample:(float)value;

@end
