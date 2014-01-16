/*
GHTestGroup.h
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

Martijn ten Bhömer from TU Eindhoven contributed PureData support. Contact: m.t.bhomer@tue.nl.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#import "GHTest.h"
#import "GHTestCase.h"

/*!
 Interface for a group of tests.

 This group conforms to the GHTest protocol as well (see Composite pattern).
 */
@protocol GHTestGroup <GHTest>

/*!
 Name.
 */
- (NSString *)name;

/*!
 Parent for test group.
 */
- (id<GHTestGroup>)parent;

/*!
 Children for test group.
 */
- (NSArray *)children;

@end

/*!
 A collection of tests (or test groups).

 A test group is a collection of `id<GHTest>`, that may represent a set of test case methods. 
 
 For example, if you had the following GHTestCase.

     @interface FooTest : GHTestCase {}
     - (void)testFoo;
     - (void)testBar;
     @end
 
 The GHTestGroup would consist of and array of GHTest: FooTest#testFoo, FooTest#testBar, 
 each test being a target and selector pair.

 A test group may also consist of a group of groups (since GHTestGroup conforms to GHTest),
 and this might represent a GHTestSuite.
 */
@interface GHTestGroup : NSObject <GHTestDelegate, GHTestGroup> {
  
  id<GHTestGroup> __unsafe_unretained parent_; // weak
  
  NSMutableArray */*of id<GHTest>*/children_;
    
  NSString *name_; // The name of the test group (usually the class name of the test case
  NSTimeInterval interval_; // Total time of child tests
  GHTestStatus status_; // Current status of the group (current status of running or completed child tests)
  GHTestStats stats_; // Current stats for the group (aggregate of child test stats)
  
  BOOL didSetUpClass_;
  
  GHTestOptions options_;
  
  // Set if test is created from initWithTestCase:delegate:
  // Allows use to perform setUpClass and tearDownClass (once per test case run)
  id testCase_; 
  
  NSException *exception_; // If exception happens in group setUpClass/tearDownClass
}

@property (readonly, strong, nonatomic) NSArray */*of id<GHTest>*/children;
@property (unsafe_unretained, nonatomic) id<GHTestGroup> parent;
@property (readonly, strong, nonatomic) id testCase;
@property (assign, nonatomic) GHTestOptions options;

/*!
 Create an empty test group.
 @param name The name of the test group
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
- (id)initWithName:(NSString *)name delegate:(id<GHTestDelegate>)delegate;

/*!
 Create test group from a test case.
 @param testCase Test case, could be a subclass of SenTestCase or GHTestCase
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
- (id)initWithTestCase:(id)testCase delegate:(id<GHTestDelegate>)delegate;

/*!
 Create test group from a single test.
 @param testCase Test case, could be a subclass of SenTestCase or GHTestCase
 @param selector Test to run 
 @param delegate Delegate, notifies of test start and end
 */
- (id)initWithTestCase:(id)testCase selector:(SEL)selector delegate:(id<GHTestDelegate>)delegate;

/*!
 Create test group from a test case.
 @param testCase Test case, could be a subclass of SenTestCase or GHTestCase
 @param delegate Delegate, notifies of test start and end
 @result New test group
 */
+ (GHTestGroup *)testGroupFromTestCase:(id)testCase delegate:(id<GHTestDelegate>)delegate;

/*!
 Add a test case (or test group) to this test group.
 @param testCase Test case, could be a subclass of SenTestCase or GHTestCase
 */
- (void)addTestCase:(id)testCase;

/*!
 Add a test group to this test group.
 @param testGroup Test group to add
 */
- (void)addTestGroup:(GHTestGroup *)testGroup;

/*!
 Add tests to this group.
 @param tests Tests to add
 */
- (void)addTests:(NSArray */*of id<GHTest>*/)tests;

/*!
 Add test to this group.
 @param test Test to add
 */
- (void)addTest:(id<GHTest>)test;

/*!
 Whether the test group should run on the main thread.
 Call passes to test case instance if enabled.
 */
- (BOOL)shouldRunOnMainThread;

/*!
 @result YES if we have any enabled chilren, NO if all children have been disabled.
 */
- (BOOL)hasEnabledChildren;

/*!
 Get list of failed tests.
 @result Failed tests
 */
- (NSArray */*of id<GHTest>*/)failedTests;

/*!
 Run in operation queue.
 Tests from the group are added and will block until they have completed.
 @param operationQueue If nil, then runs as is
 @param options Options
 */
- (void)runInOperationQueue:(NSOperationQueue *)operationQueue options:(GHTestOptions)options;

@end

//! @endcond
