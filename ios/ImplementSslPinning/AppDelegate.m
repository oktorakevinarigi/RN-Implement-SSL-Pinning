/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <TrustKit/TrustKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  // Initialize TrustKit
  NSDictionary *trustKitConfig =
    @{
    // Auto-swizzle NSURLSession delegates to add pinning validation
    kTSKSwizzleNetworkDelegates: @YES,
    kTSKPinnedDomains: @{
       // Pin invalid SPKI hashes to *.yahoo.com to demonstrate pinning failures
       @"kurs.web.id" : @{
           kTSKEnforcePinning:@YES,
           kTSKIncludeSubdomains:@YES,
           kTSKPublicKeyAlgorithms : @[kTSKAlgorithmRsa2048],
           // Wrong SPKI hashes to demonstrate pinning failure
           kTSKPublicKeyHashes : @[
              @"P3XJ3eiIyOGj9v2AZGfVf5jbSWSq+8bgkAqutvMapm8=",
              @"aR6DUqN8qK4HQGhBpcDLVnkRAvOHH1behpQUU1Xl7fE="
              ],
          // Send reports for pinning failures
          // Email info@datatheorem.com if you need a free dashboard to see your App's reports
          kTSKReportUris: @[@"https://overmind.datatheorem.com/trustkit/report"]
          },
     }};

  [TrustKit initSharedInstanceWithConfiguration:trustKitConfig];
  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"ImplementSslPinning"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
