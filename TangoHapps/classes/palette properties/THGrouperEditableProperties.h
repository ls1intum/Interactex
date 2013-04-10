//
//  THGrouperEditableProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THGrouperEditableProperties : TFEditableObjectProperties
{
    BOOL button1Down;
    BOOL button2Down;
    
    TFConnectionLine * connection1;
    TFConnectionLine * connection2;
}

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *obj2Button;
@property (weak, nonatomic) IBOutlet UIButton *obj1Button;
@property (weak, nonatomic) IBOutlet UISegmentedControl *grouperTypeControl;


- (IBAction)button1Up:(id)sender;
- (IBAction)button1Down:(id)sender;
- (IBAction)button2Up:(id)sender;
- (IBAction)button2Down:(id)sender;

- (IBAction)grouperTypeChanged:(id)sender;

@end
