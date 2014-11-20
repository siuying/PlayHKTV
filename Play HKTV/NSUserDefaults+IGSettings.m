//
//  IGSettings.m
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import "NSUserDefaults+IGSettings.h"

static NSString* const PlaylistKey = @"playlist";
static NSString* const UUIDKey = @"uuid";
static NSString* const DefaultPlaylistURLString = @"http://ott-video-lb.hktvmall.com:8088/hktvlive.m3u8?uid=1&vid=1&d=pc&t=12e9a7f66f3a892b396e94d81206eb6c&mxres=1920&net=&udid=53FAB2F3-84C2-4BA7-B9A5-85605E0B4EC9&ts=1416472490490&s=4064e0937ef4fd1f61c7bfe5c47601c9";

@implementation NSUserDefaults(IGSettings)

-(NSString*) UUIDString
{
    NSString* UUIDString = [self objectForKey:UUIDKey];
    if (!UUIDString) {
        UUIDString = [[NSUUID UUID] UUIDString];
        [self setObject:UUIDString forKey:UUIDKey];
        [self synchronize];
    }
    return UUIDString;
}

-(NSURL*) lastPlaylistURL
{
    NSString* URLString = [self objectForKey:PlaylistKey];
    if (!URLString) {
        return [NSURL URLWithString:DefaultPlaylistURLString];
    }
    return [NSURL URLWithString:URLString];
}

-(void) setLastPlaylistURL:(NSURL*)playlistURL
{
    [self setObject:playlistURL.absoluteString forKey:PlaylistKey];
}

@end
