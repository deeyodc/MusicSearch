//
//  SongTVCell.m
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/3/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import "SongTVCell.h"

@interface SongTVCell()

@property (nonatomic,weak) IBOutlet UILabel *trackName;
@property (nonatomic,weak) IBOutlet UILabel *artistName;
@property (nonatomic,weak) IBOutlet UILabel *collectionName;

@end

@implementation SongTVCell

@synthesize track = _track;

-(void) setTrack:(Track *)track
{
    self.trackName.text = track.trackName;
    self.artistName.text = track.artistName;
    self.collectionName.text = track.collectionName;
    _track = track;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
