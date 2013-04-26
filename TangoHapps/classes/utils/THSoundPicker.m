//
//  THSoundPicker.m
//  TangoHapps
//
//  Created by Juan Haladjian on 4/24/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import "THSoundPicker.h"

@implementation THSoundPicker

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.contentSizeForViewInPopover = CGSizeMake(320, 480);
        
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
    
    _sounds = [TFFileUtils filesInDirectory:@"sounds"];
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
