//
//  AppDelegate.h
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

