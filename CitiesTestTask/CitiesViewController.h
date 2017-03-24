//
//  CitiesViewController.h
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityStore.h"

@interface CitiesViewController : UIViewController

@property (strong, nonatomic) CityStore *cityStore;

@end
