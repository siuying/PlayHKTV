//
//  Play_HKTVTests.m
//  Play HKTVTests
//
//  Created by Francis Chong on 20/11/14.
//
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "IGHKTVClient.h"

@interface Play_HKTVTests : XCTestCase{
    IGHKTVClient* client;
}
@end

@implementation Play_HKTVTests

- (void)setUp {
    [super setUp];
    
    client = [[IGHKTVClient alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *apiRequestComplete = [self expectationWithDescription:@"API Request Complete"];
    [client fetchPlaylistWithSuccess:^(NSURL *playlistURL) {
        [apiRequestComplete fulfill];
        XCTAssertNotNil(playlistURL);
        XCTAssertTrue([[playlistURL absoluteString] hasPrefix:@"http://"]);
    } failure:^(NSError *error) {
        [apiRequestComplete fulfill];
        XCTFail(@"API failed with error: %@", error);
    }];
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
    }];
}

@end
