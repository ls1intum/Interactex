/*
GHViewTestCase.h
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

#import "GHTestCase.h"
#import <UIKit/UIKit.h>

/*!
 Assert that a view has not changed. Raises exception if the view has changed or if
 no image exists from previous test runs.

 @param view The view to verify
 */
#define GHVerifyView(view) \
do { \
if (![self isKindOfClass:[GHViewTestCase class]]) \
[[NSException ghu_failureWithName:@"GHInvalidTestException" \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ \
reason:@"GHVerifyView can only be called from within a GHViewTestCase class"] raise]; \
[self verifyView:view filename:[NSString stringWithUTF8String:__FILE__] lineNumber:__LINE__]; \
} while (0)

/*!
 View verification test case.

 Supports GHVerifyView, which renders a view and compares it against a saved
 image from a previous test run.

     @interface MyViewTest : GHViewTestCase { }
     @end

     @implementation MyViewTest

     - (void)testMyView {
       MyView *myView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
       GHVerifyView(myView);
     }

     @end

 In order to record results across test runs, the PrepareUITests.sh script needs
 to be run as a build step. This script copies any test images (saved locally in
 $PROJECT_DIR/TestImages) to the app bundle so that calls to GHVerifyView have
 images from previous runs with which to compare.

 After changes to views are approved in the simulator, the CopyTestImages.sh script
 should be run manually in Terminal. This script copies any approved view changes
 back to the project directory. Images are saved with filenames of the following format:

     [test class name]-[test selector name]-[UIScreen scale]-[# of call to GHVerifyView in selector]-[view class name].png

 Note that because of differences in text rendering between retina and non-retina
 devices/simulators, different images are saved for test runs using retina then
 non-retina.

 Also note that there are commonly rendering differences across iOS versions.
 Therefore it is common for tests to fail when they are run using a different iOS
 version then the one that created the saved test image. This also applies to tests
 that are run at the command line (the xcodebuild flag '-sdk iphonesimulator'
 usually corresponds to the latest iOS simulator available).
 */
@interface GHViewTestCase : GHTestCase {
  NSInteger imageVerifyCount_;
}

/*!
 Clear all test images in the documents directory
 */
+ (void)clearTestImages;

/*!
 Save an image to the documents directory as filename

 @param image Image to save
 @param filename Filename for the saved image
 */
+ (void)saveToDocumentsWithImage:(UIImage *)image filename:(NSString *)filename;

/*!
 Size for a given view. Subclasses can override this to provide custom sizes
 for views before rendering. The default implementation returns contentSize
 for scrollviews and returns self.frame.size for all other views.

 @param view View for which to calculate the size
 @result Size at which the view should be rendered
 */
- (CGSize)sizeForView:(UIView *)view;

/*!
 Called from the GHVerifyView macro. This method should not be called manually.
 Verifies that a view hasn't changed since the last time it was approved. Raises
 a GHViewChangeException if the view has changed. Raises a GHViewUnavailableException
 if there is no image from a previous run.

 @param view View to verify
 @param filename Filename of the call to GHVerifyView
 @param lineNumber Line number of the call to GHVerifyView
 */
- (void)verifyView:(UIView *)view filename:(NSString *)filename lineNumber:(int)lineNumber;

@end
