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

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSArray *fileredData;
@property (strong, nonatomic) NSArray *filteredMovie;
@property (nonatomic, strong) NSArray *movies; // array to populate with movies and their details that come along with them
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.search.delegate = self;

    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.activityIndicator startAnimating]; // enableing movement in the animation
    self.filteredMovie = self.fileredData;
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
                                                  preferredStyle:UIAlertControllerStyleAlert]; // pop up altert
                    
                   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action) {}]; //"Try again" button
                    
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
            
            [self.refreshControl endRefreshing]; // ending refreshing with the assumption that there is an internet connection
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
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString]; // link formation
    cell.posterView.image = nil;
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [cell.posterView setImageWithURL: posterURL]; // setting image
    //cell.textLabel.text = movie[@"title"];
    return cell;
}


#pragma mark - Navigation

// Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dataToPass = self.fileredData[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}

// search bar does not work
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject containsString:searchText];
        }];
        self.filteredMovie = [self.movies filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredMovie);
        
    }
    else {
        self.filteredMovie = self.movies;
    }
    
    [self.tableView reloadData];
 
}


@end
