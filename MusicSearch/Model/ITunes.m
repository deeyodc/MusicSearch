//
//  ITunes.m
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/2/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import "ITunes.h"

@implementation ITunes

@synthesize tracks = _tracks;

- (NSMutableArray *) tracks
{
        if (!_tracks)
            _tracks = [[NSMutableArray alloc]init];
        return _tracks;
}

- (void)search:(NSString *)searchString withCompletion:(void(^)(void))block
{
    //URL Encode the search String
    NSString *urlEncodedSearchString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //Limit search results to Songs and 100 items (this is double the default 50 items)
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&entity=song&limit=100",urlEncodedSearchString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __weak ITunes *weakSelf = self;
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error && data) {
                        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:nil];
                        int resultCount = [(NSNumber*)[res valueForKey:@"resultCount"] intValue];
                        if (resultCount >0){
                            //If there are any new search results, update the array of tracks and call the completion block
                            [weakSelf.tracks removeAllObjects];
                            NSArray *resultsArray = [res valueForKey:@"results"];
                            for (NSDictionary *trackDict in resultsArray){
                                Track *track = [Track initWithDictionary:trackDict];
                                [weakSelf.tracks addObject:track];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                block();
                            });
                        }
                    }
                }] resume];
}

@end
