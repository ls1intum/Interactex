//
//  THPropertySelectionPopup.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/15/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THPropertySelectionPopup;
@class TFEditableObject;
@class TFMethodInvokeAction;
@class TFMethodSelectionPopup;
@class TFEvent;
@class THInvocationConnectionLine;

@protocol THPropertySelectionPopupDelegate <NSObject>

-(void) propertySelectionPopup:(THPropertySelectionPopup*) popup didSelectProperty:(TFProperty*) property;

@end


@interface THPropertySelectionPopup : UIViewController <UITableViewDataSource, UITableViewDelegate>{

    UIPopoverController * popOverController;
    
    NSMutableArray * _matchingProperties;
}


@property (nonatomic, weak) TFEditableObject * object;
@property (nonatomic, weak) THInvocationConnectionLine * connection;

@property (nonatomic, weak) id<THPropertySelectionPopupDelegate> delegate;
@property (nonatomic, strong) UITableView *table;

-(void) present;

@end