/*
THSoundPicker.m
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

#import "THSoundPicker.h"

@implementation THSoundPicker

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.preferredContentSize = CGSizeMake(320, 480);
        
        // Custom initialization
        CGRect tableFrame = CGRectMake(10, 10, 300, 400);
        _table = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.frame = CGRectMake(190, tableFrame.origin.y + tableFrame.size.height + 10, 100, 50);
        [_button setTitle:@"OK" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(okTapped:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_button];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sounds = [NSArray arrayWithObjects:@"peer_connected.mp3",@"peer_disconnected.mp3", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * soundName = [_sounds objectAtIndex:indexPath.row];
    
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = soundName;
    
    return cell;
}

-(void) okTapped:(id) sender{
    NSIndexPath * path = [_table indexPathForSelectedRow];
    NSString * sound = nil;
    if(path){
        NSInteger row = path.row;
        sound = [_sounds objectAtIndex:row];
    }
    [self.delegate soundPicker:self didPickSound:sound];
}

@end
