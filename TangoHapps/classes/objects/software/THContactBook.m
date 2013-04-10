//
//  THAddressBook.m
//  TangoHapps
//
//  Created by Juan Haladjian on 12/13/12.
//  Copyright (c) 2012 Juan Haladjian. All rights reserved.
//

#import "THContactBook.h"


@implementation THContact
@synthesize name,number;
@end

@implementation THContactBook


float const kContactBookButtonWidth = 30;
float const kContactBookButtonHeight = 30;
float const kContactBookLabelHeight = 40;
float const kContactBookInnerPadding = 10;

NSString * const kCallImageName = @"call.png";

-(id) init{
    self = [super init];
    if(self){
        
        _showCallButton = YES;
        _showNextButton = YES;
        _showPreviousButton = YES;
        
        self.width = 260;
        self.height = 100;
        
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

-(void) loadGui{
    UIView * containerView = [[UIView alloc] init];
    containerView.bounds = CGRectMake(0, 0, self.width, self.height);
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.borderWidth = 1.0f;
    //containerView.contentMode = UIViewContentModeTop;
    self.view = containerView;
    
    UIImage * image =  [UIImage imageNamed:@"contactBook"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    //float heightDiff = self.height - image.size.height;
    imageView.frame= CGRectMake(5, 5, image.size.width, image.size.height);
    [containerView addSubview:imageView];
    
    _label = [[UILabel alloc] init];
    _label.layer.borderWidth = 1.0f;
    CGRect imageFrame = imageView.frame;
    float x = imageFrame.origin.x + imageFrame.size.width + kContactBookInnerPadding;
    _label.frame = CGRectMake(x, 5, self.width - imageFrame.size.width - 20, kContactBookLabelHeight);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:_label];
    
    CGRect previousButtonFrame = CGRectMake(60, _label.frame.origin.y + _label.frame.size.height + kContactBookInnerPadding, kContactBookButtonWidth, kContactBookButtonHeight);
    _previousButton = [self buttonWithFrame:previousButtonFrame imageName:@"backwards.png"];
    [_previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchDown];
    
    CGRect playButtonFrame = CGRectMake(120, _label.frame.origin.y + _label.frame.size.height + kContactBookInnerPadding, kContactBookButtonWidth, kContactBookButtonHeight);
    _callButton = [self buttonWithFrame:playButtonFrame imageName:kCallImageName];
    [_callButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchDown];
    
    CGRect nextButtonFrame = CGRectMake(180, _label.frame.origin.y + _label.frame.size.height + kContactBookInnerPadding, kContactBookButtonWidth, kContactBookButtonHeight);
    _nextButton = [self buttonWithFrame:nextButtonFrame imageName:@"forward.png"];
    [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    
    [self checkAddRemovePreviousButton];
    [self checkAddRemoveCallButton];
    [self checkAddRemoveNextButton];
}

-(void) loadMethods{
    TFMethod * method1 = [TFMethod methodWithName:@"call"];
    TFMethod * method2 = [TFMethod methodWithName:@"previous"];
    TFMethod * method3 = [TFMethod methodWithName:@"next"];
    self.methods = [NSMutableArray arrayWithObjects:method1, method2, method3, nil];
}

-(void) loadContactBook{
    
    [self loadGui];
    [self loadMethods];   
}

#pragma mark - Archiving

-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if(self){
        _showCallButton = [decoder decodeBoolForKey:@"showCallButton"];
        _showNextButton = [decoder decodeBoolForKey:@"showNextButton"];
        _showPreviousButton = [decoder decodeBoolForKey:@"showPreviousButton"];
        
        [self loadContactBook];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
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
        NSLog(@"calling %@",contact.number);
        [THClientHelper MakeCallTo:contact.number];
    }
}

-(void) updateCurrentContact{
    THContact * contact = self.currentContact;
    if(contact){
        _label.text = [NSString stringWithFormat:@"%@ - %@", contact.name, contact.number];
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
        contact.name = [NSString stringWithFormat:@"%@ %@",name1,name2];
        
        if(ABMultiValueGetCount(multi) > 0){
            NSString * phone =  (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multi, 0));
            contact.number = phone;
        }
        
        return contact;
    } else {
        return nil;
    }
}

-(void) addContacts{
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(_addressBook);
    _contacts = CFArrayCreateMutableCopy(kCFAllocatorDefault,CFArrayGetCount(people), people);
    
    CFArraySortValues(_contacts, CFRangeMake(0, CFArrayGetCount(_contacts)), (CFComparatorFunction)ABPersonComparePeopleByName, (void*) ABPersonGetSortOrdering());
    
    CFRelease(people);
    
    _callButton.enabled = YES;
    _nextButton.enabled = YES;
    _previousButton.enabled = YES;
    
    [self updateCurrentContact];
}

-(void) willStartSimulating{
    CFErrorRef error;
    _addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    //ABAddressBookRequestAccessWithCompletion();
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            [self addContacts];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self addContacts];
    }
    else {
        NSLog(@"access not granted!");
    }
    
   
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
