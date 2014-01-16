/*
THClientTableProjectCell.m
Interactex Client

Created by Juan Haladjian on 12/11/2013.

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

#import "THClientTableProjectCell.h"

@implementation THClientTableProjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) didTransitionToState:(UITableViewCellStateMask)state{
    [super didTransitionToState:state];
    
    if(state == UITableViewCellStateDefaultMask){
        
        [self.textField resignFirstResponder];
        self.textField.hidden = YES;
        self.nameLabel.hidden = NO;
        
    } else {
        
        self.textField.text = self.nameLabel.text;
        self.nameLabel.hidden = YES;
        self.textField.hidden = NO;
    }
}

- (IBAction)textChanged:(id)sender {
    [self.delegate tableProjectCell:self didChangeNameTo:self.textField.text];
    [self.textField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
        
    [self.textField resignFirstResponder];
    
    return YES;
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(duplicate:));
}

-(void) duplicate: (id) sender {
    [self.delegate didDuplicateTableProjectCell:self];
}

@end
