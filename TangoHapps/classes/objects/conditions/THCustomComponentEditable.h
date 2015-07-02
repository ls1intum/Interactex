//
//  THCustomComponentEditable.h
//  TangoHapps
//
//  Created by Juan Haladjian on 23/06/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import "THProgrammingElementEditable.h"

@interface THCustomComponentEditable : THProgrammingElementEditable


@property (nonatomic) NSString * name;
@property (nonatomic) NSString * code;
@property (nonatomic) id result;

-(void) execute:(id) param;

@end
