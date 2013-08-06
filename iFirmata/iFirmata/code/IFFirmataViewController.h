//
//  IFFirmataViewController.h
//  iFirmata
//
//  Created by Juan Haladjian on 6/27/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFFirmataController.h"
#import "IFI2CComponentViewController.h"

@class IFFirmataController;
@class CBPeripheral;

@interface IFFirmataViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, IFFirmataControllerDelegate, IFI2CComponentDelegate, UIActionSheetDelegate>
{
    BOOL connected;
    BOOL goingToI2CScene;
}

@property (weak, nonatomic) IFFirmataController * firmataController;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IFI2CComponent *removingComponent;
@property (strong, nonatomic) NSIndexPath *removingComponentPath;

- (IBAction) optionsMenuTapped:(id)sender;

@end
