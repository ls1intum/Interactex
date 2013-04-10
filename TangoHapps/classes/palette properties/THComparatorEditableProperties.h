//
//  THConditionEditableProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THComparatorEditableProperties : TFEditableObjectProperties
{
    BOOL button1Down;
    BOOL button2Down;
    
    TFConnectionLine * _connection1;
    TFConnectionLine * _connection2;
}

@property (weak, nonatomic) IBOutlet UILabel *operatorTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *object1Button;
@property (weak, nonatomic) IBOutlet UIButton *object2Button;
@property (weak, nonatomic) IBOutlet UISegmentedControl *operatorTypeControl;

- (IBAction)button1Up:(id)sender;
- (IBAction)button1Down:(id)sender;
- (IBAction)button2Up:(id)sender;
- (IBAction)button2Down:(id)sender;
- (IBAction)operationTypeChanged:(id)sender;


@end
