//
//  AppDelegate.m
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import "AppDelegate.h"

#import "IGHKTVClient.h"
#import "IGVideoWindow.h"
#import "NSUserDefaults+IGSettings.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];

    self.client = [[IGHKTVClient alloc] initWithUUID:[[NSUUID UUID] UUIDString]];
    [self.client fetchPlaylistWithSuccess:^(NSURL *playlistURL) {
        [self.window setPlaylistURL:playlistURL];
        
        // cache the URL
        [settings setLastPlaylistURL:playlistURL];

    } failure:^(NSError *error) {
        // if we failed to retrieve the playlist...
        NSLog(@"failed to get token: %@", error);
        NSURL* playlistURL = [settings lastPlaylistURL];
        if (playlistURL) {
            NSLog(@"use cached url: %@", playlistURL);
            [self.window setPlaylistURL:playlistURL];
        } else {
            [[NSAlert alertWithError:error] runModal];
        }
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
    return YES;
}

@end
