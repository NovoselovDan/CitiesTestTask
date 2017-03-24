//
//  CityStore.h
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface CityStore : NSObject

- (NSArray *)allCites;

//- (City *)createNewCity;
- (void)addCity:(City *)city;
- (void)addCities:(NSArray<City *> *)cities;
- (void)removeCity:(City *)city;

- (void)fetchCitiesFirst:(BOOL)firstFetch completion:(void (^)(NSArray *fetchedCities, BOOL didLoadFullList, NSError *error))completion;


@end
