//
//  AuthViewController.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 20.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "AuthViewController.h"
#import "NSString+extraMethods.h"
#import "VKAPI.h"
#import "UserSession.h"

@interface AuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(closeVC)];
    [_toolbar setItems:@[cancelButton]];
    
    
    [_webView loadRequest: [NSURLRequest requestWithURL:[VKAPI authURL]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"URL: %@", webView.request.URL.absoluteString);
    if ([webView.request.URL.absoluteString containsString:@"access_token"]) {
        NSString *accessToken = [webView.request.URL.absoluteString stringBetweenString:@"access_token=" andString:@"&"];
        if (accessToken) {
            [[UserSession currentSession] setAccessToken:accessToken];
        }
        NSArray *userIDinfoArr = [webView.request.URL.absoluteString componentsSeparatedByString:@"user_id="];
        NSString *userID = [userIDinfoArr lastObject];
        if (userID) {
            [[UserSession currentSession] setUserID:userID];
        }
                
        [self performSegueWithIdentifier:@"dismissAuthVC" sender:self];
    } else if ([_webView.request.URL.absoluteString containsString:@"error"]) {
        NSLog(@"Auth error: %@", webView.request.URL.absoluteString);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
