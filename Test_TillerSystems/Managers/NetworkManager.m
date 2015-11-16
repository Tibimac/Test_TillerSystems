//
//  NetworkManager.m
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 15/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

#import "NetworkManager.h"


static NSString* const kBaseURL = @"https://app.tillersystems.com/api/";


@implementation NetworkManager

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once,
                  ^{
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}



- (void)httpRequestMethod:(NSString *)method
                   forKey:(NSString *)key
           forClientToken:(NSString *)clientTokenKey
         andProviderToken:(NSString *)providerTokenKey
      withCompletionBlock:(importCompletion)completionBlock
{
    // ----- API URL Construction ----- //
    NSString *clientToken = [NSString stringWithFormat:@"restaurant_token=%@", clientTokenKey];
    NSString *providerToken = [NSString stringWithFormat:@"provider_token=%@", providerTokenKey];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@?%@&%@", kBaseURL, key, clientToken, providerToken];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    // ----- Request Creation ----- //
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // ----- Create Session ----- //
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // ----- Session Data Task ----- //
    NSURLSessionTask* dataTask = (NSURLSessionDataTask *)[session dataTaskWithRequest:request completionHandler:
                                                          ^(NSData *data, NSURLResponse *response, NSError *error)
                                                          {
                                                              completionBlock(data, (NSHTTPURLResponse *)response, error);
                                                          }];
    // ----- Execution of Task ----- //
    [dataTask resume];
}



- (void)dataForKey:(NSString *)key
    forClientToken:(NSString *)clientTokenKey
  andProviderToken:(NSString *)providerTokenKey
withCompletionBlock:(importCompletion)completionBlock
{
    [self httpRequestMethod:@"GET"
                     forKey:key
             forClientToken:clientTokenKey
           andProviderToken:providerTokenKey
        withCompletionBlock:completionBlock];
}

@end
