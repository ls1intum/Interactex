/*
GHAsyncTestCase.h
Interactex Designer

Created by Juan Haladjian on 31/05/2012.

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


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "GHTestCase.h"

/*!
 Common wait statuses to use with waitForStatus:timeout:.
 */
enum {
  kGHUnitWaitStatusUnknown = 0, // Unknown wait status
  kGHUnitWaitStatusSuccess, // Wait status success
  kGHUnitWaitStatusFailure, // Wait status failure
  kGHUnitWaitStatusCancelled // Wait status cancelled
};

/*!
 Asynchronous test case with wait and notify.
 
 If notify occurs before wait has started (if it was a synchronous call), this test
 case will still work.

 Be sure to call prepare before the asynchronous method (otherwise an exception will raise).
 
     @interface MyAsyncTest : GHAsyncTestCase { }
     @end
     
     @implementation MyAsyncTest
     
     - (void)testSuccess {
       // Prepare for asynchronous call
       [self prepare];
       
       // Do asynchronous task here
       [self performSelector:@selector(_succeed) withObject:nil afterDelay:0.1];
       
       // Wait for notify
       [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
     }
     
     - (void)_succeed {
       // Notify the wait. Notice the forSelector points to the test above. 
       // This is so that stray notifies don't error or falsely succeed other tests.
       // To ignore the check, forSelector can be NULL.
       [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testSuccess)];
     }
     
     @end

 */
@interface GHAsyncTestCase : GHTestCase {

  NSInteger waitForStatus_;
  NSInteger notifiedStatus_;
  
  BOOL prepared_; // Whether prepared was called before waitForStatus:timeout:
  NSRecursiveLock *lock_; // Lock to synchronize on
  SEL waitSelector_; // The selector we are waiting on
    
  NSArray *_runLoopModes;
}

/*!
 Run loop modes to run while waiting; 
 Defaults to NSDefaultRunLoopMode, NSRunLoopCommonModes, NSConnectionReplyMode
 */
@property (strong, nonatomic) NSArray *runLoopModes; 

/*!
 Prepare before calling the asynchronous method. 
 */
- (void)prepare;

/*!
 Prepare and specify the selector we will use in notify.

 @param selector Selector
 */
- (void)prepare:(SEL)selector;

/*!
 Wait for notification of status or timeout.
 
 Be sure to prepare before calling your asynchronous method.
 For example, 
 
    - (void)testFoo {
      [self prepare];
 
      // Do asynchronous task here
 
      [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
    }
 
 @param status kGHUnitWaitStatusSuccess, kGHUnitWaitStatusFailure or custom status 
 @param timeout Timeout in seconds
 */
- (void)waitForStatus:(NSInteger)status timeout:(NSTimeInterval)timeout;

/*! 
 @param status kGHUnitWaitStatusSuccess, kGHUnitWaitStatusFailure or custom status 
 @param timeout Timeout in seconds
 @deprecated Use waitForTimeout:
 */
- (void)waitFor:(NSInteger)status timeout:(NSTimeInterval)timeout;

/*!
 Wait for timeout to occur.
 Fails if we did _NOT_ timeout.

 @param timeout Timeout
 */
- (void)waitForTimeout:(NSTimeInterval)timeout;

/*!
 Notify waiting of status for test selector.

 @param status Status, for example, kGHUnitWaitStatusSuccess
 @param selector If not NULL, then will verify this selector is where we are waiting. This prevents stray asynchronous callbacks to fail a later test.
 */
- (void)notify:(NSInteger)status forSelector:(SEL)selector;

/*!
 Notify waiting of status for any selector.

 @param status Status, for example, kGHUnitWaitStatusSuccess
 */
- (void)notify:(NSInteger)status;

/*!
 Run the run loops for the specified interval.

 @param interval Interval
 @author Adapted from Robert Palmer, pauseForTimeout
 */
- (void)runForInterval:(NSTimeInterval)interval;

@end
