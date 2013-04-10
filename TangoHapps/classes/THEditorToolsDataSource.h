//
//  THEditorToolsDataSource.h
//  TangoHapps
//
//  Created by Juan Haladjian on 11/28/12.
//  Copyright (c) 2012 Technische Universität München. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerController.h"
#import "THEditorToolsDataSource.h"

@interface THEditorToolsDataSource : NSObject <TFEditorToolsDataSource, ServerControllerDelegate> {
    NSArray * _editingTools;
    NSArray * _simulatingTools;
}

@property (nonatomic, readonly) UIBarButtonItem * lilypadItem;
@property (nonatomic, readonly) UIBarButtonItem * serverItem;

@property (nonatomic, readonly) ServerController * serverController;



@end
