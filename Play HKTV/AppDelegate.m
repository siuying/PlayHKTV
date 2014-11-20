//
//  AppDelegate.m
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import "AppDelegate.h"
#import "IGHKTVClient.h"
#import "IGHKTVWindow.h"

static NSString* const PlaylistKey = @"playlist";

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[IGHKTVClient sharedClient] fetchPlaylistWithSuccess:^(NSURL *playlistURL) {
        [self.window setPlaylistURL:playlistURL];
        
        // cache the URL
        [[NSUserDefaults standardUserDefaults] setObject:playlistURL.absoluteString forKey:PlaylistKey];

    } failure:^(NSError *error) {
        // if we failed to retrieve the playlist...
        NSLog(@"failed to get token: %@", error);
        NSString* playlistURLString = [[NSUserDefaults standardUserDefaults] objectForKey:PlaylistKey];
        if (playlistURLString) {
            NSLog(@"use cached url: %@", playlistURLString);
            [self.window setPlaylistURL:[NSURL URLWithString:playlistURLString]];
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
