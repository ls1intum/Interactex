//
//  THMeanExtractor.h
//  TangoHapps
//
//  Created by Juan Haladjian on 09/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProgrammingElement.h"

@interface THMeanExtractor : THProgrammingElement
{
    
}

@property (nonatomic) float mean;
@property(nonatomic, strong) NSMutableArray * data;

-(void) addSample:(float) sample;

@end
