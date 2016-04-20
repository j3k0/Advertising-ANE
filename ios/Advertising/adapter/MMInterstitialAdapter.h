//
//  MMInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "AbstractAdAdapter.h"
#import <MMAdSDK/MMAdSDK.h>

@interface MMInterstitialAdapter : AbstractAdAdapter {
    
    Boolean cached_;
}

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end
