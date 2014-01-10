//
//  IFFirmataViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFPinsController.h"
#import "IFI2CComponentViewController.h"

@class IFPinsController;
@class CBPeripheral;

enum{
    kTableGroupIdxDigital,
    kTableGroupIdxAnalog,
    kTableGroupIdxI2C,
    kTableGroupIdxCharacteristics
};

@interface IFViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, IFFirmataControllerPinsDelegate, IFI2CComponentDelegate, UIActionSheetDelegate>
{
    BOOL connected;
    BOOL goingToI2CScene;
}

@property (weak, nonatomic) IFPinsController * firmataPinsController;
@property (weak, nonatomic) IBOutlet UITableView * table;
@property (strong, nonatomic) NSMutableArray * characteristics;

@property (strong, nonatomic) IFI2CComponent *removingComponent;
@property (strong, nonatomic) NSIndexPath *removingComponentPath;

- (IBAction) optionsMenuTapped:(id)sender;

@end
