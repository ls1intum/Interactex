//
//  THSoundPicker.h
//  TangoHapps
//
//  Created by Juan Haladjian on 4/24/13.
//  Copyright (c) 2013 Technische Universität München. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THSoundPicker;

@protocol THSoundPickerDelegate <NSObject>
- (void)soundPicker:(THSoundPicker*)picker didPickSound:(NSString*)sound;
@end

@interface THSoundPicker : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIScrollView * _scrollView;
    UIButton * _button;
    UITableView * _table;
    
    NSArray * _sounds;
}

@property (nonatomic, weak) id<THSoundPickerDelegate> delegate;

@end
