//
//  IGSettings.h
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (IGSettings)

-(NSString*) UUIDString;

-(NSURL*) lastPlaylistURL;

-(void) setLastPlaylistURL:(NSURL*)playlistURL;

@end
