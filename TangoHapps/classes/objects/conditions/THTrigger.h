//
//  THTrigger.h
//  TangoHapps
//
//  Created by Juan Haladjian on 2/21/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

@interface THTrigger : TFSimulableObject

@property (nonatomic) NSMutableArray * actions;

-(void) addAction:(TFAction *) action;
-(void) removeAction:(TFAction*) action;

@end
