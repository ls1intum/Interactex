//
//  THiPhone.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/9/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THiPhone.h"
#import "THView.h"

@implementation THiPhone

-(void) loadiPhone{
    
    TFMethod * method = [TFMethod methodWithName:@"makeEmergencyCall"];
    self.methods = [NSMutableArray arrayWithObject:method];
}

-(id) init{
    self = [super init];
    if(self){
        
        [self loadiPhone];
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    [self loadiPhone];
    
    self.position = [decoder decodeCGPointForKey:@"position"];
    self.type = [decoder decodeIntegerForKey:@"type"];
    _currentView = [decoder decodeObjectForKey:@"currentView"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeCGPoint:self.position forKey:@"position"];
    [coder encodeInteger:self.type forKey:@"type"];
    [coder encodeObject:_currentView forKey:@"currentView"];
}

-(id)copyWithZone:(NSZone *)zone {
    THiPhone * copy = [super copyWithZone:zone];
  
    return copy;
}

#pragma mark - Methods

-(void) setVisible:(BOOL)visible{
    self.currentView.visible = visible;
    [super setVisible:visible];
}

-(void) removeFromSuperview{
    [_currentView removeFromSuperview];
}

-(void) addToView:(UIView*) aView{
    [_currentView addToView:aView];
}

-(void) setCurrentView:(THView *)currentView{
    UIView * superview = _currentView.superview.view;
    [_currentView removeFromSuperview];
    _currentView = currentView;
    if(currentView != nil){
        [currentView addToView:superview];
    }
}

-(void) makeEmergencyCall{
    //NSString *phoneNumber = [@"tel://" stringByAppendingString:@"015777795645"];//Juan
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"015112617548"];//Katharina
    NSURL * url = [NSURL URLWithString:phoneNumber];
    
    //CanOpenUrl always returning NO after iOS 6
    /*
    if([[UIApplication sharedApplication] canOpenURL:url]){
        NSLog(@"Call cannot be made. Does your device support making calls?");
    } else {
        [[UIApplication sharedApplication] openURL:url];
        NSLog(@"making emergency call");
    }*/
    
    [[UIApplication sharedApplication] openURL:url];
}

-(NSString*) description{
    return @"iphone";
}

-(void) prepareToDie{

    _currentView = nil;
    [super prepareToDie];
}
@end
