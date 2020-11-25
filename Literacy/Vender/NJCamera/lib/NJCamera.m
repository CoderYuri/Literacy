#import "NJCamera.h"

@interface NJCamera () <AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) dispatch_queue_t sessionQueue;

@property (strong, nonatomic) AVCaptureSession *session;

// 图像设置
@property (nonatomic, strong) AVCapturePhotoSettings *photoSettings;

// 预览页
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

// 摄像头
@property (strong, nonatomic) AVCaptureDevice *videoCaptureDevice;

// 输入源
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;

// 图像输出
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;

@property (copy, nonatomic) NSString *cameraQuality;

//前后置摄像头
@property (nonatomic) NJCameraPosition cameraPosition;

// 输出类型
@property (nonatomic) NJCameraOutputType outPutType;

@end

NSString *const NJCameraErrorDomain = @"NJCameraErrorDomain";

@implementation NJCamera

- (void)getQRCodeWith:(void (^)(NJCamera *camera, NSString *result))onQRCode
{
    
    self.onQRCode = onQRCode;
    
}

// 照片输出
- (AVCapturePhotoOutput *)photoOutput
{
    
    if (_photoOutput ==  nil) {
        
        _photoOutput = [[AVCapturePhotoOutput alloc] init];
        
    }
    
    return _photoOutput;
    
}

// 二维码输出
-(AVCaptureMetadataOutput *)metadataOutput{
    
    if (_metadataOutput == nil) {
        
        _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
        
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
    }
    
    return _metadataOutput;
    
}

- (instancetype)initWithQuality:(NSString *)quality position:(NJCameraPosition)position OutputType:(NJCameraOutputType)type
{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self setupWithQuality:quality position:position OutputType:type];
    }
    
    return self;
    
}

- (void)setupWithQuality:(NSString *)quality
                position:(NJCameraPosition)position OutputType:(NJCameraOutputType)type
{
    _cameraQuality = quality;
    _cameraPosition = position;
    _outPutType = type;
    
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    
}


- (void)nj_attachToViewController:(UIViewController *)vc withFrame:(CGRect)frame
{
    
    [vc addChildViewController:self];
    
    self.view.frame = frame;
    
    [vc.view addSubview:self.view];
    
    [self didMoveToParentViewController:vc];
    
}

- (void)start
{
    
    // 相机权限
    AVAuthorizationStatus authorizationStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    switch (authorizationStatus) {
            // 没有权限，发起授权许可
        case AVAuthorizationStatusNotDetermined: {

            [self requestCameraPermission];

        }

            break;

            // 用户已明确拒绝媒体捕获的权限。
        case AVAuthorizationStatusDenied: {

            // 用户拒绝，无法拒绝
            NSError *error = [NSError errorWithDomain:NJCameraErrorDomain code:NJCameraErrorCodeCameraPermission userInfo:nil];
            [self passError:error];

        }
            break;

            // 用户已明确授予媒体捕获权限，或者对于相关媒体类型不需要显式用户权限
        case AVAuthorizationStatusAuthorized: {

            dispatch_async(self.sessionQueue, ^{
                
                [self initialize];
                
            });

        }

            break;

            // 不允许用户访问媒体捕获设备。此状态通常不可见 - 用于发现设备的AVCaptureDevice类方法不会返回用户被限制访问的设备
        case AVAuthorizationStatusRestricted: {

            NSError *error = [NSError errorWithDomain:NJCameraErrorDomain code:NJCameraErrorCodeCameraPermission userInfo:nil];

            [self passError:error];

        }
            break;

        default: {

            NSError *error = [NSError errorWithDomain:NJCameraErrorDomain code:NJCameraErrorCodeUNKownPermission userInfo:nil];

            [self passError:error];

        }
            break;

    }
    
}

- (void)requestCameraPermission
{
    
    // 请求相机权限
    dispatch_async(self.sessionQueue, ^{
        
        if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    
                    [self initialize];
                    
                } else {
                    
                    NSError *error = [NSError errorWithDomain:NJCameraErrorDomain code:NJCameraErrorCodeCameraPermission userInfo:nil];
                    
                    [self passError:error];
                    
                }
                
            }];
            
        }
        
    });
    
}

- (void)stop
{
    
    dispatch_async(self.sessionQueue, ^{
       
        [self.session stopRunning];
        
        self.session = nil;
        
        self.metadataOutput = nil;
        
        self.photoOutput = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.captureVideoPreviewLayer removeFromSuperlayer];
            
            self.captureVideoPreviewLayer = nil;
            
        });
        
    });
    
    
    
}

// 初始化
- (void)initialize
{
    
    if (!_session) {
        
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = _cameraQuality;
        
        [_session beginConfiguration];
        
        // 设备相关
        AVCaptureDevicePosition devicePosition;
        
        switch (self.cameraPosition) {
                
            case NJCameraPositionRear:
                
                devicePosition = AVCaptureDevicePositionBack;
                
                break;
            
            case NJCameraPositionFront:
                
                devicePosition = AVCaptureDevicePositionFront;
                
                break;
                
            default:
                
                devicePosition = AVCaptureDevicePositionUnspecified;
                
                break;
                
        }
        
        if (devicePosition == AVCaptureDevicePositionUnspecified) {
            
            self.videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            
        } else {
            
            self.videoCaptureDevice = [self cameraWithPostion:devicePosition];
            
        }
        
        // 输入源
        NSError *error = nil;
        self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoCaptureDevice error:&error];
        
        if (!self.captureDeviceInput) {
            
            [self passError:error];
            
            return;
            
        }
        
        if ([self.session canAddInput:self.captureDeviceInput]) {
            
            [self.session addInput:self.captureDeviceInput];
            
        }
        
        // 输出
        switch (self.outPutType) {
                
            case NJCameraOutputTypPhoto:
                
                if ([self.session canAddOutput:self.photoOutput]) {
                    
                    [self.session addOutput:self.photoOutput];
                    
                }
                
                break;
                
            case NJCameraOutputTypeQRCode:
                
                if([self.session canAddOutput:self.metadataOutput]){
                    
                    [self.session addOutput:self.metadataOutput];
                    
                    self.metadataOutput.metadataObjectTypes = self.metadataOutput.availableMetadataObjectTypes;
                    
                }
                
                break;
            
        }
        
        [self.session commitConfiguration];
        
        [self.session startRunning];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 预览layer
            CGRect bounds = self.view.layer.bounds;
            self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
            self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.captureVideoPreviewLayer.bounds = bounds;
            self.captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
            [self.view.layer insertSublayer:self.captureVideoPreviewLayer atIndex:0];
            
        });
        
        
        
    }
    
}

- (AVCaptureDevice *)cameraWithPostion:(AVCaptureDevicePosition)position{
    
    AVCaptureDeviceDiscoverySession *devicesIOS11 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    
    NSArray *devicesIOS  = devicesIOS11.devices;
    for (AVCaptureDevice *device in devicesIOS) {
        if ([device position] == position) {
            return device;
        }
    }
    
    return nil;
}

// 更改前后置
- (void)changePosition
{
    
    dispatch_async(self.sessionQueue, ^{
        
        [self.session beginConfiguration];
        
        [self.session removeInput:self.captureDeviceInput];
        AVCaptureDevice *device = nil;
        if(self.captureDeviceInput.device.position == AVCaptureDevicePositionBack) {
            
            device = [self cameraWithPostion:AVCaptureDevicePositionFront];
            self->_cameraPosition = NJCameraPositionFront;
//
//            AVCaptureConnection *connection = [self->_photoOutput connectionWithMediaType:AVMediaTypeVideo];
//                connection.videoMirrored = NO;

        } else {
            device = [self cameraWithPostion:AVCaptureDevicePositionBack];
            self->_cameraPosition = NJCameraPositionRear;
        }
        if(!device) {
            return;
        }
        
        NSError *error = nil;
        AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if(error) {
            [self passError:error];
            [self.session commitConfiguration];
            return;
        }
        
        [self.session addInput:videoInput];
        
        self.videoCaptureDevice = device;
        self.captureDeviceInput = videoInput;
        
        [self.session commitConfiguration];
    });
    
    
    /*
    //获取摄像头的数量（该方法会返回当前能够输入视频的全部设备，包括前后摄像头和外接设备）
    NSInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //摄像头的数量小于等于1的时候直接返回
    if (cameraCount <= 1) {
        return;
    }
    AVCaptureDevice *newCamera = nil;
    __block AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向（前/后）
    AVCaptureDevicePosition position = [[self.captureDeviceInput device] position];
 
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
 
    if (position == AVCaptureDevicePositionFront) {
        newCamera = [self cameraWithPostion:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
 
    }else if (position == AVCaptureDevicePositionBack){
        
        newCamera = [self cameraWithPostion:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }
    [self.captureVideoPreviewLayer addAnimation:animation forKey:nil];
 
        
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (newInput != nil) {
        [self.session beginConfiguration];
        //先移除原来的input
        [self.session removeInput:self.captureDeviceInput];
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.captureDeviceInput = newInput;
        }else{
            //如果不能加现在的input，就加原来的input
            [self.session addInput:self.captureDeviceInput];
        }
        [self.session commitConfiguration];
    }
     */
        
}

- (void)onoffLight{
    dispatch_async(self.sessionQueue, ^{
        
    
        
        if(self.cameraPosition == NJCameraPositionFront){
            
        }
        
        //后置摄像头才能打开摄像机
        else{
            
                AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

                //修改前必须先锁定
                [device lockForConfiguration:nil];
                
                //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
                if ([device hasFlash]) {
                    
                    if (device.flashMode == AVCaptureFlashModeOff) {
                        device.flashMode = AVCaptureFlashModeOn;
                        device.torchMode = AVCaptureTorchModeOn;
                    } else if (device.flashMode == AVCaptureFlashModeOn) {
                        device.flashMode = AVCaptureFlashModeOff;
                        device.torchMode = AVCaptureTorchModeOff;
                    }
                    
                }
                [device unlockForConfiguration];
            
        }


        
    });

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 捕捉静态照片
- (void)startCapturePhotoAction:(void (^)(NJCamera * _Nonnull, UIImage * _Nonnull))onCapture
{
    
    self.photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];
    
    if(self.ifLight){
        self.photoSettings.flashMode = AVCaptureFlashModeOn;
    }
    else{
        self.photoSettings.flashMode = AVCaptureFlashModeOff;
    }
    
    [self.photoOutput capturePhotoWithSettings:self.photoSettings delegate:self];
    
    self.onCapture = onCapture;
    
}

#pragma - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error
{
    
    NSData *imageData = photo.fileDataRepresentation;
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (self.onCapture) {
        
        self.onCapture(self, image);
        
    }
    
}

#pragma - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if(metadataObjects.count > 0 && metadataObjects != nil){
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects lastObject];
        
        if ([metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            
            NSString *result = metadataObject.stringValue;
            
            if (self.onQRCode) {
                
                self.onQRCode(self, result);
                
            }
            
        }
        
    }
    
}

- (BOOL)statusCheck{
    
    if (![self.class isCameraAvailable]){
        
        return NO;
    }
    
    if (![self.class isRearCameraAvailable] && ![self.class isFrontCameraAvailable]) {

        return NO;
    }
    
    if (![self.class isCameraAuthStatusCorrect]) {
        
        return NO;
    }
    
    return YES;
    
}


#pragma - Helpers
- (void)passError:(NSError *)error
{
    if(self.onError) {
        __weak typeof(self) weakSelf = self;
        self.onError(weakSelf, error);
    }
}

+ (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isCameraAuthStatusCorrect{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}

@end
