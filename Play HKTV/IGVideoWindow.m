//
//  IGHKTVWindow.m
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import "IGVideoWindow.h"

@interface IGVideoWindow()
@property (nonatomic, strong) IBOutlet VLCMediaPlayer* player;
@end

@implementation IGVideoWindow

-(void) awakeFromNib
{
    [super awakeFromNib];

    // config view
    self.player = [[VLCMediaPlayer alloc] initWithVideoView:self.videoView];
    self.collectionBehavior = NSWindowCollectionBehaviorFullScreenPrimary;
}

-(void) setPlaylistURL:(NSURL*)playlistURL
{
    [self.player setMedia:[VLCMedia mediaWithURL:playlistURL]];
    [self.player play];
}

#pragma mark - Private

-(void) doubleClicked:(id)sender
{
    NSLog(@"toggle fullscreen");
    [self toggleFullScreen:sender];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if([theEvent clickCount] == 2)
    {
        [self toggleFullScreen:nil];
    }
}

@end
