//
//  TFProjectSelectionViewController.h
//  TangoFramework
//
//  Created by Juan Haladjian on 10/17/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THGridView.h"

@interface THProjectSelectionViewController : UIViewController <THGridViewDataSource>
{
    UILabel * _titleLabel;
}

-(void) reloadData;

@end
