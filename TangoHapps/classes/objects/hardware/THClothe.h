//
//  THClothe.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/7/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THClotheObjectEditableObject;

@interface THClothe : TFEditableObject
{
    NSMutableArray * _attachments;
    BOOL _imageFromName;
}

-(id) initWithName:(NSString*) name;
-(void) attachClotheObject:(THClotheObjectEditableObject*) object;
-(void) deattachClotheObject:(THClotheObjectEditableObject*) object;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) UIImage * image;

@end
