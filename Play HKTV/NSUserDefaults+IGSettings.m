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
        return nil;
    }
    return [NSURL URLWithString:URLString];
}

-(void) setLastPlaylistURL:(NSURL*)playlistURL
{
    [self setObject:playlistURL.absoluteString forKey:PlaylistKey];
}

@end
