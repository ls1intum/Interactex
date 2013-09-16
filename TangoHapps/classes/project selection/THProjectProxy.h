//
//  TFProjectProxy.h
//  Tango
//
//  Created by Juan Haladjian on 12/1/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THProjectProxy : NSObject <NSCoding, NSCopying>

@property (nonatomic) NSString * name;
@property (nonatomic) UIImage * image;
@property (nonatomic) NSDate * date;

+(id) proxyWithName:(NSString*) name;
-(id) initWithName:(NSString*) name;

@end
