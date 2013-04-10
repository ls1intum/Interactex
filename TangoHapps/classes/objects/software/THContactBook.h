//
//  THAddressBook.h
//  TangoHapps
//
//  Created by Juan Haladjian on 12/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THView.h"
#import <AddressBookUI/AddressBookUI.h>

@interface THContact : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * number;
@end

@interface THContactBook : THView
{
    CFMutableArrayRef _contacts;
    ABAddressBookRef _addressBook;
    
    NSInteger _currentContactIdx;
    
    UILabel * _label;
    UIButton * _callButton;
    UIButton * _nextButton;
    UIButton * _previousButton;
}


@property (nonatomic) BOOL showCallButton;
@property (nonatomic) BOOL showNextButton;
@property (nonatomic) BOOL showPreviousButton;

@property (nonatomic, readonly) THContact * currentContact;

-(void) next;
-(void) previous;
-(void) call;

@end
