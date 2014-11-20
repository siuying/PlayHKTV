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

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[IGHKTVClient sharedClient] fetchPlaylistWithSuccess:^(NSURL *playlistURL) {
        [self.window setPlaylistURL:playlistURL];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

@end
