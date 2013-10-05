/*
GHTest.h
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

#import <Foundation/Foundation.h>


/*!
 Test status.
 */
typedef enum {
  GHTestStatusNone = 0,
  GHTestStatusRunning, //! Test is running
  GHTestStatusCancelling, //! Test is being cancelled
  GHTestStatusCancelled, //! Test was cancelled
  GHTestStatusSucceeded, //! Test finished and succeeded
  GHTestStatusErrored, //! Test finished and errored
} GHTestStatus;

enum {
  GHTestOptionReraiseExceptions = 1 << 0, // Allows exceptions to be raised (so you can trigger the debugger)
  GHTestOptionForceSetUpTearDownClass = 1 << 1, // Runs setUpClass/tearDownClass for this (each) test; Used when re-running a single test in a group
};
typedef NSInteger GHTestOptions;

/*!
 Generate string from GHTestStatus
 @param status
 */
extern NSString *NSStringFromGHTestStatus(GHTestStatus status);

/*!
 Check if test is running (or trying to cancel).
 */
extern BOOL GHTestStatusIsRunning(GHTestStatus status);

/*!
 Check if test has succeeded, errored or cancelled.
 */
extern BOOL GHTestStatusEnded(GHTestStatus status);

/*!
 Test stats.
 */
typedef struct {
  NSInteger succeedCount; // Number of succeeded tests
  NSInteger failureCount; // Number of failed tests
  NSInteger cancelCount; // Number of aborted tests
  NSInteger testCount; // Total number of tests 
} GHTestStats;

/*!
 Create GHTestStats.
 */
extern GHTestStats GHTestStatsMake(NSInteger succeedCount, NSInteger failureCount, NSInteger cancelCount, NSInteger testCount);

extern const GHTestStats GHTestStatsEmpty;

/*!
 Description from test stats.
 */
extern NSString *NSStringFromGHTestStats(GHTestStats stats);

@protocol GHTestDelegate;

/*!
 The base interface for a runnable test.

 A runnable with a unique identifier, display name, stats, timer, delegate, log and error handling.
 */
@protocol GHTest <NSObject, NSCoding, NSCopying>

/*!
 Unique identifier for test.
 */
@property (readonly, nonatomic) NSString *identifier;

/*!
 Name (readable) for test.
 */
@property (readonly, nonatomic) NSString *name;

/*!
 How long the test took to run. Defaults to -1, if not run.
 */
@property (assign, nonatomic) NSTimeInterval interval;

/*!
 Test status.
 */
@property (assign, nonatomic) GHTestStatus status;

/*!
 Test stats.
 */
@property (readonly, nonatomic) GHTestStats stats;

/*!
 Exception that occurred.
 */
@property (retain, nonatomic) NSException *exception;

/*!
 Whether test is disabled.
 */
@property (assign, nonatomic, getter=isDisabled) BOOL disabled;

/*!
 Whether test is hidden.
 */
@property (assign, nonatomic, getter=isHidden) BOOL hidden;

/*!
 Delegate for test.
 */
@property (assign, nonatomic) id<GHTestDelegate> delegate; // weak

/*!
 Run the test.
 @param options Options
 */
- (void)run:(GHTestOptions)options;

/*!
 @result Messages logged during this test run
 */
- (NSArray *)log;

/*!
 Reset the test.
 */
- (void)reset;

/*!
 Cancel the test.
 */
- (void)cancel;

/*!
 @result The number of disabled tests
 */
- (NSInteger)disabledCount;

@end

/*!
 Test delegate for notification when a test starts and ends.
 */
@protocol GHTestDelegate <NSObject>

/*!
 Test started.
 @param test Test
 @param source If tests are nested, than source corresponds to the originator of the delegate call
 */
- (void)testDidStart:(id<GHTest>)test source:(id<GHTest>)source;

/*!
 Test updated.
 @param test Test
 @param source If tests are nested, than source corresponds to the originator of the delegate call
 */
- (void)testDidUpdate:(id<GHTest>)test source:(id<GHTest>)source;

/*!
 Test ended.
 @param test Test
 @param source If tests are nested, than source corresponds to the originator of the delegate call
 */
- (void)testDidEnd:(id<GHTest>)test source:(id<GHTest>)source;

/*!
 Test logged a message.
 @param test Test
 @param didLog Message
 @param source If tests are nested, than source corresponds to the originator of the delegate call
 */
- (void)test:(id<GHTest>)test didLog:(NSString *)didLog source:(id<GHTest>)source;

@end

/*!
 Delegate which is notified of log messages from inside a test case.
 */
@protocol GHTestCaseLogWriter <NSObject>

/*!
 Log message.
 @param message Message
 @param testCase Test case
 */
- (void)log:(NSString *)message testCase:(id)testCase;

@end

/*!
 Default test implementation with a target/selector pair.

 - Tests a target and selector
 - Notifies a test delegate
 - Keeps track of status, running time and failures
 - Stores any test specific logging

 */
@interface GHTest : NSObject <GHTest, GHTestCaseLogWriter> {
  
  id target_;
  SEL selector_;
  
  NSString *identifier_;
  NSString *name_;  
  GHTestStatus status_;
  NSTimeInterval interval_;
  BOOL disabled_;
  BOOL hidden_;
  NSException *exception_; // If failed
    
  NSMutableArray *log_;

}

@property (readonly, strong, nonatomic) id target;
@property (readonly, nonatomic) SEL selector;
@property (readonly, strong, nonatomic) NSArray *log;

/*!
 Create test with identifier, name.
 @param identifier Unique identifier
 @param name Name
 */
- (id)initWithIdentifier:(NSString *)identifier name:(NSString *)name;

/*!
 Create test with target/selector.
 @param target Target (usually a test case)
 @param selector Selector (usually a test method)
 */
- (id)initWithTarget:(id)target selector:(SEL)selector;

/*!
 Create autoreleased test with target/selector.
 @param target Target (usually a test case)
 @param selector Selector (usually a test method)
 */
+ (id)testWithTarget:(id)target selector:(SEL)selector;

@end
