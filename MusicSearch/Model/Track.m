//
//  Track.m
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/2/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import "Track.h"

@implementation Track

+(Track*)initWithDictionary:(NSDictionary *)trackDictionary
{
    if(!trackDictionary || ![trackDictionary objectForKey:@"trackName"])
        return nil;
    Track *newTrack = [[Track alloc]init];
    newTrack.trackName = [trackDictionary objectForKey:@"trackName"];
    newTrack.artistName = [trackDictionary objectForKey:@"artistName"];
    newTrack.collectionName = [trackDictionary objectForKey:@"collectionName"];
    newTrack.artworkUrl100 = [NSURL URLWithString:[trackDictionary objectForKey:@"artworkUrl100"]];
    newTrack.artworkUrl60 = [NSURL URLWithString:[trackDictionary objectForKey:@"artworkUrl60"]];
    return newTrack;
}

- (void)getImageDataForSize:(CGSize)size withCompletion:(void(^)(NSData *, NSString*))block
{
    __weak Track *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSData *imageData;
        //Get artWork image data for appropriate size
        if (size.width <= 65)
            imageData= [NSData dataWithContentsOfURL:weakSelf.artworkUrl60];
        else
            imageData= [NSData dataWithContentsOfURL:weakSelf.artworkUrl100];
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            block(imageData,[weakSelf.artworkUrl60 absoluteString]);
        });
    });
}

- (void)getLyricsWithCompletion:(void(^)(NSString*))block
{
    NSMutableString *urlEncodedArtistName = [self.artistName mutableCopy];
    [urlEncodedArtistName replaceOccurrencesOfString:@" " withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, [self.artistName length])];
    NSMutableString *urlEncodedTrackName = [self.trackName mutableCopy];
    [urlEncodedTrackName replaceOccurrencesOfString:@" " withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, [self.trackName length])];
    
    NSString *urlString = [NSString stringWithFormat:@"https://lyrics.wikia.com/api.php?func=getSong&artist=%@&song=%@&fmt=json",urlEncodedArtistName,urlEncodedTrackName];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error && data) {
                        NSError *jsonError;
                        NSMutableString *tempString = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        //data is not in valid JSON format
                        //Remove "song = "
                        [tempString deleteCharactersInRange:NSMakeRange(0, 7)];
                        //Replace single quotes. They are not valid JSON http://www.jsonlint.com/
                        [tempString replaceOccurrencesOfString:@"'" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [tempString length])];
                        NSData *jsonData = [tempString dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingAllowFragments
                                                                            error:&jsonError];
                        if (!jsonError && res){
                            NSMutableString *lyrics = [res[@"lyrics"] mutableCopy];
                            //Change back the double quotes to single in lyrics
                            [lyrics replaceOccurrencesOfString:@"\"" withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, [lyrics length])];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                block(lyrics);
                            });
                        }
                        else {
                            if(jsonError)
                                NSLog(@"JSON Error parsing response: %@\n",jsonError);
                            NSLog(@"Unable to get Lyrics!\n");
                        }
                    }
                }] resume];
}

@end
