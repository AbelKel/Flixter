//
//  MovieViewController.m
//  Flixter
//
//  Created by Abel Kelbessa on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *fileredData;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.activityIndicator startAnimating];
}
    
- (void)fetchMovies{
    self.fileredData = self.movies;
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=5207470bba08dc70c5ca1fbed54e28c4"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error != nil) {
                   NSLog(@"%@", [error localizedDescription]);
                   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No internet connection detected"
                                                  message:@"error 001"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action) {}];
                    
                   [alert addAction:defaultAction];
                   [self presentViewController:alert animated:YES completion:nil];
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                   self.movies = dataDictionary[@"results"];
                   [self.activityIndicator stopAnimating];
                   NSLog(@"%@", self.movies);
                   for (NSDictionary *movie in self.movies){
                       NSLog(@"%@", movie[@"title"]);
                   }
                   [self.tableView reloadData];
                }
            
            [self.refreshControl endRefreshing];
               }];
        [task resume];
        }



    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"overview"];
    cell.detailsLabel.text = movie[@"title"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    cell.posterView.image = nil;
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [cell.posterView setImageWithURL: posterURL];
    //cell.textLabel.text = movie[@"title"];
    return cell;
}

//NSLog(@"%@", [NSString stringWithFormat:@"row:%d, section %d", indexPath.row, indexPath.section]);


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dataToPass = self.fileredData[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end
