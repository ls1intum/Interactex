
#import <Foundation/Foundation.h>

#define PTM_RATIO 32.0f

#define BACKGROUND_Z -1
#define PALETTE_ITEM_Z 1

#define OBJECT_Z 3
#define JOINT_Z 6
#define REMOVE_OBJ_IMG_Z 7
#define ADD_OBJ_IMG_Z 7
#define RED_DOT_Z 10
#define MOVE_TARGET_Z 15

#define PALETTE_RECTANGLE 0
#define PALETTE_CIRCLE 1

#define PALETTE_X_MARGIN 4
#define PALETTE_Y_MARGIN 4

#define PALETTE_LABEL_HEIGHT 14

#define SIDEBAR_WIDTH 250
#define SIDEBAR_PADDING 8
#define INIT_OBJECT_SIZE 40

#define OBJ_ACCELERATION 100000

#define THUMBNAIL_WIDTH 75
#define THUMBNAIL_HEIGHT 75
#define THUMBNAIL_MARGIN 10

#define MIN_DRAGGED_DISTANCE 150

#define TAB_ALPHA 1.0f

#define MIN_SHAPE_SIZE 5
#define MAX_SHAPE_SIZE 150

#define MIN_SCALE 1.0
#define MAX_SCALE 2.0

#define PALETTE_ITEMS_PADDING 8
#define PALETTE_ITEMS_SIZE 64
#define DRAGGED_IMAGE_SHIFT 40

#define FINGER_LENGTH 25

#define ROPE_NUM_PARTS 10

#define ROPE_HEIGHT 16
#define ROPE_WIDTH 8

#define MAX_PALETTE_IMAGE_SIZE 85
#define MIN_PALETTE_IMAGE_SIZE 44

#define SPRITE_OPACITY_EDITOR_ACTIVE 180
#define SPRITE_OPACITY_EDITOR_INACTIVE 100
#define SPRITE_OPACITY_SIMULATOR 255
#define BACKGROUND_OPACITY 60

#define VELOCITY_ITERATIONS 10
#define POSITION_ITERATIONS 10

#define SWITCH_TIME 2.0f
#define REMOVE_CUTTED_ROPE_TIME 1.5f

#define INITIAL_TRIGGER_AREA 100

enum zPositions{
    kLilypadZ = -25,
    kClotheZ = -20,
    kiPhoneZ = -15,
    kClotheObjectZ = -10,
    kValueZ = -9,
    kConditionZ = -8,
    kNormalObjectZ = -7,
    kSelectedObjectZ = -4,
    kSelectionSpriteZ = 2
};

//#define ARC4RANDOM_MAX      0x10000000
#define ARC4RANDOM_MAX 0xFFFFFFFFu
/*
extern NSString * const kNotificationClotheAdded;
extern NSString * const kNotificationClotheRemoved;

extern NSString * const kNotificationClotheObjectAdded;
extern NSString * const kNotificationClotheObjectRemoved;

extern NSString * const kNotificationiPhoneAdded;
extern NSString * const kNotificationiPhoneRemoved;

extern NSString * const kNotificationiPhoneObjectAdded;
extern NSString * const kNotificationiPhoneObjectRemoved;
*/
extern NSString * const kNotificationPropertyValueChanged;

extern NSString * const kNotificationSimulationStarted;
extern NSString * const kNotificationSimulationEnded;
/*
extern NSString * const kNotificationTriggerAdded;
extern NSString * const kNotificationTriggerRemoved;
extern NSString * const kNotificationConditionAdded;
extern NSString * const kNotificationConditionRemoved;

extern NSString * const kNotificationValueAdded;
extern NSString * const kNotificationValueRemoved;*/

extern NSString * const kNotificationPropertiesChanged;
/*
extern float const kLineWidthNormal;
extern float const kLineWidthSelected;*/

extern NSString * const kGameKitSessionId;

extern float const kWifiCellHeightCollapsed;
extern float const kWifiCellHeightExtended;

extern CGPoint const kiPhoneImageDistanceViewTopLeftToCenter;

extern NSString * const kNotificationLedOn;
extern NSString * const kNotificationLedOff;

extern NSString * const kNotificationBuzzerOn;
extern NSString * const kNotificationBuzzerOff;

extern NSString * const kNotificationBuzzerFrequencyChanged;
extern NSString * const kNotificationLedIntensityChanged;
extern NSString * const kNotificationPinValueChanged;

extern NSString * const kNotificationSwitchOn;
extern NSString * const kNotificationSwitchOff;

extern float const kMaxAnalogValue;
extern float const kMaxPotentiometerValue;

extern float const kLilypadPinRadius;

extern NSString * const kNotificationLilypadObjectAdded;
extern NSString * const kNotificationLilypadObjectRemoved;

extern NSString * const kNotificationLilypadAdded;
extern NSString * const kNotificationLilypadRemoved;

extern NSString * const kNotificationPinAttached;
extern NSString * const kNotificationPinDeattached;

extern CGPoint const kLilypadDefaultPosition;

extern NSString * const kPaletteNameClothes;
extern NSString * const kPaletteNameSoftware;
extern NSString * const kPaletteNameHardware;
extern NSString * const kPaletteNameTriggers;

typedef enum {
    kDigitalPinValueLow = 0,
    kDigitalPinValueHigh = 1
} THDigitalPinValue ;

#define kNumHardwareTypes 9
#define kMaxNumPinsPerElement 4

typedef enum{
    kHardwareTypeLed,
    kHardwareTypeBuzzer,
    kHardwareTypeButton,
    kHardwareTypeSwitch,
    kHardwareTypePotentiometer,
    kHardwareTypeLightSensor,
    kHardwareTypeCompass,
    kHardwareTypeThreeColorLed,
    kHardwareTypeVibeBoard
}THHardwareType;

#define kNumPinTypes 5

typedef enum{
    kPintypeDigital,
    kPintypeAnalog,
    kPintypeMinus,
    kPintypePlus,
} THPinType;

extern NSString* const kPinTexts[kNumPinTypes];

#define kNumPinModes 7

typedef enum{
    kPinModeDigitalInput = 0,
    kPinModeDigitalOutput = 1,
    kPinModeAnalogInput = 2,
    kPinModePWM = 3,
    kPinModeBuzzer = 4,
    kPinModeCompass = 5,
    kPinModeUndefined = 6
} THPinMode;

extern NSString* const kPinModeTexts[kNumPinModes];


#define kNumElementPinTypes 6
typedef enum{
    kElementPintypeDigital,
    kElementPintypeAnalog,
    kElementPintypePlus,
    kElementPintypeMinus,
    kElementPintypeScl,
    kElementPintypeSda
} THElementPinType;

extern NSString* const kElementPinTexts[kNumElementPinTypes];

typedef struct{
    THElementPinType type;
    CGPoint position;
    
} THPinDescriptor;


extern NSInteger const kNumPinsPerElement[kNumHardwareTypes];
extern CGPoint const kPinPositions[kNumHardwareTypes][kMaxNumPinsPerElement];
//extern THElementPinType const kPinTypes[kNumHardwareTypes][kMaxNumPinsPerElement];

#define kNumiPhoneTypes 2

typedef enum{
    kiPhoneType4S,
    kiPhoneType5
} THIPhoneType;

extern CGRect const kiPhoneFrames[kNumiPhoneTypes];

extern float const kUiViewOpacityEditor;


#define kLilypadNumPwmPins 6

extern NSInteger const kLilypadPwmPins[kLilypadNumPwmPins];

extern float const kBuzzerMaxFrequency;
extern float const kBuzzerMinFrequency;


typedef enum {
    kImageViewScaleModeFit,
    kImageViewScaleModeFill
} THImageViewScaleMode;

//events
extern NSString * const kEventTurnedOn;
extern NSString * const kEventTurnedOff;
extern NSString * const kEventOnChanged;
extern NSString * const kEventIntensityChanged;
extern NSString * const kEventFrequencyChanged;
extern NSString * const kEventValueChanged;
extern NSString * const kEventMapperValueChanged;
extern NSString * const kEventDxChanged;
extern NSString * const kEventDyChanged;
extern NSString * const kEventLightChanged;
extern NSString * const kEventStartedPressing;
extern NSString * const kEventStoppedPressing;
extern NSString * const kEventConditionIsTrue;
extern NSString * const kEventConditionIsFalse;
extern NSString * const kEventConditionChanged;
extern NSString * const kEventXChanged;
extern NSString * const kEventYChanged;
extern NSString * const kEventZChanged;
extern NSString * const kEventHeadingChanged;
extern NSString * const kEventTapped;
extern NSString * const kEventDoubleTapped;
extern NSString * const kEventScaleChanged;
extern NSString * const kEventLongPressed;
extern NSString * const kEventColorChanged;
extern NSString * const kEventTriggered;

//methods
extern NSString * const kMethodTurnOn;
extern NSString * const kMethodTurnOff;
extern NSString * const kMethodSetValue1;
extern NSString * const kMethodSetValue2;
extern NSString * const kMethodSetRed;
extern NSString * const kMethodSetGreen;
extern NSString * const kMethodSetBlue;

#define kMaxNumNotifyBehaviors 3

typedef enum {
    kSensorNotifyBehaviorAlways,
    kSensorNotifyBehaviorWhenInRange,
    kSensorNotifyBehaviorOncePerPeak,
} THSensorNotifyBehavior;

NSString * kNotifyBehaviorsText[kMaxNumNotifyBehaviors];

extern NSInteger const kCompassMin;
extern NSInteger const kAnalogInMin;

extern NSString * kSimulatorDefaultFont;
extern CGSize const kDefaultViewMinSize;
extern CGSize const kDefaultViewMaxSize;

extern ccColor3B const kMinusPinColor;
extern ccColor3B const kPlusPinColor;
extern ccColor3B const kOtherPinColor;

extern ccColor4B const kMinusPinHighlightColor;
extern ccColor4B const kPlusPinHighlightColor;
extern ccColor4B const kDefaultPinHighlightColor;

extern ccColor3B const kWireDefaultColor;
extern ccColor3B const kWireDefaultHighlightColor;

extern float const kWireNodeRadius;
extern ccColor3B const kWireNodeColor;

extern CGSize const kDefaultPinSize;
extern CGSize const kiPhoneButtonDefaultSize;

extern CGPoint const kDefaultiPhonePosition;


typedef enum{
    kTimerTypeOnce,
    kTimerTypeAlways
}THTimerType;

extern CGPoint const kSewedPositions[kNumHardwareTypes];

