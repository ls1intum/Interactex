//
//  THiPhone.h
//  TangoHapps
//
//  Created by Aaron Perez Martin on 19/02/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THiPhoneEditableObject.h"
#import "THPaletteItem.h"

@interface THiPhoneScreenItem : THPaletteItem

    -(CGPoint)dropAt:(CGPoint)location withSize:(CGSize)objSize;

@end