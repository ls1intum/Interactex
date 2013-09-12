
@class TFProject;
@class TFLayer;
@class TFPalette;
@class TFTabbarViewController;
@class TFEditorToolsViewController;

@interface THProjectViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate, CCDirectorDelegate> {
    
    UILabel * _titleLabel;
    UITextField * _titleTextField;
    
    UIBarButtonItem * _playButton;
    UIBarButtonItem * _stopButton;
}

@property (nonatomic, readonly) TFLayer * currentLayer;
@property (nonatomic, readonly) CCScene * currentScene;
@property (nonatomic, readonly) CCGLView * glview;
@property (nonatomic, readonly) TFAppState state;
@property (nonatomic, readonly) TFTabbarViewController * tabController;
@property (nonatomic, readonly) TFEditorToolsViewController * toolsController;
@property (nonatomic, strong) UIPanGestureRecognizer * panRecognizer;

@property (nonatomic, readonly) BOOL editingSceneName;
@property (nonatomic) BOOL movingTabBar;
@property (nonatomic, strong) UIImageView * palettePullImageView;

-(void) startWithEditor;
-(void) startSimulation;
-(void) endSimulation;
-(void) cleanUp;
-(void) toggleAppState;
-(void) reloadContent;

@end