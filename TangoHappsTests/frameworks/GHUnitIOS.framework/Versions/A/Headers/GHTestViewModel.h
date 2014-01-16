/*
GHTestViewModel.h
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

#import "GHTestGroup.h"
#import "GHTestSuite.h"
#import "GHTestRunner.h"

@class GHTestNode;

@protocol GHTestNodeDelegate <NSObject>
- (void)testNodeDidChange:(GHTestNode *)node;
@end

typedef enum {
  GHTestNodeFilterNone = 0,
  GHTestNodeFilterFailed = 1
} GHTestNodeFilter;

/*!
 Test view model for use in a tree view.
 */
@interface GHTestViewModel : NSObject <GHTestNodeDelegate> {
	
  NSString *identifier_;
	GHTestSuite *suite_;
	GHTestNode *root_;
	
	GHTestRunner *runner_;
	
	NSMutableDictionary *map_; // id<GHTest>#identifier -> GHTestNode

	BOOL editing_;

	NSMutableDictionary *defaults_;
}

@property (readonly, nonatomic) GHTestNode *root;
@property (assign, nonatomic, getter=isEditing) BOOL editing;

/*!
 Create view model with root test group node.

 @param identifier Unique identifier for test model (used to load defaults)
 @param suite Suite
 */
- (id)initWithIdentifier:(NSString *)identifier suite:(GHTestSuite *)suite;

/*!
 @result Name of test suite.
 */
- (NSString *)name;

/*!
 Status description.

 @param prefix Prefix to append
 @result Current status string
 */
- (NSString *)statusString:(NSString *)prefix;

/*!
 Find the test node from the test.

 @param test Find test
 */
- (GHTestNode *)findTestNodeForTest:(id<GHTest>)test;

/*!
 Find the first failure.

 @result The first failure
 */
- (GHTestNode *)findFailure;

/*!
 Find the next failure starting from node.

 @param node Node to start from
 */
- (GHTestNode *)findFailureFromNode:(GHTestNode *)node;

/*!
 Register node, so that we can do a lookup later. See findTestNodeForTest:.

 @param node Node to register
 */
- (void)registerNode:(GHTestNode *)node;

/*!
 @result Returns the number of test groups.
 */
- (NSInteger)numberOfGroups;

/*!
 Returns the number of tests in group.
 @param group Group number
 @result The number of tests in group.
 */
- (NSInteger)numberOfTestsInGroup:(NSInteger)group;

/*!
 Search for path to test.
 @param test Test
 @result Index path
 */
- (NSIndexPath *)indexPathToTest:(id<GHTest>)test;

/*!
 Load defaults (user settings saved with saveDefaults).
 */
- (void)loadDefaults;

/*!
 Save defaults (user settings to be loaded with loadDefaults).
 */
- (void)saveDefaults;

/*!
 Run with current test suite.

 @param delegate Callback
 @param inParallel If YES, will run tests in operation queue
 @param options Options
 */
- (void)run:(id<GHTestRunnerDelegate>)delegate inParallel:(BOOL)inParallel options:(GHTestOptions)options;

/*!
 Cancel test run.
 */
- (void)cancel;

/*!
 Check if running.

 @result YES if running.
 */
- (BOOL)isRunning;

@end


@interface GHTestNode : NSObject {

	id<GHTest> test_;
	NSMutableArray */*of GHTestNode*/children_;
  NSMutableArray */* of GHTestNode*/filteredChildren_;

	id<GHTestNodeDelegate> __unsafe_unretained delegate_;
  GHTestNodeFilter filter_;
  NSString *textFilter_;
}

@property (readonly, strong, nonatomic) NSArray */* of GHTestNode*/children;
@property (readonly, strong, nonatomic) id<GHTest> test;
@property (unsafe_unretained, nonatomic) id<GHTestNodeDelegate> delegate;
@property (assign, nonatomic) GHTestNodeFilter filter;
@property (strong, nonatomic) NSString *textFilter;

- (id)initWithTest:(id<GHTest>)test children:(NSArray */*of id<GHTest>*/)children source:(GHTestViewModel *)source;
+ (GHTestNode *)nodeWithTest:(id<GHTest>)test children:(NSArray */*of id<GHTest>*/)children source:(GHTestViewModel *)source;

- (NSString *)identifier;
- (NSString *)name;
- (NSString *)nameWithStatus;

- (GHTestStatus)status;
- (NSString *)statusString;
- (NSString *)stackTrace;
- (NSString *)exceptionFilename;
- (NSInteger)exceptionLineNumber;
- (NSString *)log;
- (BOOL)isRunning;
- (BOOL)isDisabled;
- (BOOL)isHidden;
- (BOOL)isEnded;
- (BOOL)isGroupTest; // YES if test has "sub tests"

- (BOOL)isSelected;
- (void)setSelected:(BOOL)selected;

- (BOOL)hasChildren;
- (BOOL)failed;

- (void)notifyChanged;

- (void)setFilter:(GHTestNodeFilter)filter textFilter:(NSString *)textFilter;

@end

//! @endcond
