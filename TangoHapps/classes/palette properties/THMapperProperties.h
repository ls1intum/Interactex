//
//  THMapperProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THMapperProperties : THEditableObjectProperties

@property (weak, nonatomic) IBOutlet UITextField *minText;
@property (weak, nonatomic) IBOutlet UITextField *maxText;
@property (weak, nonatomic) IBOutlet UITextField *aText;
@property (weak, nonatomic) IBOutlet UITextField *bText;

- (IBAction)minChanged:(id)sender;
- (IBAction)maxChanged:(id)sender;
- (IBAction)aChanged:(id)sender;
- (IBAction)bChanged:(id)sender;

@end
