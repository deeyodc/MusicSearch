//
//  Track.h
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/2/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Track : NSObject

@property (nonatomic,strong) NSString *trackName;
@property (nonatomic,strong) NSString *artistName;
@property (nonatomic,strong) NSString *collectionName;
@property (nonatomic,strong) NSURL *artworkUrl100;
@property (nonatomic,strong) NSURL *artworkUrl60;
@property (nonatomic,strong) NSString *lyrics;

+(Track*)initWithDictionary:(NSDictionary *)trackDictionary;
- (void)getImageDataForSize:(CGSize)size withCompletion:(void(^)(NSData *, NSString*))block;
- (void)getLyricsWithCompletion:(void(^)(NSString *))block;

@end
