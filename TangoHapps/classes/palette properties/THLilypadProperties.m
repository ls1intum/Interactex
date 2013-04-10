//
//  THLilypadProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 11/14/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THLilypadProperties.h"
#import "THBoardPinEditable.h"
#import "THLilypadEditable.h"
#import "THLilypadPropertiesPinView.h"
#import "THCustomEditor.h"
#import "THCustomProject.h"

@implementation THLilypadProperties

float const kLilypadPropertiesContainerHeight = 40;
float const kLilypadPropertiesPadding = 10;
float const kLilypadPropertiesMaxHeight = 400;
float const kLilypadPropertiesMinHeight = 300;


-(NSString *)title {
    return @"Lilypad";
}

-(void) addPinViews{
    _currentY = kLilypadPropertiesPadding;
    THCustomProject * project = (THCustomProject*) [TFDirector sharedDirector].currentProject;
    
    for (THBoardPinEditable * pin in project.lilypad.pins) {
        if(pin.attachedPins.count > 0 && pin.type != kPintypeMinus && pin.type != kPintypePlus){
            CGRect frame = CGRectMake(kLilypadPropertiesPadding, _currentY, self.containerView.frame.size.width - 20, kLilypadPropertiesContainerHeight);
            
            THLilypadPropertiesPinView * pinView = [[THLilypadPropertiesPinView alloc] initWithFrame:frame];
            pinView.pin = pin;
            [self.containerView addSubview:pinView];
            [_pinViews addObject:pinView];
            
            _currentY += kLilypadPropertiesContainerHeight + kLilypadPropertyInnerPadding;
            
            CGRect currentFrame = self.containerView.frame;
            if(_currentY > currentFrame.origin.y + currentFrame.size.height){
                
                self.containerView.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, _currentY);
            }
        }
    }
}

-(void) removePinViews{
    for (THLilypadPropertiesPinView * pinView in _pinViews) {
        [pinView removeFromSuperview];
    }
    [_pinViews removeAllObjects];
}

-(void) reloadState{
    [self removePinViews];
    [self addPinViews];
}

-(void) handleConnectionChanged{
    THDirector * director = [THDirector sharedDirector];
    THCustomEditor * editor = (THCustomEditor*) director.currentLayer;
    
    if(editor.isLilypadMode){
       [self reloadState]; 
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConnectionChanged) name:kNotificationConnectionMade object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConnectionChanged) name:kNotificationObjectRemoved object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 10;
    _pinViews = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    self.containerView = nil;
    [super viewDidUnload];
}
@end
