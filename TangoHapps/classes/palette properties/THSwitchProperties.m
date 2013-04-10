//
//  THSwitchProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 10/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THSwitchProperties.h"

static THSwitchProperties * _sharedInstance = nil;

@implementation THSwitchProperties

+(id)sharedInstance
{
    if(_sharedInstance == nil)
        _sharedInstance = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return _sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)title
{
    return @"Switch";
}

-(void) reloadState{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
