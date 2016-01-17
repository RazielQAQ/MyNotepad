//
//  AddNewController.m
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import "AddNewController.h"

#import <QuartzCore/QuartzCore.h>
#import "Definition.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"

@interface AddNewController () 

@property (weak, nonatomic) IBOutlet UITextView *noteContent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inputMode;
@property (weak, nonatomic) IBOutlet UIButton *startListen;
@property (nonatomic, strong) PopupView *popUpView;

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象


- (IBAction)changeInputMode:(id)sender;
- (IBAction)startListening:(id)sender;



@end

@implementation AddNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background.jpg"] ];
    [self.noteContent.layer setCornerRadius:10];
    
    _startListen.hidden = true;

    
    //点击空白处收回键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.doneButton) return;
    
    self.note = [[MyNote alloc] init];
    self.note.content = self.noteContent.text;
    //NSLog(@"create Date :%@, last Modified: %@", self.note.createDate, self.note.lastModified);

}

//设置不为编辑模式，收回键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (IBAction)changeInputMode:(id)sender {
    NSInteger selectedIndex = _inputMode.selectedSegmentIndex;
    //NSLog(@"输入模式：%ld",(long)selectedIndex);
    if(selectedIndex == 0) {
        _startListen.hidden = true;
    } else {
        _startListen.hidden = false;
    }
}

//启动语音听写
- (IBAction)startListening:(id)sender {
    [_noteContent resignFirstResponder];
    self.isCanceled = NO;
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    [_iFlySpeechRecognizer startListening];
    
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    if (self.isCanceled) {
        [_popUpView removeFromSuperview];
        return;
    }
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    [_popUpView showText: vol];
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    [_popUpView showText: @"正在录音"];
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    [_popUpView showText: @"停止录音"];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"%s",__func__);
    
    
    NSString *text ;
    
    if (self.isCanceled) {
        text = @"识别取消";
        
    } else if (error.errorCode == 0 ) {
        if (_result.length == 0) {
            text = @"无识别结果";
        }else {
            text = @"识别成功";
        }
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    
    [_popUpView showText: text];
    
    [_startListen setEnabled:YES];
}

/**
 听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _noteContent.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _noteContent.text = [NSString stringWithFormat:@"%@%@", _noteContent.text,resultFromJson];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_noteContent.text);
}


/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void) showPopup
{
    [_popUpView showText: @"正在上传..."];
}

#pragma mark - IFlyDataUploaderDelegate

/**
 上传联系人和词表的结果回调
 error ，错误码
 ****/
- (void) onUploadFinished:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
    
    if ([error errorCode] == 0) {
        [_popUpView showText: @"上传成功"];
    }
    else {
        [_popUpView showText: [NSString stringWithFormat:@"上传失败，错误码:%d",error.errorCode]];
        
    }
    
}




/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
    
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
}



@end
