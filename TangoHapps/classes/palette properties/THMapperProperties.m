//
//  THMapperProperties.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/11/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THMapperProperties.h"
#import "THMapperEditable.h"
#import "THLinearFunction.h"


@implementation THMapperProperties

-(NSString *)title {
    return @"Mapper";
}

-(void) updateMinText{
    
    THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    self.minText.text = [NSString stringWithFormat:@"%.2f",mapper.min];
}

-(void) updateMaxText{
    
    THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    self.maxText.text = [NSString stringWithFormat:@"%.2f",mapper.max];
}

-(void) updateAText{
    
    THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    THLinearFunction * function = mapper.function;
    self.aText.text = [NSString stringWithFormat:@"%.2f", function.a];
}

-(void) updateBText{
    
    THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    THLinearFunction * function = mapper.function;
    self.bText.text = [NSString stringWithFormat:@"%.2f", function.b];
}

-(void) reloadState{
    
    [self updateMinText];
    [self updateMaxText];
    [self updateAText];
    [self updateBText];
}

- (IBAction)minChanged:(id)sender {
   THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    mapper.min = [self.minText.text floatValue];
}

- (IBAction)maxChanged:(id)sender {
    THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    mapper.max = [self.maxText.text floatValue];
}

- (IBAction)aChanged:(id)sender {
    
    THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    THLinearFunction * function = mapper.function;
    function.a = [self.aText.text floatValue];
}

- (IBAction)bChanged:(id)sender {
    
    THMapperEditable * mapper = (THMapperEditable*) self.editableObject;
    THLinearFunction * function = mapper.function;
    function.b = [self.bText.text floatValue];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMinText:nil];
    [self setMaxText:nil];
    [self setAText:nil];
    [self setBText:nil];
    [super viewDidUnload];
}

@end
