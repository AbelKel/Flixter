//
//  CollectionCell.h
//  Flixter
//
//  Created by Abel Kelbessa on 6/16/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

NS_ASSUME_NONNULL_END
