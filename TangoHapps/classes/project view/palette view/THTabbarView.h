/*
THTabbarView.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class THTabbarView;
@class THTabbarSection;
@class THPalette;

@protocol TFTabbarViewDataSource <NSObject>
-(NSInteger) numPaletteSectionsForPalette:(THTabbarView*) tabBar;
-(NSInteger) numPaletteItemsForSection:(NSInteger) section palette:(THTabbarView*) tabBar;
-(THPaletteItem*) paletteItemForIndexPath:(NSIndexPath*) indexPath palette:(THTabbarView*) tabBar;
-(NSString*) titleForSection:(NSInteger) section palette:(THTabbarView*) tabBar;
@end


@protocol TFTabBarViewDelegate <NSObject>
-(void) tabBar:(THTabbarView*) tabBar didAddSection:(THTabbarSection*) section;
@end

@interface THTabbarView : UIScrollView <TFPaletteSectionDelegate>
{
    CGFloat _currentY;
}

@property (nonatomic, strong) NSMutableArray * sections;
@property (nonatomic, weak) id<TFTabbarViewDataSource> dataSource;
@property (nonatomic, weak) id<TFTabBarViewDelegate> tabBarDelegate;

-(void) addPaletteSection:(THTabbarSection*) section;
-(void) removeSection:(THTabbarSection*) section;
-(void) removeAllSections;
-(void) relayoutSections;
-(void) reloadData;
-(void) reloadSectionWithIndex:(NSInteger) sectionIndex;

-(THTabbarSection*) sectionForPalette:(THPalette*) palette;
-(NSInteger) idxOfSectionNamed:(NSString*) name;
-(THTabbarSection*) sectionNamed:(NSString*) name;
-(THTabbarSection*) sectionAtLocation:(CGPoint) location;


@end
