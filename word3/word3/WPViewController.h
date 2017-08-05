#import <UIKit/UIKit.h>
#import "WPEditorViewController.h"
#import "publishedArticleViewModel.h"
#import "WPEditorConfiguration.h"

@interface WPViewController : WPEditorViewController <WPEditorViewControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,retain)publishedArticleViewModel *viewModel;
@end
