//
//  TFGridItem.h
//  TangoFramework
//
//  Created by Juan Haladjian on 11/23/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THClientGridItem;

@protocol TFClientGridItemDelegate <NSObject>

-(void) didSelectGridItem:(THClientGridItem*) item;
-(void) didDeleteGridItem:(THClientGridItem*) item;
-(void) didRenameGridItem:(THClientGridItem*) item newName:(NSString*) name;

@end

@interface THClientGridItem : UIView <UITextFieldDelegate>
{
}

@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, weak) id<TFClientGridItemDelegate> delegate;


- (id)initWithName:(NSString*)name image:(UIImage*)image;


@property (retain, nonatomic) IBOutlet UIView *itemContainer;
@property (weak, nonatomic) IBOutlet UIImageView *iPadFrame;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (nonatomic) BOOL editing;
@property (nonatomic) BOOL editable;

@property (nonatomic) BOOL backgroundHidden;

-(IBAction)selectItem:(id)sender;
-(void) scaleEffect;

@end
