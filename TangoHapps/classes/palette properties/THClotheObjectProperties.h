//
//  THClotheObjectProperties.h
//  TangoHapps
//
//  Created by Juan Haladjian on 9/21/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "TFEditableObjectProperties.h"

@interface THClotheObjectProperties : TFEditableObjectProperties < UITableViewDataSource, UITableViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
