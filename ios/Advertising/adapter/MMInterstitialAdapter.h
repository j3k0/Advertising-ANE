//
//  MMInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#if ENABLE_MM

#import "AbstractAdAdapter.h"
#import <MillennialMedia/MMSDK.h>
#import <MillennialMedia/MMInterstitial.h>

@interface MMInterstitialAdapter : AbstractAdAdapter {
    
    Boolean cached_;
}

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end

#endif