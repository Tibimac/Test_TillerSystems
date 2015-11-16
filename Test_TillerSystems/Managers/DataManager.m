//
//  DataManager.m
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 16/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

#import "DataManager.h"
#import "NetworkManager.h"
#import "Categorie.h"


static NSString* const clientTokenKey = @"49970acd-39d6-11e5-b995-0ab7c77dd804";
static NSString* const providerTokenKey = @"77429162-39d5-11e5-b995-0ab7c77dd804";


@implementation DataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once,
                  ^{
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}

+ (void)loadData
{
    [[NetworkManager sharedInstance] dataForKey:@"inventary"
                                 forClientToken:clientTokenKey
                               andProviderToken:providerTokenKey
                            withCompletionBlock:^(NSData *data, NSHTTPURLResponse *httpResponse, NSError *error)
     {
         [[DataManager sharedInstance] initDataWithDictionary:[NSJSONSerialization JSONObjectWithData:data
                                                                                              options:NSJSONReadingMutableContainers
                                                                                                error:&error]];
     }];
}



- (void)initDataWithDictionary:(NSDictionary *)dic
{
    NSArray *categories = [dic objectForKey:@"categories"];
    NSMutableArray *tempCategories = [[NSMutableArray alloc] init];
    
    for (NSDictionary *categorieDic in categories)
    {
        Categorie *categorie = [[Categorie alloc] initWithDictionary:categorieDic];
        [tempCategories addObject:categorie];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    [tempCategories sortedArrayUsingDescriptors:@[sortDescriptor]];
    _categories = [tempCategories copy];
}

@end
