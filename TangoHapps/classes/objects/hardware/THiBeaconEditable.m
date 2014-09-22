//
//  THiBeaconEditable.m
//  TangoHapps
//
//  Created by Guven Candogan on 13/08/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import "THiBeaconEditable.h"
#import <THiBeacon.h>
#import "THiBeaconProperties.h"

@implementation THiBeaconEditable

- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)mvinor{
    return self;
}

-(void) loadiBeacon{
    self.sprite = [CCSprite spriteWithFile:@"iBeacon.png"];
    [self addChild:self.sprite];
    
    self.acceptsConnections = YES;
}

-(void) loadLabels{
    
    THiBeacon * ibeacon = (THiBeacon *) self.simulableObject;
  //  self.uuid = ibeacon.beaconRegion.
    
}

-(id) init{
    self = [super init];
    if(self){
        self.simulableObject = [[THiBeacon alloc] init];
        
        self.type = kHardwareTypeFlexSensor;
        
        [self loadLabels];
        [self loadiBeacon];
        [self loadMethods];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        
        self.name = [decoder decodeObjectForKey:@"name"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.beaconRegion = [decoder decodeObjectForKey:@"beaconRegion"];
        
        [self loadLabels];
        [self loadiBeacon];
        [self loadMethods];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.name forKey:@"name"];
//    [coder encodeObject:self.majorValue forKey:@"majorValue"];
  //  [coder encodeObject:self.minorValue forKey:@"minorValue"];
    [coder encodeObject:self.beaconRegion forKey:@"beaconRegion"];
}


-(void) update{
}

-(id)copyWithZone:(NSZone *)zone{
    THiBeacon * copy = [super copyWithZone:zone];
    return copy;
}

-(void) loadMethods{
}

-(NSString*) description{
    return @"iBeacon";
}

-(void) didStartSimulating{
}

-(NSArray*)propertyControllers {
    
    NSMutableArray *controllers = [NSMutableArray array];
    
    [controllers addObject:[THiBeaconProperties properties]];
    [controllers addObjectsFromArray:[super propertyControllers]];
    
    return controllers;
}

-(NSString*) name{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    return ibeacon.name;
}

-(void) setName:(NSString *)name{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    ibeacon.name = name;
}

-(NSUUID*) uuid{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    return ibeacon.uuid;
}
-(void) setUuid:(NSUUID *)uuid{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    ibeacon.uuid=uuid;
}

-(CLBeaconMajorValue*) majorValue{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    return ibeacon.majorValue;
}

-(void) setMajorValue:(CLBeaconMajorValue *)majorValue{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    ibeacon.majorValue = majorValue;
}

-(CLBeaconMinorValue*) minorValue{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    return ibeacon.minorValue;
}

-(void) setMinorValue:(CLBeaconMinorValue *)minorValue{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    ibeacon.minorValue=minorValue;
}

-(CLBeaconRegion*) beaconRegion{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    return ibeacon.beaconRegion;
}

-(void) setBeaconRegion:(CLBeaconRegion *)beaconRegion{
    THiBeacon * ibeacon = (THiBeacon*) self.simulableObject;
    ibeacon.beaconRegion=beaconRegion;
}
@end
