//
//  MissionDetailViewController.m
//  AFNetworking
//
//  Created by 魏优优 on 2021/6/1.
//

#import "MissionDetailViewController.h"
#import <Masonry/Masonry.h>
#import "MissionDetailCell.h"

static NSString *reuseCellIdentifier = @"MissionDetailCell";

@interface MissionDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation MissionDetailViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    self.title = @"Mission Details";

    [self setupSubViews];
//
    [self fetchListData];
}

- (void)setupSubViews {
    [self.view addSubview:self.detailTableView];
    
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)fetchListData {
    self.arr = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        
        [self.arr addObject:[NSString stringWithFormat:@"hello%d",i]];
    }
}

#pragma mark -- UITableViewDelegate、UITableViewDataSource


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.arr.count;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    TYMissionHomeListModel *model = [TYMissionHomeListModel new];
    MissionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    [cell setData:self.arr[indexPath.row]];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击哈哈哈---%@",_arr[indexPath.row]);
}



#pragma mark - getters

- (UITableView *)detailTableView{
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.rowHeight = UITableViewAutomaticDimension;
        _detailTableView.estimatedRowHeight = 100;
        _detailTableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        [_detailTableView registerClass:[MissionDetailCell class] forCellReuseIdentifier:reuseCellIdentifier];
        _detailTableView.tableFooterView = [UIView new];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [_detailTableView addGestureRecognizer:longTap];
    }
    return _detailTableView;
}


#pragma mark - Cell拖动排序
- (void)handlelongGesture:(UILongPressGestureRecognizer *)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [sender locationInView:self.detailTableView];
    NSIndexPath *indexPath = [self.detailTableView indexPathForRowAtPoint:location];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.detailTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.detailTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0.0f;
                    
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... update data source.
                // 这里需要注意，我是以section为单位写的
                //[self.dateList exchangeObjectAtIndex:indexPath.section withObjectAtIndex:sourceIndexPath.section];
                // ... move the rows.
                // 你要看你是拖动section还是拖动row了[]([]())
                // [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                //[self.tableView moveSection:sourceIndexPath.section toSection:indexPath.section];
                // ... and update source so it is in sync with UI changes.
                //sourceIndexPath = indexPath;
                
                if (sourceIndexPath.section == indexPath.section) {

//                    NSString *sectionModel = self.arr[sourceIndexPath.section];
//                    [sectionModel.data exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];

                    //[self.tableView reloadData];
                    [self.detailTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    
                    sourceIndexPath = indexPath;
                }
                
            }
            break;
        }
        
        default: {
            // Clean up.
            UITableViewCell *cell = [self.detailTableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0f;
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView
{
    UIView *snapshot = nil;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {
        //ios7.0 以下通过截图形式保存快照
        snapshot = [self customSnapShortFromViewEx:inputView];
    }else{
        //ios7.0 系统的快照方法
        snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    }
    
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (UIView *)customSnapShortFromViewEx:(UIView *)inputView{
    CGSize inSize = inputView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(inSize, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    
    return snapshot;
}



@end
