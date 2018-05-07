//
//  SongVC.m
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/5/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import "SongVC.h"

@interface SongVC ()

@property (nonatomic,weak) IBOutlet UIImageView *artWork;
@property (nonatomic,weak) IBOutlet UILabel *trackName;
@property (nonatomic,weak) IBOutlet UILabel *artistName;
@property (nonatomic,weak) IBOutlet UILabel *collectionName;
@property (nonatomic,weak) IBOutlet UITextView *lyrics;

@end

@implementation SongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.track) {
        self.trackName.text = self.track.trackName;
        self.artistName.text = self.track.artistName;
        self.collectionName.text = self.track.collectionName;
        __weak SongVC *weakSelf = self;
        [self.track getImageDataForSize:self.artWork.frame.size withCompletion:^(NSData *artWorkData, NSString *artWorkUrlString) {
            weakSelf.artWork.image = [UIImage imageWithData:artWorkData];
        }];
        [self.track getLyricsWithCompletion:^(NSString *lyrics){
            weakSelf.lyrics.text = lyrics;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
