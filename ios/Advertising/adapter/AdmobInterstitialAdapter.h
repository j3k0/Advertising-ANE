//
//  AdmobInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 31/8/14.
//
//

#if ENABLE_ADMOB

#import "AbstractAdAdapter.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface AdmobInterstitialAdapter : AbstractAdAdapter <GADInterstitialDelegate>{
    
    GADInterstitial* adView_;    
}
@property (nonatomic, retain) GADInterstitial* adView;

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end

#endif