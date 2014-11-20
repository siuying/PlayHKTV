//
//  AppDelegate.h
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import <Cocoa/Cocoa.h>

#import "IGHKTVWindow.h"
#import "IGHKTVClient.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, weak) IBOutlet IGHKTVWindow* window;
@property (nonatomic, weak) IGHKTVClient* client;

@end

