/*
THContactBook.m
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

#import "THContactBook.h"


@implementation THContact
@synthesize firstName, lastName, number;

@end

@implementation THContactBook

CGSize const kContactBookCallButtonSize = {62,62};
CGSize const kContactBookButtonSize = {30, 16};
CGSize const kContactBookLabelSize = {110,40};
float const kContactBookInnerPadding = 5;
float const kContactBookOutterPadding = 5;

NSString * const kCallImageName = @"call.png";

-(id) init{
    self = [super init];
    if(self){
        
        _showCallButton = YES;
        _showNextButton = YES;
        _showPreviousButton = YES;
        
        self.width = kDefaultContactBookSize.width;
        self.height = kDefaultContactBookSize.height;
        
        [self loadContactBook];
    }
    return self;
}

-(UIButton*) buttonWithFrame:(CGRect) frame imageName:(NSString*) name{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    UIImage * playImage = [UIImage imageNamed:name];
    [button setBackgroundImage:playImage forState:UIControlStateNormal];
    button.enabled = NO;
    
    return button;
}

-(void) checkAddRemovePreviousButton{
    if(self.showPreviousButton){
        [self.view addSubview:_previousButton];
    } else {
        [_previousButton removeFromSuperview];
    }
}

-(void) checkAddRemoveCallButton{
    if(self.showCallButton){
        [self.view addSubview:_callButton];
    } else {
        [_callButton removeFromSuperview];
    }
}

-(void) checkAddRemoveNextButton{
    if(self.showNextButton){
        [self.view addSubview:_nextButton];
    } else {
        [_nextButton removeFromSuperview];
    }
}
-(void) loadMethods{
    TFMethod * method1 = [TFMethod methodWithName:@"call"];
    TFMethod * method2 = [TFMethod methodWithName:@"previous"];
    TFMethod * method3 = [TFMethod methodWithName:@"next"];
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, method3, nil];
}

-(void) loadContactBook{
    
    [self loadMethods];   
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if(self){
        _showCallButton = [decoder decodeBoolForKey:@"showCallButton"];
        _showNextButton = [decoder decodeBoolForKey:@"showNextButton"];
        _showPreviousButton = [decoder decodeBoolForKey:@"showPreviousButton"];
        
        [self loadContactBook];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeBool:_showCallButton forKey:@"showCallButton"];
    [coder encodeBool:_showNextButton forKey:@"showNextButton"];
    [coder encodeBool:_showPreviousButton forKey:@"showPreviousButton"];
}

#pragma mark - Methods

-(void) setShowCallButton:(BOOL)showCallButton{
    if(showCallButton != self.showCallButton){
        _showCallButton = showCallButton;
        [self checkAddRemoveCallButton];
    }
}

-(void) setShowNextButton:(BOOL)showNextButton{
    if(showNextButton != self.showNextButton){
        _showNextButton = showNextButton;
        [self checkAddRemoveNextButton];
    }
}

-(void) setShowPreviousButton:(BOOL)showPreviousButton{
    if(showPreviousButton != self.showPreviousButton){
        _showPreviousButton = showPreviousButton;
        [self checkAddRemovePreviousButton];
    }
}

-(void) next{
    _currentContactIdx++;
    NSInteger count = CFArrayGetCount(_contacts);
    if(_currentContactIdx >= count){
        _currentContactIdx = 0;
    }
    [self updateCurrentContact];
}

-(void) previous{
    _currentContactIdx--;
    if(_currentContactIdx < 0){
        _currentContactIdx = CFArrayGetCount(_contacts) - 1;
    }
    [self updateCurrentContact];
}

-(void) call{
    THContact * contact = self.currentContact;
    if(contact){

        [THClientHelper MakeCallTo:contact.number];
    }
}

-(void) updateContactBookState{
    if(_contacts != nil){
        _callButton.enabled = YES;
        _nextButton.enabled = YES;
        _previousButton.enabled = YES;
        [self updateCurrentContact];
    }
}

-(void) updateCurrentContact{
    THContact * contact = self.currentContact;
    if(contact){
        
        if(contact.firstName || contact.lastName){
            NSString * firstName = contact.firstName;
            if(!firstName){
                firstName = @"";
            }
            
            NSString * lastName = contact.lastName;
            if(!lastName){
                lastName = @"";
            }
            
            _label.text = [NSString stringWithFormat:@"%@\n%@",firstName,lastName];
            
        } else {
            _label.text = @"Unknown";
        }
        
    } else {
        _label.text = [NSString stringWithFormat:@"No contacts in book"];
    }
}

-(THContact*) currentContact{
    if(CFArrayGetCount(_contacts) > 0){
        ABRecordRef record = CFArrayGetValueAtIndex(_contacts, _currentContactIdx);
        
        NSString * name1 = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString * name2 = (__bridge_transfer NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
        ABMutableMultiValueRef multi = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        THContact * contact = [[THContact alloc] init];
        
        if (name1 && ![name1 isEqualToString:@"null"]) {
            contact.firstName = name1;
        }
        
        if (name2 && ![name2 isEqualToString:@"null"]) {
            contact.lastName = name2;
        }
        
        if(ABMultiValueGetCount(multi) > 0){
            NSString * phoneRef = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multi, 0));
            contact.number = phoneRef;
            CFRelease((__bridge CFTypeRef)(phoneRef));
        }
        
        CFRelease(multi);
        
        return contact;
    } else {
        return nil;
    }
}

-(void) addContacts{
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    _contacts = CFArrayCreateMutableCopy(kCFAllocatorDefault,CFArrayGetCount(people), people);
    
    CFArraySortValues(_contacts, CFRangeMake(0, CFArrayGetCount(_contacts)), (CFComparatorFunction)ABPersonComparePeopleByName, (void*) (NSInteger) ABPersonGetSortOrdering());
    
    CFRelease(people);
    
    [self updateContactBookState];
}


-(void) loadGui{
    
    UIView * containerView = [[UIView alloc] init];
    containerView.bounds = CGRectMake(0, 0, self.width, self.height);
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.borderWidth = 1.0f;
    containerView.layer.borderColor = [super defaultBorderColor];
    self.view = containerView;
    
    CGRect callButtonFrame = CGRectMake(containerView.frame.size.width/2 - kContactBookCallButtonSize.width/2, kContactBookOutterPadding, kContactBookCallButtonSize.width, kContactBookCallButtonSize.height);
    _callButton = [self buttonWithFrame:callButtonFrame imageName:kCallImageName];
    [_callButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchDown];
    
    //contact book image
    UIImage * image =  [UIImage imageNamed:@"contactBook"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame= CGRectMake(kContactBookOutterPadding, callButtonFrame.origin.y + callButtonFrame.size.height + kContactBookInnerPadding, image.size.width, image.size.height);
    [containerView addSubview:imageView];
    
    //previous button
    CGRect previousButtonFrame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + kContactBookInnerPadding, imageView.frame.origin.y + (imageView.frame.size.height - kContactBookButtonSize.height)/2, kContactBookButtonSize.width, kContactBookButtonSize.height);
    _previousButton = [self buttonWithFrame:previousButtonFrame imageName:@"backwards.png"];
    [_previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchDown];
    
    //label
    _label = [[UILabel alloc] init];
    _label.clipsToBounds = YES;
    _label.layer.cornerRadius = 5.0f;
    _label.frame = CGRectMake(previousButtonFrame.origin.x + previousButtonFrame.size.width + kContactBookInnerPadding, imageView.frame.origin.y + (imageView.frame.size.height - kContactBookLabelSize.height)/2, kContactBookLabelSize.width , kContactBookLabelSize.height);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:16];
    _label.numberOfLines = 2;
    [containerView addSubview:_label];
    
    //netx button
    CGRect nextButtonFrame = CGRectMake(_label.frame.origin.x + _label.frame.size.width + kContactBookInnerPadding, previousButtonFrame.origin.y, kContactBookButtonSize.width, kContactBookButtonSize.height);
    _nextButton = [self buttonWithFrame:nextButtonFrame imageName:@"forward.png"];
    [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    
    [self checkAddRemovePreviousButton];
    [self checkAddRemoveCallButton];
    [self checkAddRemoveNextButton];
    
    self.height = imageView.frame.origin.y + imageView.frame.size.height - callButtonFrame.origin.y + 2 * kContactBookOutterPadding;
        
    [self updateContactBookState];
}

-(void) willStartSimulating{
    
    CFErrorRef error;
    _addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            [self addContacts];
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self addContacts];
    }
    else {
        NSLog(@"access not granted!");
    }
    
    CFRelease(addressBookRef);
   
}

-(NSString*) description{
    return @"contactbook";
}

-(void) prepareToDie{
    if(_contacts){
        CFRelease(_contacts);
        _contacts = nil;
    }
    
    [super prepareToDie];
}

@end
