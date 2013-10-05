/*
GHTesting.h
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
#import "GHUnit.h"


// GTM_BEGIN
BOOL isTestFixtureOfClass(Class aClass, Class testCaseClass);
// GTM_END

/*! 
 Utility test for loading and running tests.

 Much of this is borrowed from GTM/UnitTesting.
 */
@interface GHTesting : NSObject { 

  NSMutableArray/* of NSString*/ *testCaseClassNames_;
  
}

/*!
 The shared testing instance.
 */
+ (GHTesting *)sharedInstance;

/*!
 Load all test classes that we can "see".
 @result Array of initialized (and autoreleased) test case classes in an autoreleased array.
 */
- (NSArray *)loadAllTestCases;

/*!
 Load tests from target.
 @param target Target
 @result Array of id<GHTest>
 */
- (NSArray *)loadTestsFromTarget:(id)target;

/*!
 See if class is of a registered test case class.
 @param aClass Class
 */
- (BOOL)isTestCaseClass:(Class)aClass;

/*!
 Register test case class.
 @param aClass Class
 */
- (void)registerClass:(Class)aClass;

/*!
 Register test case class by name.
 @param className Class name (via NSStringFromClass(aClass)
 */
- (void)registerClassName:(NSString *)className;

/*!
 Format test exception.
 @param exception Exception
 @result Description
 */
+ (NSString *)descriptionForException:(NSException *)exception;

/*!
 Filename for cause of test exception.
 @param test Test
 @result Filename
 */
+ (NSString *)exceptionFilenameForTest:(id<GHTest>)test;

/*!
 Line number for cause of test exception.
 @param test Test
 @result Line number
 */
+ (NSInteger)exceptionLineNumberForTest:(id<GHTest>)test;

/*!
 Run test.
 @param target Target
 @param selector Selector
 @param exception Exception, if set, is retained and should be released by the caller.
 @param interval Time to run the test
 @param reraiseExceptions If YES, will re-raise exceptions
 */
+ (BOOL)runTestWithTarget:(id)target selector:(SEL)selector exception:(NSException **)exception 
       interval:(NSTimeInterval *)interval reraiseExceptions:(BOOL)reraiseExceptions;

/*!
 Same as normal runTest without catching exceptions.
 @param target Target
 @param selector Selector
 @param exception Exception, if set, is retained and should be released by the caller.
 @param interval Time to run the test
 */
+ (BOOL)runTestOrRaiseWithTarget:(id)target selector:(SEL)selector exception:(NSException **)exception interval:(NSTimeInterval *)interval;

@end

@protocol GHSenTestCase 
- (void)raiseAfterFailure;
@end

//! @endcond
