//
//  DataManager.h
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 16/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Categorie;

@interface DataManager : NSObject

@property (strong, nonatomic) NSArray <Categorie*> __block *categories;

+ (instancetype)sharedInstance;
+ (void)loadDataWithCompletionBlock:(void (^)(void))completionBlock;

@end
