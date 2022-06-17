//
//  DetailsViewController.m
//  Flixter
//
//  Created by Abel Kelbessa on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *TitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *BigPosterView;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SmallPosterView;



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.detailDict);
    self.TitleLable.text = self.detailDict[@"title"];
    self.DescriptionLabel.text = self.detailDict[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.detailDict[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    self.BigPosterView.image = nil;
    self.SmallPosterView.image = nil;
    [self.SmallPosterView setImageWithURL:posterURL];
    
    
    NSString *posterURLStringBig = self.detailDict[@"backdrop_path"];
    NSString *fullPosterURLStringBig = [baseURLString stringByAppendingString:posterURLStringBig];
    NSURL *posterURLBig = [NSURL URLWithString:fullPosterURLStringBig];

    [self.BigPosterView setImageWithURL:posterURLBig];
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
