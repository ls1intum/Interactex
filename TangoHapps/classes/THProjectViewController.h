
@class TFProject;
@class TFLayer;
@class TFPalette;
@class TFTabbarViewController;
@class THEditorToolsViewController;

@interface THProjectViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate> {
    
    UILabel * _titleLabel;
    UITextField * _titleTextField;
    
    UIBarButtonItem * _playButton;
    UIBarButtonItem * _stopButton;
    
    NSMutableArray * _barButtonItems;
    BOOL _cocos2dInit;
}

@property (nonatomic, readonly) TFLayer * currentLayer;
@property (nonatomic, readonly) CCScene * currentScene;
@property (nonatomic, readonly) EAGLView * glview;
@property (nonatomic, readonly) TFAppState state;
@property (nonatomic, readonly) TFTabbarViewController * tabController;
@property (nonatomic, readonly) THEditorToolsViewController * toolsController;

@property (nonatomic, readonly) BOOL editingSceneName;

-(id) init;
-(void) load;
-(void) startWithEditor;
-(void) startSimulation;
-(void) endSimulation;
-(void) cleanUp;
-(void) toggleAppState;
-(void) reloadContent;

@end