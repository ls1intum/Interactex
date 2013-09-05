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
}

@property (nonatomic) BOOL showClotheSection;
@property (nonatomic) BOOL showHardwareSection;
@property (nonatomic) BOOL showSoftwareSection;
@property (nonatomic) BOOL showProgrammingSection;
@property (nonatomic, strong) NSMutableArray * sections;

-(void) reloadPalettes;

@end
