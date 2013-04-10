//
//  THiPhoneViewEditableObject.h
//  TangoHapps
//
//  Created by Juan Haladjian on 10/29/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

@class THiPhoneViewProperties;

@interface THViewEditableObject : TFEditableObject{
    THiPhoneViewProperties * _properties;
}

@property(nonatomic) float width;
@property(nonatomic) float height;
@property(nonatomic) float opacity;
@property(nonatomic) CGPoint position;
@property(nonatomic) UIColor * backgroundColor;
@property (nonatomic) BOOL canChangeBackgroundColor;
@property (nonatomic) BOOL canBeRootView;
@property (nonatomic, strong) NSMutableArray * subviews;
@property (nonatomic) BOOL canBeResized;
@property (nonatomic) CGSize minSize;
@property (nonatomic) CGSize maxSize;

+(id) newView;

-(void) addSubview:(THViewEditableObject*) object;
-(void) removeSubview:(THViewEditableObject*) object;

@end