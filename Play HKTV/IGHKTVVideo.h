//
//  IGHKTVVideo.h
//  Play HKTV
//
//  Created by Chan Fai Chong on 10/12/14.
//
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface IGHKTVVideo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString* videoId;
@property (nonatomic, assign) NSInteger videoLevel;
@property (nonatomic, strong) NSString* permissionLevel;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSURL* thumbnail;
@property (nonatomic, assign) NSInteger duration;

// NSArray<IGHKTVVideo>
@property (nonatomic, strong) NSArray* childNodes;

@end
