/*
IFPinsController.h
iFirmata

Created by Juan Haladjian on 28/06/2013.

iFirmata is an App to control an Arduino board over Bluetooth 4.0. iFirmata uses the Firmata protocol: www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/Foundation.h>
#import "IFPin.h"
#import "IFFirmata.h"

typedef struct{
    uint64_t supportedModes;
    uint8_t analogChannel;
} PinInfo;

#define IFPinInfoBufSize 128

@class IFPinsController;
@class IFI2CComponent;
@class IFI2CRegister;
@class IFFirmata;
@class BLEService;

@protocol IFFirmataControllerPinsDelegate <NSObject>

-(void) firmataDidUpdateDigitalPins:(IFPinsController*) firmataController;
-(void) firmataDidUpdateAnalogPins:(IFPinsController*) firmataController;
-(void) firmataDidUpdateI2CComponents:(IFPinsController*) firmataController;

-(void) firmata:(IFPinsController*) firmataController didUpdateTitle:(NSString*) title;

@end

@interface IFPinsController : NSObject <IFFirmataControllerDelegate> {
    
    PinInfo pinInfo[IFPinInfoBufSize];
    
    NSInteger numDigitalPins;
    NSInteger numAnalogPins;
    NSInteger numPins;
}

@property (nonatomic, strong) NSMutableArray * digitalPins;
@property (nonatomic, strong) NSMutableArray * analogPins;
@property (nonatomic, strong) NSMutableArray * i2cComponents;

//@property (nonatomic, weak) BLEService * bleService;
@property (nonatomic, strong) IFFirmata * firmataController;
@property (nonatomic, weak) id<IFFirmataControllerPinsDelegate> delegate;

@property (nonatomic, copy) NSString* firmataName;

-(void) reset;

//stop reporting
-(void) stopReportingAnalogPins;
-(void) stopReportingI2CComponents;
-(void) stopReportingI2CComponent:(IFI2CComponent*) component;

//i2c
-(void) addI2CComponent:(IFI2CComponent*) component;
-(void) removeI2CComponent:(IFI2CComponent*) component;
-(void) addI2CRegister:(IFI2CRegister*) reg toComponent:(IFI2CComponent*) component;
-(void) removeI2CRegister:(IFI2CRegister*) reg fromComponent:(IFI2CComponent*) component;

@end
