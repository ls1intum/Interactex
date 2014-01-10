//
//  THClientI2CComponentMessage.h
//  TangoHapps
//
//  Created by Juan Haladjian on 09/01/14.
//  Copyright (c) 2014 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kI2CComponentMessageTypeWrite,
    kI2CComponentMessageTypeStartReading
}THI2CComponentMessageType;

@interface THI2CMessage : NSObject

@property (nonatomic) THI2CComponentMessageType type;
@property (nonatomic) NSInteger reg;
@property (nonatomic) NSData* bytes;
@property (nonatomic) NSInteger readSize;

@end
