//
//  THiPhone.m
//  TangoHapps
//
//  Created by Aaron Perez Martin on 19/02/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THiPhoneScreenItem.h"

#import "THiPhoneEditableObject.h"

#import "THLabelEditableObject.h"

#import "THLabelPaletteItem.h"
#import "THLabelEditableObject.h"
#import "THiPhoneEditableObject.h"


@implementation THiPhoneScreenItem

- (CGPoint)dropAt:(CGPoint)location withSize:(CGSize)objSize{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    //THLabelEditableObject * ilabel = [[THLabelEditableObject alloc] init];
    
    location = [TFHelper ConvertToCocos2dView:location];
    
    //CGSize objSize = CGSizeMake(123, 123);
    
    CGPoint topLeftPoint = CGPointMake(location.x - objSize.width/2, location.y - (objSize.height + 20));
    CGPoint topRightPoint = CGPointMake(location.x + objSize.width/2, location.y - (objSize.height + 20));
    CGPoint bottonLeftPoint = CGPointMake(location.x - objSize.width/2, location.y + objSize.height);
    CGPoint bottonRightPoint = CGPointMake((location.x + objSize.width/2), (location.y + objSize.height));
    
    Boolean A,B,C,D = FALSE;
    
    CGPoint newPosition = location;
    CGPoint originPoint = project.iPhone.currentView.boundingBox.origin;
    
    //for testing
//    CGPoint finalPoint = CGPointMake(originPoint.x + project.iPhone.currentView.boundingBox.size.width,
//                                     originPoint.y + project.iPhone.currentView.boundingBox.size.height);
//    
    CGRect iPhoneScreen = CGRectMake(originPoint.x, originPoint.y,
                                     project.iPhone.currentView.boundingBox.size.width,
                                     project.iPhone.currentView.boundingBox.size.height);
    
    if(CGRectContainsPoint(iPhoneScreen, topLeftPoint)) {
        A = TRUE;
    }
    else {
        printf(" !A");
        A = FALSE;
    }
    
    if (CGRectContainsPoint(iPhoneScreen, topRightPoint)) {
        B = TRUE;
    }
    else {
        printf(" !B");
        B = FALSE;
    }
    
    if (CGRectContainsPoint(iPhoneScreen, bottonLeftPoint)) {
        C = TRUE;
    }
    else {
        printf(" !C");
        C = FALSE;
    }
    
    if (CGRectContainsPoint(iPhoneScreen, bottonRightPoint)) {
        D = TRUE;
    }
    else {
        printf(" !D");
        D = FALSE;
    }
    
    printf("\n");
    
    //according to which point of label square is out of currentView bounds, we change the position properly
    if(!A && !B && !C && D){// operations +x +y
        newPosition.x += objSize.width/2;
        newPosition.y += objSize.height/2;
        
    } else if (!A && !B && C && !D){ // operations -x +y
        newPosition.x -= objSize.width/2;
        newPosition.y += objSize.height/2;
        
    } else if (!A && B && !C && D){ // operations +x
        newPosition.x += objSize.width/2;
        
    } else if (A && !B && C && !D){ // operations -x
        newPosition.x -= objSize.width/2;
        
    } else if (!A && B && !C && !D){ // operations +x -y
        newPosition.x += objSize.width/2;
        newPosition.y -= objSize.height/2;
        
    } else if (A && !B && !C && !D){ // operations -x -y
        newPosition.x -= objSize.width/2;
        newPosition.y -= objSize.height/2;
        
    } else if (!A && !B && C && D){ // operation + y
        newPosition.y += objSize.height/2;
        
    } else if (A && B && !C && !D){ // operation - y
        newPosition.y -= objSize.height/2;
        
    }
    
    //update object before redraw
//    ilabel.position = newPosition;
//    [project addiPhoneObject:ilabel];
    
    return newPosition;
    
}

@end