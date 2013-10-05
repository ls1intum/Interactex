/*
GHTestCase.h
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

#import "GHTestMacros.h"
#import "GHTest.h"

/*!
 Log to your test case logger. For example,

    GHTestLog(@"Some debug info, %@", obj);

 */
#define GHTestLog(...) [self log:[NSString stringWithFormat:__VA_ARGS__, nil]]

/*!
 The base class for a test case. 
 
     @interface MyTest : GHTestCase {}
     @end
     
     @implementation MyTest
     
     // Run before each test method
     - (void)setUp { }

     // Run after each test method
     - (void)tearDown { }

     // Run before the tests are run for this class
     - (void)setUpClass { }

     // Run before the tests are run for this class
     - (void)tearDownClass { }
     
     // Tests are prefixed by 'test' and contain no arguments and no return value
     - (void)testA { 
       GHTestLog(@"Log with a test with the GHTestLog(...) for test specific logging.");
     }

     // Another test; Tests are run in lexical order
     - (void)testB { }
     
     // Override any exceptions; By default exceptions are raised, causing a test failure
     - (void)failWithException:(NSException *)exception { }
     
     @end

 */
@interface GHTestCase : NSObject {
  id<GHTestCaseLogWriter> __unsafe_unretained logWriter_; // weak

  SEL currentSelector_;
}

//! The current test selector
@property (assign, nonatomic) SEL currentSelector; 
@property (unsafe_unretained, nonatomic) id<GHTestCaseLogWriter> logWriter;

// GTM_BEGIN
//! Run before each test method
- (void)setUp;

//! Run after each test method
- (void)tearDown;

/*! 
 By default exceptions are raised, causing a test failure

 @param exception Exception that was raised by test
 */
- (void)failWithException:(NSException*)exception;
// GTM_END

/*! 
 Run before the tests (once per test case).
 */
- (void)setUpClass;

/*! 
 Run after the tests (once per test case).
 */
- (void)tearDownClass;

/*!
 Whether to run the tests on a separate thread. Override this method in your
 test case to override the default.
 Default is NO, tests are run on a separate thread by default.

 @result If YES, the test will run on the main thread
 */
- (BOOL)shouldRunOnMainThread;

/*! 
 Any special handling of exceptions after they are thrown; By default logs stack trace to standard out.
 @param exception Exception
 */
- (void)handleException:(NSException *)exception;

/*!
 Log a message, which notifies the log delegate.
 This is not meant to be used directly, see GHTestLog(...) macro.

 @param message Message to log
 */
- (void)log:(NSString *)message;

/*!
 Whether the test class should be run as a part of command line tests.
 By default this is NO. Subclasses can override this method to disable
 test classes that are problematic at the command line.

 @result YES if this test class is disabled for command line tests
 */
- (BOOL)isCLIDisabled;

@end
