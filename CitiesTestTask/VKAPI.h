//
//  VKAPI.h
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAPI : NSObject

+ (NSURL *)authURL;
+ (NSURL *)getCitiesWithOffset:(NSNumber *)offset andCount:(NSNumber *)count;

+ (NSArray *)citiesFromJSON:(NSData *)data;
@end
