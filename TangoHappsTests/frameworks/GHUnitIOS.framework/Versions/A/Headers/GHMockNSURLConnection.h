/*
GHMockNSURLConnection.h
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

#import <Foundation/Foundation.h>

extern NSString *const GHMockNSURLConnectionException;

/*!
 NSURLConnection for mocking.
 
 Use with GHAsyncTestCase to mock out connections.
 
     @interface GHNSURLConnectionMockTest : GHAsyncTestCase {}
     @end
     
     @implementation GHNSURLConnectionMockTest
     
     - (void)testMock {
       [self prepare];
       GHMockNSURLConnection *connection = [[GHMockNSURLConnection alloc] initWithRequest:nil delegate:self];	
       [connection receiveHTTPResponseWithStatusCode:204 headers:testHeaders_ afterDelay:0.1];
       [connection receiveData:testData_ afterDelay:0.2];
       [connection finishAfterDelay:0.3];
       [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
     }
     
     - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
       GHAssertEquals([(NSHTTPURLResponse *)response statusCode], 204, nil);
       GHAssertEqualObjects([(NSHTTPURLResponse *)response allHeaderFields], testHeaders_, nil);
     }
     
     - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
       GHAssertEqualObjects(data, testData_, nil);
     }
     
     - (void)connectionDidFinishLoading:(NSURLConnection *)connection {
       [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testMock)];
     }
     @end

 */
@interface GHMockNSURLConnection : NSObject {
	NSURLRequest *request_;
	id delegate_; // weak
	
	BOOL cancelled_;	
	BOOL started_;
}

@property (readonly, nonatomic, getter=isStarted) BOOL started;
@property (readonly, nonatomic, getter=isCancelled) BOOL cancelled;

// Mocked version of NSURLConnection#initWithRequest:delegate:
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate;

// Mocked version of NSURLConnection#initWithRequest:delegate:startImmediately:
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately;

// Mocked version of NSURLConnection#scheduleInRunLoop:forMode: (NOOP)
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;

// Mocked version of NSURLConnection#start (NOOP)
- (void)start;

/*!
 Send generic response to delegate after delay.
 (For asynchronous requests)
 @param response Response
 @param afterDelay Delay in seconds (if < 0, there is no delay)
 */
- (void)receiveResponse:(NSURLResponse *)response afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send HTTP response to delegate with status code, headers, after delay.
 This is only the HTTP response (and not data or finished).
 (For asynchronous requests)
 @param statusCode HTTP status code
 @param headers Headers
 @param afterDelay Delay in seconds (if < 0, there is no delay)
 */
- (void)receiveHTTPResponseWithStatusCode:(int)statusCode headers:(NSDictionary *)headers afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send data to connection delegate after delay.
 @param data Data to send
 @param afterDelay Delay in seconds
 */
- (void)receiveData:(NSData *)data afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send data to connection delegate.
 @param data Data to send
 @param statusCode HTTP status code
 @param MIMEType Mime type
 @param afterDelay Delay
 */
- (void)receiveData:(NSData *)data statusCode:(NSInteger)statusCode MIMEType:(NSString *)MIMEType afterDelay:(NSTimeInterval)afterDelay;

/*!
 Send data (from file in bundle resource) to connection delegate after delay.
 (For asynchronous requests)
 @param path Path to file
 @param afterDelay Delay in seconds
 */
- (void)receiveDataFromPath:(NSString *)path afterDelay:(NSTimeInterval)afterDelay;

/*!
 Calls connectionDidFinish: delegate after delay.
 (For asynchronous requests)
 @param delay Delay in seconds (if < 0, there is no delay)
 */
- (void)finishAfterDelay:(NSTimeInterval)delay;

/*!
 Sends mock response, sends data, and then calls finish.
 (For asynchronous requests)
 @param path Path to load data from. File should be available in Test target (bundle)
 @param statusCode Status code for response
 @param MIMEType Content type for response header
 @param afterDelay Delay before responding (if < 0, there is no delay)
 */
- (void)receiveFromPath:(NSString *)path statusCode:(NSInteger)statusCode MIMEType:(NSString *)MIMEType afterDelay:(NSTimeInterval)afterDelay;

/*!
 Sends mock response, sends data, and then calls finish.
 (For asynchronous requests)
 @param data Data to load. File should be available in Test target (bundle)
 @param statusCode Status code for response
 @param MIMEType Content type for response header
 @param afterDelay Delay before responding (if < 0, there is no delay)
 */ 
- (void)receiveData:(NSData *)data statusCode:(NSInteger)statusCode MIMEType:(NSString *)MIMEType afterDelay:(NSTimeInterval)afterDelay;

/*!
 Calls connection:didFailWithError: on delegate after specified delay.
 @param error The error to pass to the delegate.
 @param afterDelay Delay before responding (if < 0, there is no delay)
 */
- (void)failWithError:(NSError *)error afterDelay:(NSTimeInterval)afterDelay;

@end
