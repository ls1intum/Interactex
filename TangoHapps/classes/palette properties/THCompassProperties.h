//
//  THCompassProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THCompassProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeControl;
- (IBAction)typeControlChanged:(id)sender;

@end
