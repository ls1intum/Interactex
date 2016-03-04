//
//  THWindowEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 03/03/16.
//  Copyright © 2016 Technische Universität München. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@interface THWindowEditable : THProgrammingElementEditable


-(void) start;
-(void) stop;
-(void) addSample:(id) sample;

@property(nonatomic, readonly) BOOL started;
@property(nonatomic, strong) NSMutableArray * data;
@property(nonatomic) NSInteger windowSize;
@property(nonatomic) NSInteger overlap;
@end
