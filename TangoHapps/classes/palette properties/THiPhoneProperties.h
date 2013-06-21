//
//  THiPhoneProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "TFEditableObjectProperties.h"

@interface THiPhoneProperties : TFEditableObjectProperties

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
- (IBAction)typeSegmentChanged:(UISegmentedControl*)sender;

@end
