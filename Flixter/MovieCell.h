//
//  MovieCell.h
//  Flixter
//
//  Created by Abel Kelbessa on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

NS_ASSUME_NONNULL_END
