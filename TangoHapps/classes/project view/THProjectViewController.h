
#import <Foundation/Foundation.h>

@class TFProject;
@class TFLayer;
@class THPalette;
@class THTabbarViewController;
@class THEditorToolsViewController;

@interface THProjectViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate, CCDirectorDelegate> {
    
    UILabel * _titleLabel;
    UITextField * _titleTextField;
    
    UIBarButtonItem * _playButton;
    UIBarButtonItem * _stopButton;
    
    NSString * _currentProjectName;
}

@property (nonatomic, readonly) TFLayer * currentLayer;
@property (nonatomic, readonly) CCScene * currentScene;
@property (nonatomic, readonly) CCGLView * glview;
@property (nonatomic, readonly) TFAppState state;
@property (nonatomic, readonly) THTabbarViewController * tabController;
@property (nonatomic, readonly) THEditorToolsViewController * toolsController;
@property (nonatomic, strong) UIPanGestureRecognizer * panRecognizer;

@property (nonatomic, readonly) BOOL editingSceneName;
@property (nonatomic) BOOL movingTabBar;
@property (nonatomic, strong) UIImageView * palettePullImageView;

-(void) startWithEditor;
-(void) startSimulation;
-(void) endSimulation;
-(void) toggleAppState;
-(void) reloadContent;
-(void) saveCurrentProjectAndPalette;

@end