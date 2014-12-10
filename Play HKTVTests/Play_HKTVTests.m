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
    
    client = [[IGHKTVClient alloc] initWithUUID:[[NSUUID UUID] UUIDString]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPlaylist {
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

- (void)testToken {
    XCTestExpectation *apiRequestComplete = [self expectationWithDescription:@"API Request Complete"];
    [client fetchTokenWithSuccess:^(NSString *token, NSString *userId, NSString *userLevel, NSDate *expiry){
        [apiRequestComplete fulfill];
        XCTAssertNotNil(token);
    } failure:^(NSError *error) {
        XCTFail(@"API failed with error: %@", error);
        [apiRequestComplete fulfill];
    }];
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
    }];
}

- (void)testPrograms {
    XCTestExpectation *apiRequestComplete = [self expectationWithDescription:@"API Request Complete"];
    NSDate* lastUpdate = [NSDate dateWithTimeIntervalSince1970:0];
    [client fetchProgramsWithLastUpdate:lastUpdate perPage:30 offset:0 success:^(NSArray *videos) {
        [apiRequestComplete fulfill];
        XCTAssertNotNil(videos);
    } failure:^(NSError *error) {
        XCTFail(@"API failed: %@", error);
        [apiRequestComplete fulfill];
    }];
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
    }];
}


@end
