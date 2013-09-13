//
//  THTableProjectCell.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/12/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THTableProjectCell.h"

@implementation THTableProjectCell

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
