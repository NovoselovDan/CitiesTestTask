//
//  NSString+extraMethods.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 23.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "NSString+extraMethods.h"

@implementation NSString (extraMethods)

- (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
{
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

@end
