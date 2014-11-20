//
//  AppDelegate.h
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import <Cocoa/Cocoa.h>

#import "IGVideoWindow.h"
#import "IGHKTVClient.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak) IBOutlet IGVideoWindow* window;
@property (nonatomic, strong) IGHKTVClient* client;

@end

