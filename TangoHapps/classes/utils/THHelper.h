//
//  THHelper.h
//  TangoHapps3
//
//  Created by Juan Haladjian on 12/17/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THHelper : NSObject


+(ccColor3B) color3BFromUIColor:(UIColor*) color;
+(UIColor*) uicolorFromColor3B:(ccColor3B) color;

@end
