//
//  THClientSceneDraggableCell.m
//  TangoHapps
//
//  Created by Juan Haladjian on 8/18/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THClientSceneDraggableCell.h"

@implementation THClientSceneDraggableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        /*
        CGRect textFieldFrame = CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        self.textField = [[UITextField alloc] initWithFrame:textFieldFrame];*/
    }
    return self;
}

@end
