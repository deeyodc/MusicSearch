//
//  ITunes.h
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/2/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Track.h"
@interface ITunes : NSObject

//Public array of tracks / songs as search results
@property (nonatomic, strong) NSMutableArray *tracks;

//Method for a new search
- (void) search:(NSString *)searchString withCompletion:(void(^)(void))block;

@end
