//
//  THWindow.h
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProgrammingElement.h"

@interface THWindow : THProgrammingElement


-(void) start;
-(void) stop;
-(void) addSample:(id) sample;

@property(nonatomic,readonly) BOOL started;
@property(nonatomic) NSInteger windowSize;
@property(nonatomic) NSInteger overlap;
@property(nonatomic, strong) NSMutableArray * data;

@end
