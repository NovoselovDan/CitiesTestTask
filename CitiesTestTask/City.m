//
//  City.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "City.h"

@implementation City

+ (City *)cityFromJSONDictionary:(NSDictionary *)json {
    City *city = [[City alloc] initWithCityID:json[@"cid"] ? json[@"cid"] : nil
                                        title:json[@"title"] ? json[@"title"] : nil
                                         area:json[@"area"] ? json[@"area"] : nil
                                       region:json[@"region"] ? json[@"region"] : nil];
    return city;
}

- (instancetype)initWithCityID:(NSNumber *)cityID title:(NSString *)title area:(NSString *)area region:(NSString *)region {
    if (self = [super init]) {
        self.cityID = cityID;
        self.title = title;
        if (area) {
            self.area = area;
        }
        if (region) {
            self.region = region;
        }
        
        return self;
    } else
        return nil;
}

@end
