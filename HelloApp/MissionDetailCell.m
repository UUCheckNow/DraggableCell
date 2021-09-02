//
//  MissionDetailCell.m
//  AFNetworking
//
//  Created by 魏优优 on 2021/6/1.
//

#import "MissionDetailCell.h"
#import <Masonry/Masonry.h>
@interface MissionDetailCell ()
/// 无事件提示
@property (nonatomic, strong) UILabel *noEventLable;

/// 日期
@property (nonatomic, strong) UILabel *dateLabel;

@end


@implementation MissionDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        [self setupSubviews];
    }
    return  self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


- (void)setupSubviews {
    [self.contentView addSubview:self.noEventLable];
//    [self.contentView addSubview:self.dateLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    
    [self.noEventLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//
//    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.noEventLable.mas_bottom).offset(20);
//        make.leading.trailing.equalTo(@0);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
//    }];
    
}

- (UILabel *)noEventLable {
    if (!_noEventLable) {
        _noEventLable = [[UILabel alloc] init];
        _noEventLable.font = [UIFont systemFontOfSize:14];
        _noEventLable.backgroundColor = UIColor.greenColor;
        [_noEventLable setText:@"hello"];
    }
    return _noEventLable;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.backgroundColor = UIColor.redColor;
        _dateLabel.numberOfLines = 0;
        [_dateLabel setText:@"_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel_dataLabel"];
    }
    return _dateLabel;
}

- (void)setData:(NSString *)model {
    self.noEventLable.text = model;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
