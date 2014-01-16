/*
GMPI2CComponentCell.m
iGMP

Created by Juan Haladjian on 31/07/2013.

iGMP is an App to control an Arduino board over Bluetooth 4.0. iGMP uses the GMP protocol (based on Firmata): www.firmata.org

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany, 
	
Contacts:
juan.haladjian@cs.tum.edu
k.zhang@utwente.nl
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
It has been created with funding from EIT ICT, as part of the activity "Connected Textiles".


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
