//
//  IGHKTVClient.h
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface IGHKTVClient : NSObject

+(instancetype) sharedClient;

-(void) fetchPlaylistWithSuccess:(void(^)(NSURL* playlistURL))success
                         failure:(void(^)(NSError* error))failure;

@end
