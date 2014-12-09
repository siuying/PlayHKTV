//
//  IGHKTVClient.m
//  Play HKTV
//
//  Created by Francis Chong on 20/11/14.
//
//

#import "IGHKTVClient.h"

#import <IGDigest/NSString+MD5Digest.h>
#import <AFNetworking/AFHTTPSessionManager.h>

NSString* const IGHKTVErrorDomain = @"IGHKTVErrorDomain";

static NSString* const APIRoot = @"https://webservices.hktv.com.hk/";
static NSString* const APISecret = @"43e814b31f8764756672c1cd1217d775";

static NSString* const APIKi = @"12";
static NSString* const APIVid = @"1";
static NSString* const APIUid = @"1";
static NSString* const APIDevice = @"USB Android TV";
static NSString* const APIManufacturer = @"PlayHKTV";
static NSString* const APIModel = @"OSX";
static NSString* const APIOS = @"1.1.0";
static NSString* const APIMxres = @"1920";
static NSString* const APINetwork = @"fixed"; // 3G/4G/fixed/wifi

static NSString* const TokenPath = @"account/token";
static NSString* const PlaylistPath = @"playlist/request";

@interface IGHKTVClient()
@property (nonatomic, strong) AFHTTPSessionManager* httpClient;
@end
@implementation IGHKTVClient

-(instancetype) initWithUUID:(NSString*)UUIDString
{
    self = [super init];
    self.UUIDString = UUIDString;

    self.httpClient = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.httpClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    self.httpClient.securityPolicy.validatesDomainName = NO; // hktvmall cert use a wrong domain name!
    self.httpClient.securityPolicy.validatesCertificateChain = NO; // have to set to NO

    return self;
}

-(void) fetchPlaylistWithSuccess:(void(^)(NSURL* playlistURL))success
                         failure:(void(^)(NSError* error))failure
{
    [self fetchTokenWithSuccess:^(NSString *token, NSString *userId, NSString *userLevel, NSDate *expiry) {
        [self fetchPlaylistWithToken:token success:success failure:failure];
    } failure:failure];
}

#pragma mark - Private

-(void) fetchTokenWithSuccess:(void(^)(NSString *token, NSString *userId, NSString *userLevel, NSDate *expiry))success
                      failure:(void(^)(NSError* error))failure
{
    NSUInteger timestamp = [[NSDate date] timeIntervalSince1970];
    NSString* signature = [self generateSignatureWithPath:TokenPath
                                                timestamp:timestamp
                                               parameters:@[APIKi, APIUid]];
    
    NSDictionary* params = @{@"ki": APIKi, @"ts": [@(timestamp) description], @"s": signature, @"muid": APIUid};
    NSURLSessionDataTask* task = [self.httpClient POST:[NSString stringWithFormat:@"%@%@", APIRoot, TokenPath] parameters:params success:^(NSURLSessionDataTask *task, NSDictionary* jsonData) {
        if (!jsonData || ![jsonData isKindOfClass:[NSDictionary class]]) {
            failure([NSError errorWithDomain:IGHKTVErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"Unexpected data returned from HKTV."}]);
            return;
        }
        
        NSString* token = jsonData[@"token"];
        NSString* userId = jsonData[@"user_id"];
        NSString* userLevel = jsonData[@"user_level"];
        NSNumber* expiryDateTimestamp = jsonData[@"expiry_date"];
        NSDate* expiryDate = [NSDate dateWithTimeIntervalSince1970:expiryDateTimestamp.doubleValue];
        if (!token || !userId || !userLevel || !expiryDateTimestamp) {
            failure([NSError errorWithDomain:IGHKTVErrorDomain code:2 userInfo:@{NSLocalizedDescriptionKey: @"Cannot authenticate with HKTV."}]);
            return;
        }

        success(token, userId, userLevel, expiryDate);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    [task resume];
}

-(void) fetchPlaylistWithToken:(NSString*)token
                       success:(void(^)(NSURL* playlistURL))success
                       failure:(void(^)(NSError* error))failure
{
    NSUInteger timestamp = [[NSDate date] timeIntervalSince1970];
    NSString* signature = [self generateSignatureWithPath:PlaylistPath
                                                timestamp:timestamp
                                               parameters:@[APIDevice, APIKi, APIModel, APIManufacturer, APIMxres, APINetwork, APIOS, token, self.UUIDString, APIUid, APIVid]];
    NSDictionary* params = @{
        @"d": APIDevice,
        @"ki": APIKi,
        @"mdl": APIModel,
        @"mf": APIManufacturer,
        @"mxres": APIMxres,
        @"net": APINetwork,
        @"os": APIOS,
        @"t": token,
        @"udid": self.UUIDString,
        @"uid": APIUid,
        @"vid": APIVid,
        @"ts": [@(timestamp) description],
        @"s": signature
    };
    NSString* requeslURLString = [NSString stringWithFormat:@"%@%@", APIRoot, PlaylistPath];
    [self.httpClient POST:requeslURLString parameters:params success:^(NSURLSessionDataTask *task, NSDictionary* jsonData) {
        if (!jsonData || ![jsonData isKindOfClass:[NSDictionary class]]) {
            failure([NSError errorWithDomain:IGHKTVErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"Unexpected data returned from HKTV."}]);
            return;
        }

        NSString* m3u8 = jsonData[@"m3u8"];
        if (!m3u8) {
            failure([NSError errorWithDomain:IGHKTVErrorDomain code:2 userInfo:@{NSLocalizedDescriptionKey: @"Video not found!"}]);
            return;
        }

        success([NSURL URLWithString:m3u8]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

#pragma mark - Private

-(NSString*) generateSignatureWithPath:(NSString*)path timestamp:(NSUInteger)timestamp parameters:(NSArray*)parameters
{
    NSString* parametersString = [parameters componentsJoinedByString:@""];
    NSString* message = [NSString stringWithFormat:@"%@%@%@%@", path, parametersString, APISecret, @(timestamp)];
    return [message MD5HexDigest];
}

@end
