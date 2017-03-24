//
//  City.h
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (strong, nonatomic) NSNumber *cityID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *area; //область
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSDate *foundationDate;
@property (strong, nonatomic) NSURL *areaImageURL;

+ (City *)cityFromJSONDictionary:(NSDictionary *)json;

- (instancetype)initWithCityID:(NSNumber *)cityID
                         title:(NSString *)title
                          area:(NSString*)area
                        region:(NSString *)region;

@end
