//
//  imageSelectController.m
//  softDecorationMaster
//
//  Created by tianpengfei on 16/3/3.
//  Copyright © 2016年 tianpengfei. All rights reserved.
//

#import "imageSelectController.h"

@interface imageSelectController ()

@end

@implementation imageSelectController

- (instancetype)init{
    if(self = [super init]){
          _data = [self getData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WPEditorConfiguration *_WPEditorConfiguration = [WPEditorConfiguration sharedWPEditorConfiguration];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView reloadData];
}
-(NSArray *)getData{

    NSMutableArray *tableArray = [NSMutableArray new];
    
    WPEditorConfiguration *_WPEditorConfiguration = [WPEditorConfiguration sharedWPEditorConfiguration];
    
    NSArray *textData = @[CustomLocalisedString(@"photoLibrary",@"从相册中选择"),CustomLocalisedString(@"takePhoto",@"拍照")];
    
    NSArray *imageSelect = @[@(ZSSRichTextEditorImageSelectPhotoLibrary),@(ZSSRichTextEditorImageSelectTakePhoto)];
    
    for (int i =0; i<imageSelect.count; i++) {
        
        
         NSInteger imageSelectType = [imageSelect[i] integerValue];
        
        if((imageSelectType & _WPEditorConfiguration.enableImageSelect) == imageSelectType){
        
            [tableArray addObject:textData[i]];
        }
    }
    
    return tableArray;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageSelectCell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageSelectCell"];
    [cell.textLabel setText:_data[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

      if([_delegate respondsToSelector:@selector(imageSelectType:)])
          [_delegate imageSelectType:(int)indexPath.row];

}
@end
