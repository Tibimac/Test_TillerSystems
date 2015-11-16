//
//  Categorie.h
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 16/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;

@interface Categorie : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *position;
@property (strong, nonatomic) NSArray <Product*> *products;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
