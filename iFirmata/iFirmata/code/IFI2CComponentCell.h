//
//  IFI2CPinCell.h
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IFI2CComponent;

@interface IFI2CComponentCell : UITableViewCell

@property (nonatomic, weak) IFI2CComponent * component;

-(void) removeComponentObservers;

@end
