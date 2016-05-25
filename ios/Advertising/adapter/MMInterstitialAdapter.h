//
//  MMInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#if ENABLE_MM_INTERSTITIAL

#import "AbstractAdAdapter.h"
#import <MMAdSDK/MMAdSDK.h>

@interface MMInterstitialAdapter : AbstractAdAdapter <MMInterstitialDelegate> {
    
    MMInterstitialAd *mmInterstitialAd_;
}

@property (strong, nonatomic) MMInterstitialAd *mmInterstitialAd;

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end

#endif