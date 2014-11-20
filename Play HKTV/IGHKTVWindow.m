//
//  IGHKTVWindow.m
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import "IGHKTVWindow.h"

@interface IGHKTVWindow()
@property (nonatomic, strong) IBOutlet VLCMediaPlayer* player;
@end

@implementation IGHKTVWindow

-(void) awakeFromNib
{
    [super awakeFromNib];
    self.player = [[VLCMediaPlayer alloc] initWithVideoView:self.videoView];
}

-(void) setPlaylistURL:(NSURL*)playlistURL
{
    [self.player setMedia:[VLCMedia mediaWithURL:playlistURL]];
    [self.player play];
}

@end
