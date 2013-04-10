//
//  TFPaletteDataSource.h
//  TangoFramework
//
//  Created by Juan Haladjian on 11/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THPaletteDataSource : NSObject <TFPaleteViewControllerDataSource>
{
    NSMutableArray * _sections;
}

-(void) populatePalettes;

@end
