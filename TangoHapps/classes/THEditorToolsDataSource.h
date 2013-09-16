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

@interface THEditorToolsDataSource : NSObject <THEditorToolsDataSource> {
    NSArray * _editingTools;
    NSArray * _simulatingTools;
}

@end
