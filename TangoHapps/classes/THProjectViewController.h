
@class TFProject;
@class TFLayer;
@class TFPalette;
@class TFTabbarViewController;
@class THEditorToolsViewController;

@interface THProjectViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate, CCDirectorDelegate> {
    
    UILabel * _titleLabel;
    UITextField * _titleTextField;
    
    UIBarButtonItem * _playButton;
    UIBarButtonItem * _stopButton;
    
    NSMutableArray * _barButtonItems;
    
    BOOL wasEditorInLilypadMode;
}

@property (nonatomic, readonly) TFLayer * currentLayer;
@property (nonatomic, readonly) CCScene * currentScene;
@property (nonatomic, readonly) CCGLView * glview;
@property (nonatomic, readonly) TFAppState state;
@property (nonatomic, readonly) TFTabbarViewController * tabController;
@property (nonatomic, readonly) THEditorToolsViewController * toolsController;

@property (nonatomic, readonly) BOOL editingSceneName;

-(void) startWithEditor;
-(void) startSimulation;
-(void) endSimulation;
-(void) cleanUp;
-(void) toggleAppState;
-(void) reloadContent;

@end