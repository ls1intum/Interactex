/*
THColorPicker.m
Interactex Designer

Created by Juan Haladjian on 05/10/2013.

Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.

www.interactex.org

Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
	
Contacts:
juan.haladjian@cs.tum.edu
katharina.bredies@udk-berlin.de
opensource@telekom.de

    
The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".

Interactex is built using the Tango framework developed by TU Munich.

In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.). 
www.cocos2d-iphone.org
github.com/gabriel/gh-unit

Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
www.firmata.org

All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
www.frizting.org

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "THColorPicker.h"
#import <QuartzCore/QuartzCore.h>

static NSUInteger shades = 8;
static NSUInteger hues = 10;
static CGFloat buttonSize = 44.0f;
static CGFloat topOffset = 88.0f;

@implementation THColorPicker

-(id)init {
    self = [super initWithNibName:@"THColorPicker" bundle:nil];
    if(self){
        swatches = [NSMutableArray array];
        [self updateSwatches];
    }
    return self;
}

- (void)updateSwatches {
    for(UIView *swatch in swatches)
        [swatch removeFromSuperview];
    [swatches removeAllObjects];
    for(int y = 0; y <= hues; y++){
        for(int x = 0; x < shades; x++){
            UIColor *color;
            if(y == hues){
                // Grayscale row
                float brightness = ((float)x / (float)shades);
                color = [UIColor colorWithHue:0.0f
                                   saturation:0.0f
                                   brightness:brightness
                                        alpha:alphaSlider.value];
            }else{
                // Color rows
                float hue = ((float)y / (float)hues);
                float brightness = (((float)x + 4.0f) / ((float)shades + 4.0f));
                color = [UIColor colorWithHue:hue 
                                   saturation:saturationSlider.value
                                   brightness:brightness
                                        alpha:alphaSlider.value];
            }
            UIButton *swatch = [UIButton buttonWithType:UIButtonTypeCustom];
            [swatch setBackgroundColor:color];
            swatch.layer.cornerRadius = 4.0f;
            swatch.layer.borderWidth = 1.0f;
            swatch.layer.borderColor = [[UIColor colorWithWhite:1.0f alpha:0.5f] CGColor];
            CGRect frame = CGRectMake(x * (buttonSize + 8) + 8,
                                      y * (buttonSize + 8) + 8 + topOffset, buttonSize, buttonSize);
            [self.view addSubview:swatch];
            [swatch setFrame:frame];
            [swatch addTarget:self action:@selector(swatchTapped:) forControlEvents:UIControlEventTouchDown];
            [swatches addObject:swatch];
        }
    }
}

-(CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(shades * (buttonSize + 8) + 8 + 8,
                      (hues + 1) * (buttonSize + 8) + 8 + 8 + topOffset);
}

- (IBAction)swatchTapped:(id)sender
{
    UIButton *swatch = (UIButton*)sender;
    UIColor *color = [swatch backgroundColor];
    [_delegate colorPicker:self didPickColor:color];
}

-(void)sliderChanged:(id)sender
{
    [self updateSwatches];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIDeviceOrientationLandscapeRight);
}

@end
