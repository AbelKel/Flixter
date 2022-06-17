//
//  CollectionViewController.m
//  Flixter
//
//  Created by Abel Kelbessa on 6/16/22.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import "UIImageView+AFNetworking.h"


@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self fetchMovies];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}
- (void)fetchMovies{
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

                   NSLog(@"%@", self.movies);
                   for (NSDictionary *movie in self.movies){
                       NSLog(@"%@", movie[@"title"]);
                   }
                   [self.collectionView reloadData];
                }
               }];
        [task resume];
        }


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    cell.cellView.image = nil;
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [cell.cellView setImageWithURL: posterURL];
    return cell;
}

- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int oddEven = indexPath.row / numberOfCellsPerRow % 2;
    int dimensions = (CGFloat)(totalwidth / numberOfCellsPerRow);
    if (oddEven == 0) {
        return CGSizeMake(dimensions, dimensions);
    } else {
        return CGSizeMake(dimensions, dimensions / 2);
    }
}

#pragma mark <UICollectionViewDelegate>


@end
