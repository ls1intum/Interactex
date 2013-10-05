/*
GHTestSuite.h
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

#import "GHTestGroup.h"

/*!
 If set, will run it as a "test filter" like the env variable TEST.
 */
extern NSString *GHUnitTest;


/*!
 Test suite is an alias for test group.
 
 A test case is an instance of a test case class with test methods.
 A test is a id<GHTest> which represents a target and a selector.
 A test group is a collection of tests; A collection of id<GHTest> (GHTest or GHTestGroup).
 
 For example, if you have 2 test cases, GHTestCase1 (with some test methods) and GHTestCase2 (with some test methods), 
 your test suite might look like:
 
"Tests" (GHTestSuite)
  GHTestGroup (collection of tests from GHTestCase1)
    - (void)testA1 (GHTest with target GHTestCase1 + testA1)
    - (void)testA2 (GHTest with target GHTestCase1 + testA2)
  GHTestGroup (collection of tests from GHTestCase2)
    - (void)testB1; (GHTest with target GHTestCase2 + testB1)
    - (void)testB2; (GHTest with target GHTestCase2 + testB2)  
 
 */
@interface GHTestSuite : GHTestGroup { }

/*! 
 Create test suite with test cases.
 @param name Label to give the suite
 @param testCases Array of init'ed test case classes
 @param delegate Delegate
 */
- (id)initWithName:(NSString *)name testCases:(NSArray *)testCases delegate:(id<GHTestDelegate>)delegate;

/*!
 Creates a suite of all tests.
 Will load all classes that subclass from GHTestCase, SenTestCase or GTMTestCase (or register test case class).
 @result Suite
 */
+ (GHTestSuite *)allTests;

/*!
 Create suite of tests with filter.
 This is useful for running a single test or all tests in a single test case.
 
 For example,
 'GHSlowTest' -- Runs all test method in GHSlowTest
 'GHSlowTest/testSlowA -- Only runs the test method testSlowA in GHSlowTest
 
 @param testFilter Test filter
 @result Suite
 */
+ (GHTestSuite *)suiteWithTestFilter:(NSString *)testFilter;

/*!
 Create suite of tests that start with prefix.
 @param prefix If test case class starts with the prefix; If nil or empty string, returns all tests
 @param options Compare options
 */
+ (GHTestSuite *)suiteWithPrefix:(NSString *)prefix options:(NSStringCompareOptions)options;

/*!
 Suite for a single test/method.
 @param testCaseClass Test case class
 @param method Method
 @result Suite
 */
+ (GHTestSuite *)suiteWithTestCaseClass:(Class)testCaseClass method:(SEL)method;

/*!
 Return test suite based on environment (TEST=TestFoo/foo)
 @result Suite
 */
+ (GHTestSuite *)suiteFromEnv;

@end

@interface GHTestSuite (JUnitXML)

- (BOOL)writeJUnitXMLToDirectory:(NSString *)directory error:(NSError **)error;

@end

//! @endcond
