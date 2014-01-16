/*
GMPPinsController.h
iGMP

Created by Juan Haladjian on 28/06/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/Foundation.h>
#import "GMP.h"

#define GMPMaxNumPins 128

@class GMPPinsController;
@class GMPI2CComponent;
@class GMPI2CRegister;
@class GMP;
@class BLEService;

@protocol GMPControllerPinsDelegate <NSObject>


-(void) pinsControllerDidUpdateDigitalPins:(GMPPinsController*) firmataController;
-(void) pinsControllerDidUpdateAnalogPins:(GMPPinsController*) firmataController;
-(void) pinsControllerDidUpdateI2CComponents:(GMPPinsController*) firmataController;

-(void) pinsController:(GMPPinsController*) pinsController didUpdateFirmwareName:(NSString*) firmwareName;

@end

@interface GMPPinsController : NSObject <GMPControllerDelegate> {
    
    GMPPinCapability pinCapabilities[GMPMaxNumPins];
    
    NSTimer * timer;
}

@property (nonatomic, strong) NSMutableArray * digitalPins;
@property (nonatomic, strong) NSMutableArray * analogPins;
@property (nonatomic, strong) NSMutableArray * i2cComponents;

@property (nonatomic, strong) GMP * gmpController;
@property (nonatomic, weak) id<GMPControllerPinsDelegate> delegate;

@property (nonatomic, strong) NSString* firmwareName;

@property (nonatomic, readonly) NSInteger numPins;
@property (nonatomic, readonly) NSInteger numDigitalPins;
@property (nonatomic, readonly) NSInteger numAnalogPins;

-(void) reset;

//stop reporting
-(void) stopReportingAnalogPins;
-(void) stopReportingI2CComponents;
-(void) stopReportingI2CComponent:(GMPI2CComponent*) component;

//i2c
-(void) addI2CComponent:(GMPI2CComponent*) component;
-(void) removeI2CComponent:(GMPI2CComponent*) component;
-(void) addI2CRegister:(GMPI2CRegister*) reg toComponent:(GMPI2CComponent*) component;
-(void) removeI2CRegister:(GMPI2CRegister*) reg fromComponent:(GMPI2CComponent*) component;

@end
