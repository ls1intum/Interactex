//
//  IFFirmataViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMPPinsController.h"
#import "GMPI2CComponentViewController.h"

@class GMPPinsController;
@class CBPeripheral;

@interface GMPViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, GMPControllerPinsDelegate, GMPI2CComponentDelegate, UIActionSheetDelegate>
{
    BOOL connected;
    BOOL goingToI2CScene;
}

@property (weak, nonatomic) GMPPinsController * gmpPinsController;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) GMPI2CComponent *removingComponent;
@property (strong, nonatomic) NSIndexPath *removingComponentPath;

- (IBAction) optionsMenuTapped:(id)sender;

@end
