//
//  TFGridItem.h
//  TangoFramework
//
//  Created by Juan Haladjian on 11/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THGridItem;

@protocol THGridItemDelegate <NSObject>

-(void) didSelectGridItem:(THGridItem*) item;
-(void) didDeleteGridItem:(THGridItem*) item;
-(void) didRenameGridItem:(THGridItem*) item newName:(NSString*) name;
-(void) didLongPressGridItem:(THGridItem*) item;

@end

@interface THGridItem : UIView <UITextFieldDelegate>
{
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, weak) id<THGridItemDelegate>delegate;


- (id)initWithName:(NSString*)name image:(UIImage*)image;


@property (retain, nonatomic) IBOutlet UIView *itemContainer;
@property (weak, nonatomic) IBOutlet UIImageView *iPadFrame;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic) BOOL editing;
@property (nonatomic) BOOL editable;

@property (nonatomic) BOOL backgroundHidden;

-(IBAction)selectItem:(id)sender;
-(IBAction)deleteItem:(id)sender;
-(IBAction)renameItem:(id)sender;

@end
