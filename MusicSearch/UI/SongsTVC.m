//
//  SongsTVC.m
//  MusicSearch
//
//  Created by Deeyo Dela Cruz on 5/5/18.
//  Copyright © 2018 Deeyo Solutions. All rights reserved.
//

#import "SongsTVC.h"
#import "ITunes.h"
#import "Track.h"
#import "SongTVCell.h"
#import "SongVC.h"

@interface SongsTVC ()

@property (nonatomic,strong) ITunes *iTunes;
@property (nonatomic,strong) NSMutableDictionary *artWorks;
@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;

@end

@implementation SongsTVC

@synthesize iTunes = _iTunes;
@synthesize artWorks = _artWorks;

-(ITunes*)iTunes
{
    if(!_iTunes)
        _iTunes = [[ITunes alloc]init];
    return _iTunes;
}
-(NSMutableDictionary*) artWorks
{
    if(!_artWorks)
        _artWorks = [[NSMutableDictionary alloc]init];
    return _artWorks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.artWorks = nil;
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0){
        __weak SongsTVC *weakSelf = self;
        [self.iTunes search:searchBar.text withCompletion:^{
            weakSelf.artWorks = nil;
            [weakSelf.searchBar resignFirstResponder];
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.iTunes.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCellReuseIdentifier" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(SongTVCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Track *track = self.iTunes.tracks[indexPath.row];
    cell.artWork.image = nil;
    cell.track = track;
    
    // Maintain a dictionary of artworks. This avoids having to download the artwork everytime a cell is refreshed
    // Alternative approach would be to save the NSData in file system but since only 100 items in results, this works
    NSData *imageData = [self.artWorks objectForKey:[track.artworkUrl60 absoluteString] ];
    if(imageData){
        cell.artWork.image = [UIImage imageWithData:imageData];
    }
    else {
        __block UIImageView *artWork = cell.artWork;
        __block NSMutableDictionary *artworks = self.artWorks;
        [track getImageDataForSize:cell.artWork.frame.size withCompletion:^(NSData *artWorkData, NSString *artWorkUrlString) {
            [artworks setObject:artWorkData forKey:artWorkUrlString];
            artWork.image = [UIImage imageWithData:artWorkData];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 70;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Set Track information before segue
    SongVC *songVC = [segue destinationViewController];
    songVC.track = self.iTunes.tracks[self.tableView.indexPathForSelectedRow.row];
}

@end
