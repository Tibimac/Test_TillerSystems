//
//  Categorie.m
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 16/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#import "Categorie.h"
#import "Product.h"

@implementation Categorie

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    return [self initWithName:dic[@"name"]
                     products:dic[@"products"]
                  andPosition:dic[@"position"]];
}



- (instancetype)initWithName:(NSString *)name
                    products:(NSArray *)products
                 andPosition:(NSNumber *)position
{
    self = [super init];
    
    if (self)
    {
        _name = name;
        _position = position;
        
        NSMutableArray *tempProducts = [[NSMutableArray alloc] init];
        
        for (NSDictionary *productDic in products)
        {
            Product *product = [[Product alloc] initWithDictionary:productDic];
            [tempProducts addObject:product];
        }
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
        [tempProducts sortedArrayUsingDescriptors:@[sortDescriptor]];
        _products = [tempProducts copy];
    }
    
    return self;
}

@end
