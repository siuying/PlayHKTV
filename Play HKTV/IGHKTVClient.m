//
//  IGHKTVClient.m
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import "IGHKTVClient.h"

static NSString* const TokenURL = @"http://www.hktvmall.com/ott/token";
static NSString* const RequestURL = @"http://ott-www.hktvmall.com/api/playlist/request?uid=%@&t=%@&vid=1&udid=%@&ppos=1&_=%@";

@implementation IGHKTVClient

+(instancetype) sharedClient
{
    static dispatch_once_t onceToken;
    static IGHKTVClient* _client;
    dispatch_once(&onceToken, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

-(void) fetchPlaylistWithSuccess:(void(^)(NSURL* playlistURL))success
                         failure:(void(^)(NSError* error))failure
{
    [self fetchTokenWithSuccess:^(NSString *token, NSString *userId, NSString *userLevel, NSDate *expiry) {
        [self fetchPlaylistWithUserId:userId token:token success:success failure:failure];
    } failure:failure];
}

#pragma mark - Private

-(void) fetchTokenWithSuccess:(void(^)(NSString* token, NSString* userId, NSString* userLevel, NSDate* expiry))success
                      failure:(void(^)(NSError* error))failure
{
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:TokenURL]];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        
        NSError* jsonError;
        NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            failure(jsonError);
            return;
        }
        
        NSString* token = jsonData[@"token"];
        NSString* userId = jsonData[@"user_id"];
        NSString* userLevel = jsonData[@"user_level"];
        NSNumber* expiryDateTimestamp = jsonData[@"expiry_date"];
        NSDate* expiryDate = [NSDate dateWithTimeIntervalSince1970:expiryDateTimestamp.doubleValue];
        success(token, userId, userLevel, expiryDate);
        return;
    }];
    [task resume];
}

-(void) fetchPlaylistWithUserId:(NSString*)userId
                          token:(NSString*)token
                        success:(void(^)(NSURL* playlistURL))success
                        failure:(void(^)(NSError* error))failure
{
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:RequestURL, userId, token, [[NSUUID UUID] UUIDString], @([[NSDate date] timeIntervalSince1970])]]];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            failure(error);
            return;
        }
        
        NSError* jsonError;
        NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            failure(jsonError);
            return;
        }
        
        NSString* m3u8String = jsonData[@"m3u8"];
        success([NSURL URLWithString:m3u8String]);
        return;
    }];
    [task resume];
}

@end
