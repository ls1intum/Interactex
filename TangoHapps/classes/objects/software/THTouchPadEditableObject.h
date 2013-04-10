//
//  THTouchPadEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/22/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhoneControlEditableObject.h"

@class THViewableProperties;

@interface THTouchPadEditableObject : THViewEditableObject {
}

@property (nonatomic) float dx;
@property (nonatomic) float dy;

@property (nonatomic) float xMultiplier;
@property (nonatomic) float yMultiplier;

@end
