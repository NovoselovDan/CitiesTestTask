 //
//  VKAPI.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//



#import "VKAPI.h"
#import "UserSession.h"
#import "City.h"

@interface VKAPI()

@end

@implementation VKAPI
NSString *const APP_ID = @"5933969";
NSString *const BASE_URL = @"https://api.vk.com/";

+ (NSURL *)authURL {
    NSString *authLink = [NSString stringWithFormat:@"%@oauth/authorize?client_id=%@&scope=offline&redirect_uri=http://oauth.vk.com/blank.html&display=touch&response_type=token", BASE_URL, APP_ID];
    return [NSURL URLWithString:authLink];
}

+ (NSURL *)getCitiesWithOffset:(NSNumber *)offset andCount:(NSNumber *)count {
    NSURLComponents *components = [NSURLComponents componentsWithString:[BASE_URL stringByAppendingString:@"method/database.getCities"]];
    NSDictionary *parameters = @{
                                 @"country_id" : @"1",
                                 @"offset" : [offset stringValue],
                                 @"count" : [count stringValue],
                                 @"need_all" : @"1",
                                 @"access_token" : [[UserSession currentSession] accessToken]
                                 };
    
    NSMutableArray<NSURLQueryItem *> *querryItems = [NSMutableArray new];
    for (NSString *key in parameters.allKeys) {
        [querryItems addObject:[NSURLQueryItem queryItemWithName:key value:parameters[key]]];
    }
    components.queryItems = querryItems;
    
    return components.URL;
}


+ (NSArray *)citiesFromJSON:(NSData *)data {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (!error) {
        NSArray *citiesJSON = json[@"response"];
        NSMutableArray *cities = [NSMutableArray new];
        for (NSDictionary *cityJSON in citiesJSON) {
            City *city = [City cityFromJSONDictionary:cityJSON];
            if (city) {
                [cities addObject:city];
            }
        }
        return cities;
    }
    return nil;
}


@end
