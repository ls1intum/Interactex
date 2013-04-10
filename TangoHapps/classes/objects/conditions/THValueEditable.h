//
//  THValueEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/16/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@interface THValueEditable : THProgrammingElementEditable
{
    float _displayedValue;
    CCLabelTTF * _label;
}

@property (nonatomic) float value;

@end
