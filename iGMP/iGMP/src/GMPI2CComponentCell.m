//
//  IFI2CPinCell.m
//  iFirmata
//
//  Created by Juan Haladjian on 7/31/13.
//  Copyright (c) 2013 TUM. All rights reserved.
//

#import "GMPI2CComponentCell.h"
#import "GMPI2CComponent.h"

@implementation GMPI2CComponentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateNameLabel{
    self.textLabel.text = self.component.name;
}

-(void) updateDetailLabel{
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"Address: #%d",self.component.address];
}

/*
-(void) updateValueLabel{
    
    if(self.reg.numBytes == 0){
        self.valueLabel.text = @"";
    } else {
        self.valueLabel.text = [IFHelper valueAsBracketedStringForI2CComponent:self.component];
    }
}*/

-(void) setComponent:(GMPI2CComponent *)component{
    if(component != _component){
        
        [self removeComponentObservers];
        
        _component = component;
        
        [self registerComponentObservers];
        
        [self updateNameLabel];
        [self updateDetailLabel];
    }
}

-(void) removeComponentObservers{
    
     [self.component removeObserver:self forKeyPath:@"name"];
     [self.component removeObserver:self forKeyPath:@"address"];
}

-(void) registerComponentObservers{
    
     [self.component addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
     [self.component addObserver:self forKeyPath:@"address" options:NSKeyValueObservingOptionNew context:nil];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"name"]){
        [self updateNameLabel];
    } else if([keyPath isEqualToString:@"address"]){
        [self updateDetailLabel];
    }
}

-(void) dealloc{

    [self removeComponentObservers];
}

@end
