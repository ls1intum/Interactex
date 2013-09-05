//
//  THStringValueEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFEditableObject.h"
#import "THProgrammingElementEditable.h"

@interface THStringValueEditable : THProgrammingElementEditable{
    
    NSString * _displayedValue;
    CCLabelTTF * _label;
}

@property (nonatomic) NSString * value;

@end
