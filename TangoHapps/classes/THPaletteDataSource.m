//
//  TFPaletteDataSource.m
//  TangoFramework
//
//  Created by Juan Haladjian on 11/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THPaletteDataSource.h"

#import "THLedPaletteItem.h"
#import "THButtonPaletteItem.h"
#import "THBuzzerPaletteItem.h"
#import "THCompassPaletteItem.h"
#import "THLightSensorPaletteItem.h"
#import "THPotentiometerPaletteItem.h"
#import "THSwitchPaletteItem.h"
#import "THThreeColorLedPaletteItem.h"
#import "THVibrationBoardPaletteItem.h"

#import "THiPhonePaletteItem.h"
#import "THiPhoneButtonPaletteItem.h"
#import "THLabelPaletteItem.h"
#import "THiSwitchPaletteItem.h"
#import "THMusicPlayerPaletteItem.h"
#import "THTouchpadPaletteItem.h"
#import "THImageViewPaletteItem.h"
#import "THSliderPaletteItem.h"
#import "THContactBookPaletteItem.h"

#import "THClothePaletteItem.h"

#import "THComparatorPaletteItem.h"
#import "THGrouperPaletteItem.h"
#import "THValuePaletteItem.h"
#import "THMapperPaletteItem.h"
#import "THProjectViewController.h"
#import "THTimerPaletteItem.h"
#import "THSoundPaletteItem.h"
#import "TFTabbarViewController.h"

@implementation THPaletteDataSource

-(id) init{
    self = [super init];
    if(self){
        _sections = [NSMutableArray array];
        [self populatePalettes];
    }
    return self;
}

-(TFPalette*) emptyPalette{
    
    THDirector * director = [THDirector sharedDirector];
    THProjectViewController * projectController = director.projectController;
    TFTabbarViewController * tabController = projectController.tabController;
    return [tabController.paletteController emptyPalette];
}

-(void) addPalette:(TFPalette*) palette withTitle:(NSString*) title{
    TFTabbarSection * section = [TFTabbarSection sectionWithTitle:title];
    [section addPalette:palette];
    [_sections addObject:section];
}

-(void)addClothesPalette {
    TFPalette *palette = [self emptyPalette];
    
    [palette addDragablePaletteItem:[[THClothePaletteItem alloc] initWithName:@"tshirt"]];
    
    [self addPalette:palette withTitle:@"Clothing"];
}

-(void)addSoftwarePalette {
    TFPalette *palette = [self emptyPalette];
    
    [palette addDragablePaletteItem:[[THiPhonePaletteItem alloc] initWithName:@"iphone"]];
    [palette addDragablePaletteItem:[[THiPhoneButtonPaletteItem alloc] initWithName:@"ibutton"]];
    [palette addDragablePaletteItem:[[THLabelPaletteItem alloc] initWithName:@"label"]];
    [palette addDragablePaletteItem:[[THiSwitchPaletteItem alloc] initWithName:@"iswitch"]];
    [palette addDragablePaletteItem:[[THSliderPaletteItem alloc] initWithName:@"slider"]];
    [palette addDragablePaletteItem:[[THTouchpadPaletteItem alloc] initWithName:@"touchpad"]];
    [palette addDragablePaletteItem:[[THMusicPlayerPaletteItem alloc] initWithName:@"musicplayer"]];
    [palette addDragablePaletteItem:[[THImageViewPaletteItem alloc] initWithName:@"imageview"]];
    [palette addDragablePaletteItem:[[THContactBookPaletteItem alloc] initWithName:@"contactBook"]];
    
    [self addPalette:palette withTitle:@"UI Elements"];
}

-(void)addHardwarePalette {
    TFPalette *palette = [self emptyPalette];
    
    [palette addDragablePaletteItem:[[THLedPaletteItem alloc] initWithName:@"led"]];
    [palette addDragablePaletteItem:[[THButtonPaletteItem alloc] initWithName:@"button"]];
    [palette addDragablePaletteItem:[[THSwitchPaletteItem alloc] initWithName:@"switch"]];
    [palette addDragablePaletteItem:[[THBuzzerPaletteItem alloc] initWithName:@"buzzer"]];
    [palette addDragablePaletteItem:[[THCompassPaletteItem alloc] initWithName:@"compass"]];
    [palette addDragablePaletteItem:[[THLightSensorPaletteItem alloc] initWithName:@"lightSensor"]];
    [palette addDragablePaletteItem:[[THPotentiometerPaletteItem alloc] initWithName:@"potentiometer"]];
    [palette addDragablePaletteItem:[[THThreeColorLedPaletteItem alloc] initWithName:@"threeColorLed"]];
    [palette addDragablePaletteItem:[[THVibrationBoardPaletteItem alloc] initWithName:@"vibeBoard"]];
    
    [self addPalette:palette withTitle:@"Hardware"];
}

-(void)addProgrammingPalette {
    TFPalette *palette = [self emptyPalette];
    
    [palette addDragablePaletteItem:[[THComparatorPaletteItem alloc] initWithName:@"comparator"]];
    [palette addDragablePaletteItem:[[THGrouperPaletteItem alloc] initWithName:@"grouper"]];
    [palette addDragablePaletteItem:[[THValuePaletteItem alloc] initWithName:@"value"]];
    [palette addDragablePaletteItem:[[THMapperPaletteItem alloc] initWithName:@"mapper"]];
    [palette addDragablePaletteItem:[[THTimerPaletteItem alloc] initWithName:@"timer"]];
    [palette addDragablePaletteItem:[[THSoundPaletteItem alloc] initWithName:@"sound"]];
    
    [self addPalette:palette withTitle:@"Programming"];
}

-(void) populatePalettes{
    [self addClothesPalette];
    [self addHardwarePalette];
    [self addSoftwarePalette];
    [self addProgrammingPalette];
}

-(NSArray*) paletteSections{
    return _sections;
}

@end
