//
//  SongTVCell.h
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/3/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface SongTVCell : UITableViewCell

@property (nonatomic, strong) Track *track;
@property (nonatomic,weak) IBOutlet UIImageView *artWork;

@end
