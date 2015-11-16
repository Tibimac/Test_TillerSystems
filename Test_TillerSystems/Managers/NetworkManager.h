//
//  NetworkManager.h
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 15/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^importCompletion)(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error);


@interface NetworkManager : NSObject

+(instancetype)sharedInstance;

- (void)dataForKey:(NSString *)key
    forClientToken:(NSString *)clientTokenKey
  andProviderToken:(NSString *)providerTokenKey
withCompletionBlock:(importCompletion)completionBlock;

@end
