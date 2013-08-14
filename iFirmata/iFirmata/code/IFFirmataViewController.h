//
//  IFFirmataViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFFirmataPinsController.h"
#import "IFI2CComponentViewController.h"

@class IFFirmataPinsController;
@class CBPeripheral;

@interface IFFirmataViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, IFFirmataControllerPinsDelegate, IFI2CComponentDelegate, UIActionSheetDelegate>
{
    BOOL connected;
    BOOL goingToI2CScene;
}

@property (weak, nonatomic) IFFirmataPinsController * firmataPinsController;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IFI2CComponent *removingComponent;
@property (strong, nonatomic) NSIndexPath *removingComponentPath;

- (IBAction) optionsMenuTapped:(id)sender;

@end
