//
//  CityStore.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "CityStore.h"
#import "VKAPI.h"

@interface CityStore()

@property (strong, nonatomic) NSNumber *offset;
@property (strong, nonatomic) NSNumber *count;
@property (assign, nonatomic) BOOL didLoadFullList;
@property (assign, nonatomic) BOOL needsUpdateUsingCities;

@property (strong, nonatomic) NSMutableArray *vkCities;
@property (strong, nonatomic) NSMutableArray *userCities;
@property (strong, nonatomic) NSMutableArray *usingCities;

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation CityStore

- (instancetype)init {
    if (self = [super init]) {
        _offset = [NSNumber numberWithInteger:0];
        _count = [NSNumber numberWithInteger:100];
        _didLoadFullList = NO;
        _needsUpdateUsingCities = NO;
        
        _vkCities = [NSMutableArray new];
        _userCities = [NSMutableArray new];
        _usingCities = [NSMutableArray new];
        
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        return self;
    } else
        return nil;
}

- (NSArray *)allCites {
    if (_needsUpdateUsingCities) {
        [self updateUsingCities];
    }
    return _usingCities;
}

- (void)updateUsingCities {
    _usingCities = [NSMutableArray new];
    if (_userCities.count > 0) {
        _usingCities = [[_usingCities arrayByAddingObjectsFromArray:_userCities] mutableCopy];
    }
    if (_vkCities.count > 0) {
        _usingCities = [[_usingCities arrayByAddingObjectsFromArray:_vkCities] mutableCopy];
    }
    
    _needsUpdateUsingCities = NO;
}

/*
- (City *)createNewCity {
    City *newCity = [City new];
    newCity.title = [[NSDate date] description];
    newCity.cityID = @(_allCities.count + 1000);
    [_allCities addObject:newCity];
    
    return newCity;
}
*/

- (void)addCity:(City *)city {
    if (![_userCities containsObject:city]) {
        [_userCities addObject:city];
        _needsUpdateUsingCities = YES;
    }
}

- (void)addCities:(NSArray<City *> *)cities {
    for (City *city in cities) {
        [self addCity:city];
    }
}

- (void)removeCity:(City *)city {
    if ([_userCities containsObject:city]) {
        [_userCities removeObject:city];
        _needsUpdateUsingCities = YES;
    }
}


- (void)fetchCitiesFirst:(BOOL)firstFetch completion:(void (^)(NSArray *, BOOL, NSError *))completion {
    if (firstFetch) {
        _offset = @(0);
    }
    NSURL *url = [VKAPI getCitiesWithOffset:_offset andCount:_count];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSArray *cities = [VKAPI citiesFromJSON:data];
            if (cities) {
                if (cities.count < _count.integerValue) {
                    _didLoadFullList = YES;
                }
                if (_offset.integerValue == 0) {
                    _vkCities = [cities mutableCopy];
                } else {
                    [_vkCities addObjectsFromArray:cities];
                }
                _needsUpdateUsingCities = YES;
                [self updateUsingCities];
                _offset = @(_offset.integerValue + 100);
                completion(cities, _didLoadFullList, nil);
            }
            
        } else {
            NSLog(@"FETCH CITIES ERROR: %@", error.localizedDescription);
            completion(nil, NO, error);
        }
    }];
    [task resume];
}



@end
