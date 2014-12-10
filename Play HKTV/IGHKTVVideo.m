//
//  IGHKTVVideo.m
//  Play HKTV
//
//  Created by Chan Fai Chong on 10/12/14.
//
//

#import "IGHKTVVideo.h"

@implementation IGHKTVVideo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
         @"childNodes": @"child_nodes",
         @"category": @"category",
         @"duration": @"duration",
         @"permissionLevel": @"permission_level",
         @"thumbnail": @"thumbnail",
         @"title": @"title",
         @"videoLevel": @"video_level",
         @"videoId": @"video_id",
     };
}

+ (NSValueTransformer *)thumbnailJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSURL URLWithString:str];
    } reverseBlock:^(NSURL *URL) {
        return [URL absoluteString];
    }];
}

+ (NSValueTransformer *)childNodesJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *jsonData) {
        NSError* error;
        NSArray* videos = [MTLJSONAdapter modelsOfClass:[IGHKTVVideo class] fromJSONArray:jsonData error:&error];
        return videos;
    }];
}

-(NSString*) description
{
    NSString* childNodes = self.childNodes.count > 0 ? [NSString stringWithFormat:@"%@ children", @(self.childNodes.count)] : @"";
    return [NSString stringWithFormat:@"<IGHKTVVideo %@, %@>", self.title, childNodes];
}

@end
