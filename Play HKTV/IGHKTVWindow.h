//
//  IGHKTVWindow.h
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import <Cocoa/Cocoa.h>
#import <VLCKit/VLCKit.h>

@interface IGHKTVWindow : NSWindow

@property (nonatomic, strong) IBOutlet VLCVideoView* videoView;

-(void) setPlaylistURL:(NSURL*)playlistURL;

@end
