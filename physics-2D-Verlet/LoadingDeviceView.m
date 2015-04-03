    //
//  LoadingDeviceView.m
//  spareparts
//
//  Created by Adam Wulf on 4/3/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "LoadingDeviceView.h"
#import "SaveLoadManager.h"
#import "Constants.h"

@interface LoadingDeviceView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation LoadingDeviceView{
    UICollectionView* collectionView;
}

@synthesize delegate;

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UIView* bitsOfWhite = [[UIView alloc] initWithFrame:self.bounds];
        bitsOfWhite.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        beView.frame = self.bounds;
        [beView.contentView addSubview:bitsOfWhite];
        [self addSubview:beView];
        
        
        CGRect collectionFrame = CGRectInset(self.bounds, 100, 200);
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kThumbnailSize, kThumbnailSize);
        layout.minimumLineSpacing = 40;
        layout.headerReferenceSize = CGSizeMake(40, kThumbnailSize);
        layout.footerReferenceSize = CGSizeMake(40, kThumbnailSize);
        collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:layout];
        collectionView.layer.borderColor = [UIColor grayColor].CGColor;
        collectionView.layer.borderWidth = 2;
        collectionView.layer.cornerRadius = 10;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerClass:[UICollectionViewCell class]
           forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self addSubview:collectionView];
        
        UIButton* cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancel setTitle:@"cancel" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cancel sizeToFit];
        [self addSubview:cancel];
        cancel.center = CGPointMake(collectionView.frame.origin.x + collectionView.bounds.size.width - cancel.bounds.size.width, collectionView.frame.origin.y - cancel.bounds.size.height);
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

-(void) reloadData{
    [collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[SaveLoadManager sharedInstance] allSavedItems] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* items = [[SaveLoadManager sharedInstance] allSavedItems];
    NSDictionary* item = [items objectAtIndex:indexPath.row];
    UICollectionViewCell* cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 2;
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
    UIImage* img = [UIImage imageWithContentsOfFile:[item objectForKey:@"thumb"]];
    imgView.image = img;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:imgView];
    
    
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, 40)];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = [item objectForKey:@"name"];
    [cell.contentView addSubview:name];
    
    UIButton* delete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [delete setTitle:@"Delete" forState:UIControlStateNormal];
    [delete sizeToFit];
    [cell.contentView addSubview:delete];
    delete.center = CGPointMake(cell.bounds.size.width/2, cell.bounds.size.height - delete.bounds.size.height);
    
    [delete addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void) deleteItem:(UIButton*)button{
    NSArray* cells = [collectionView visibleCells];
    for (UICollectionViewCell* cell in cells){
        if([cell.contentView.subviews containsObject:button]){
            NSIndexPath* path = [collectionView indexPathForCell:cell];
            NSArray* items = [[SaveLoadManager sharedInstance] allSavedItems];
            NSDictionary* item = [items objectAtIndex:path.row];
            [[SaveLoadManager sharedInstance] deleteItemForName:[item objectForKey:@"name"]];
            [collectionView deleteItemsAtIndexPaths:@[path]];
            
        }
    }
}




#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSArray* items = [[SaveLoadManager sharedInstance] allSavedItems];
    NSDictionary* item = [items objectAtIndex:indexPath.row];
    
    [self.delegate loadDeviceNamed:[item objectForKey:@"name"]];

    
    [self removeFromSuperview];
}

-(void) cancelButtonPressed:(id)button{
    [self.delegate cancelLoadingDevice];
    [self removeFromSuperview];
}

@end
