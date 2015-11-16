//
//  Product.m
//  Test_TillerSystems
//
//  Created by Thibault Le Cornec on 16/11/15.
//  Copyright © 2015 TillerSystems. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    return [self initWithName:dic[@"name"]
                        price:dic[@"price"]
                  andPosition:dic[@"position"]];
}



- (instancetype)initWithName:(NSString *)name
                       price:(NSNumber *)price
                 andPosition:(NSNumber *)position
{
    self = [super init];
    
    if (self)
    {
        _name = name;
        _price = price;
        _position = position;
    }
    
    return self;
}

@end
