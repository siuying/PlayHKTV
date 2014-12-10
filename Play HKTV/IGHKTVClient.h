//
//  IGHKTVClient.h
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

extern NSString* const IGHKTVErrorDomain;

@interface IGHKTVClient : NSObject

@property (nonatomic, strong) NSString* UUIDString;

-(instancetype) initWithUUID:(NSString*)UUIDString;

-(void) fetchTokenWithSuccess:(void(^)(NSString *token, NSString *userId, NSString *userLevel, NSDate *expiry))success
                      failure:(void(^)(NSError* error))failure;

-(void) fetchPlaylistWithSuccess:(void(^)(NSURL* playlistURL))success
                         failure:(void(^)(NSError* error))failure;

-(void) fetchProgramsWithLastUpdate:(NSDate*)date
                            perPage:(NSInteger)perPage
                             offset:(NSUInteger)offset
                            success:(void(^)(NSArray* programs))success
                            failure:(void(^)(NSError* error))failure;

@end
