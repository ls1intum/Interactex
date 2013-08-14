//
//  THClothe.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THHardwareComponentEditableObject;

@interface THClothe : TFEditableObject
{
    NSMutableArray * _attachments;
    BOOL _imageFromName;
}

-(id) initWithName:(NSString*) name;
-(void) attachClotheObject:(THHardwareComponentEditableObject*) object;
-(void) deattachClotheObject:(THHardwareComponentEditableObject*) object;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic) BOOL imageFromName;

@end
