/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


#import <UIKit/UIKit.h>
#import "TFMethod.h"

@class TFEditableObject;
@class TFMethodInvokeAction;
@class TFMethodSelectionPopup;
@class TFEvent;

@protocol TFMethodSelectionPopupDelegate <NSObject>

-(void) methodSelectionPopup:(TFMethodSelectionPopup*) popup didSelectAction:(TFMethodInvokeAction*) action forEvent:(TFEvent*) event;

@end

@interface TFMethodSelectionPopup : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIPopoverController * popOverController;
    
    NSMutableArray * _acceptedEvents;
    NSMutableArray * _acceptedMethods;
}

//invokable and triggerable should be set here
-(void) present;

@property (nonatomic, weak) TFEditableObject * object1;
@property (nonatomic, weak) TFEditableObject * object2;

@property (nonatomic, weak) id<TFMethodSelectionPopupDelegate> delegate;

@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UITableView *table2;

@end
