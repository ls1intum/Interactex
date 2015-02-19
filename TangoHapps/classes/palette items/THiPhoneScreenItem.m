//
//  THiPhone.m
//  TangoHapps
//
//  Created by Aaron Perez Martin on 19/02/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THiPhoneScreenItem.h"
#import "THLabelEditableObject.h"
#import "THiPhoneEditableObject.h"


@implementation THiPhoneScreenItem

- (CGPoint)dropAt:(CGPoint)location withSize:(CGSize)objSize{
    THProject * project = (THProject*) [THDirector sharedDirector].currentProject;
    
    location = [TFHelper ConvertToCocos2dView:location];
    
    CGPoint topLeftPoint = CGPointMake(location.x - objSize.width/2, location.y - (objSize.height+ 20));
    CGPoint topRightPoint = CGPointMake(location.x + objSize.width/2, location.y - (objSize.height+ 20));
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
    
    CGFloat minX = originPoint.x;
    CGFloat maxX = originPoint.x + iPhoneScreen.size.width;
    CGFloat minY = originPoint.y + 45;
    CGFloat maxY = originPoint.y + 45 + iPhoneScreen.size.height;
    
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
        newPosition.x = minX + objSize.width/2;
        newPosition.y = minY + objSize.height/2;
        
    } else if (!A && !B && C && !D){ // operations -x +y
        newPosition.x = maxX - objSize.width/2;
        newPosition.y = minY + objSize.height/2;
        
    } else if (!A && B && !C && D){ // operations +x
        newPosition.x = minX + objSize.width/2;
        
    } else if (A && !B && C && !D){ // operations -x
        newPosition.x = maxX - objSize.width/2;
        
    } else if (!A && B && !C && !D){ // operations +x -y
        newPosition.x = minX + objSize.width/2;
        newPosition.y = maxY - objSize.height/2;
        
    } else if (A && !B && !C && !D){ // operations -x -y
        newPosition.x = maxX - objSize.width/2;
        newPosition.y = maxY - objSize.height/2;
        
    } else if (!A && !B && C && D){ // operation + y
        newPosition.y = minY + objSize.height/2;
        
    } else if (A && B && !C && !D){ // operation - y
        newPosition.y = maxY - objSize.height/2;
        
    } else if (!A && !B && !C && !D){
        newPosition.x = minX + objSize.width/2;
        newPosition.y = minY + objSize.height/2;
    }
    
    return newPosition;
}

@end