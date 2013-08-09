//
//  THEditorToolsDataSource.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THServerController.h"
#import "THEditorToolsDataSource.h"

@interface THEditorToolsDataSource : NSObject <TFEditorToolsDataSource, THServerControllerDelegate> {
    NSArray * _editingTools;
    NSArray * _simulatingTools;
}

@property (nonatomic, readonly) UIBarButtonItem * lilypadItem;
@property (nonatomic, readonly) UIBarButtonItem * serverItem;

@property (nonatomic, readonly) THServerController * serverController;



@end
