//
//  THBoolValueEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/5/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "TFEditableObject.h"
#import "THProgrammingElementEditable.h"

@interface THBoolValueEditable : THProgrammingElementEditable {
    BOOL _displayedValue;
    CCLabelTTF * _label;
}

@property (nonatomic) BOOL value;

@end
