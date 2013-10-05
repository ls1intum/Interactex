//
//  THLabel.m
//  TangoHapps
//
//  Created by Juan Haladjian on 9/14/12.
//  Copyright (c) 2012 TUM. All rights reserved.
//

#import "THLabel.h"

@implementation THLabel

@dynamic numLines;
@dynamic text;

-(void) loadLabelView{
    
    UILabel * label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, self.width, self.height);
    label.textAlignment = NSTextAlignmentCenter;
    self.view = label;
    
    self.view.layer.cornerRadius = 5;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.layer.borderWidth = 1.0f;
    
    TFMethod * method =[TFMethod methodWithName:@"setText"];
    method.firstParamType = kDataTypeAny;
    method.numParams = 1;
    self.methods = [NSMutableArray arrayWithObject:method];
}

-(id) init{
    self = [super init];
    if(self){
        
        self.width = 100;
        self.height = 50;
        
        [self loadLabelView];
        
        self.backgroundColor = [UIColor colorWithRed:0.71 green:0.93 blue:0.93 alpha:1];
        
        self.text = @"Label";
    }
    return self;
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    [self loadLabelView];
    
    self.text = [decoder decodeObjectForKey:@"text"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.text forKey:@"text"];
}

-(id)copyWithZone:(NSZone *)zone
{
    THLabel * copy = [super copyWithZone:zone];
    copy.text = self.text;
    
    return copy;
}

#pragma mark - Properties

-(void) setNumLines:(NSInteger)numLines{
    
    UILabel * label = (UILabel*) self.view;
    label.numberOfLines = numLines;
}

-(NSInteger) numLines{
    UILabel * label = (UILabel*) self.view;
    return label.numberOfLines;
}

-(void) setText:(id)text{
    UILabel * label = (UILabel*) self.view;
    //NSLog(@"text: %@",text);
    NSString * string = @"";
    if([text isKindOfClass:[NSString class]]){
        string = (NSString*) text;
    } else if([text isKindOfClass:[NSNumber class]]){
        NSNumber * number = text;
        string = [number stringValue];
    }
    
    label.text = string;
}

-(NSString*) text{
    UILabel * label = (UILabel*) self.view;
    return label.text;
}

-(NSString*) description{
    return @"label";
}

@end
