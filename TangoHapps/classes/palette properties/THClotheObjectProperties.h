//
//  THClotheObjectProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/21/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THEditableObjectProperties.h"

@interface THClotheObjectProperties : THEditableObjectProperties < UITableViewDataSource, UITableViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
