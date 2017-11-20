//
//  MCSimpleAudioPlayer.m
//  MCSimpleAudioPlayer
//
//  Created by Chengyin on 14-7-27.
//  Copyright (c) 2014年 Chengyin. All rights reserved.
//

#import "MCSimpleAudioPlayer.h"
#import "MCAudioOutputQueue.h"
#import "MCAudioBuffer.h"
#import <pthread.h>

#import "MCAudioInputQueue.h"

static const NSTimeInterval bufferDuration = 0.2;

@interface MCSimpleAudioPlayer ()<MCAudioInputQueueDelegate>
{
    
    unsigned short send_audio_seq;       // 标记音频帧序
    BOOL is_streaming;          // 标记音频流状态
    
    Byte sendBuf[160];
    unsigned int sendBufOffset;

@private
    NSThread *_thread;
    NSThread *recAudioThread;
    pthread_mutex_t _mutex;
	pthread_cond_t _cond;
    
    MCSAPStatus _status;
    
    unsigned long long _fileSize;
    unsigned long long _offset;
    NSFileHandle *_fileHandler;
    
    UInt32 _bufferSize;
    MCAudioBuffer *_buffer;
    
    MCAudioOutputQueue *_outputQueue;
    
    BOOL _started;
    BOOL _pauseRequired;
    BOOL _stopRequired;
    BOOL _pausedByInterrupt;
    BOOL _usingAudioFile;
    
    BOOL _seekRequired;
    NSTimeInterval _seekTime;
    NSTimeInterval _timingOffset;
    
    //inptu & output Queue added
     MCAudioInputQueue *_recorder;
    AudioStreamBasicDescription _format;
    AudioStreamBasicDescription defaultOutputFormat;
    UInt32 bufferSizeOut;
    BOOL is_stream;
    
    //write data
    NSFileHandle *fileHandle;
    NSString *h264File;
    NSMutableData *audioData;
    
    FILE *fp;
    BOOL enabledWriteVideoFile;
    
    FILE *beforFp; //audio 编码前
    FILE *laterFp;
}
@end

@implementation MCSimpleAudioPlayer
@dynamic status;
@synthesize failed = _failed;
@synthesize fileType = _fileType;
@synthesize filePath = _filePath;
@dynamic isPlayingOrWaiting;
@dynamic duration;
@dynamic progress;

#pragma mark - init & dealloc
- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType
{
    self = [super init];
    if (self)
    {
//        recAudioThread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveAudioWithNewThread) object:nil];
//        recAudioThread.name = @"recAudio";
//        [recAudioThread start];
//
//        
//        _bufferSize = 3996;
//        _buffer = [MCAudioBuffer buffer];
        
//        /////
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        h264File = [documentsDirectory stringByAppendingPathComponent:@"recordOC.pcm"];
//        [fileManager removeItemAtPath:h264File error:nil];
//        [fileManager createFileAtPath:h264File contents:nil attributes:nil];
//        
//        // Open the file using POSIX as this is anyway a test application
//        fileHandle = [NSFileHandle fileHandleForWritingAtPath:h264File];
//        audioData = [NSMutableData data];
        /////
        
#ifdef DEBUG
        enabledWriteVideoFile = YES;
        [self initForFilePath];
        
        char *path = [self GetFilePathByfileName:"beforeFp.pcm"];
        NSLog(@"%s",path);
        beforFp = fopen(path,"wb");
        
        char *path2 = [self GetFilePathByfileName:"laterFp.spx"];
        NSLog(@"%s",path2);
        laterFp = fopen(path2,"wb");
#endif
        


        
    }
    return self;
}

- (void)dealloc
{
    [self cleanup];
    [_fileHandler closeFile];
    
    [fileHandle closeFile];
    
    fclose(beforFp);
    fclose(laterFp);
}

- (void)cleanup
{
    //reset file
    _offset = 0;
    [_fileHandler seekToFileOffset:0];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MCAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];

    
    //clean buffer
    [_buffer clean];
    
    _usingAudioFile = NO;
    
    [_outputQueue stop:YES];
    _outputQueue = nil;
    
    //destory mutex & cond
    [self _mutexDestory];
    
    //inputAueue
    [_recorder stop];
    _recorder = nil;
    
    _started = NO;
    is_stream = NO;
    _timingOffset = 0;
    _seekTime = 0;
    _seekRequired = NO;
    _pauseRequired = NO;
    _stopRequired = NO;
    
    //reset status
    [self setStatusInternal:MCSAPStatusStopped];
}

#pragma mark - status
- (BOOL)isPlayingOrWaiting
{
    return self.status == MCSAPStatusWaiting || self.status == MCSAPStatusPlaying || self.status == MCSAPStatusFlushing;
}

- (MCSAPStatus)status
{
    return _status;
}

- (void)setStatusInternal:(MCSAPStatus)status
{
    if (_status == status)
    {
        return;
    }
    
    [self willChangeValueForKey:@"status"];
    _status = status;
    [self didChangeValueForKey:@"status"];
}

#pragma mark - mutex
- (void)_mutexInit
{
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
}

- (void)_mutexDestory
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

- (void)_mutexWait
{
    pthread_mutex_lock(&_mutex);
    pthread_cond_wait(&_cond, &_mutex);
	pthread_mutex_unlock(&_mutex);
}

- (void)_mutexSignal
{
    pthread_mutex_lock(&_mutex);
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}

#pragma mark - thread
- (BOOL)createAudioQueue
{
    if (_outputQueue)
    {
        return YES;
    }
    
    defaultOutputFormat.mFormatID = kAudioFormatLinearPCM;
    defaultOutputFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    defaultOutputFormat.mBitsPerChannel = 16;
    defaultOutputFormat.mChannelsPerFrame = 1;
    
    defaultOutputFormat.mFramesPerPacket = 1;
    defaultOutputFormat.mBytesPerFrame = defaultOutputFormat.mChannelsPerFrame * (defaultOutputFormat.mBitsPerChannel / 8);
    defaultOutputFormat.mBytesPerPacket = defaultOutputFormat.mFramesPerPacket * defaultOutputFormat.mBytesPerFrame;
    defaultOutputFormat.mSampleRate = 8000.0f;
    
    bufferSizeOut = defaultOutputFormat.mBitsPerChannel * defaultOutputFormat.mChannelsPerFrame * defaultOutputFormat.mSampleRate * bufferDuration / 8;


    _recorder = [MCAudioInputQueue inputQueueWithFormat:defaultOutputFormat bufferDuration:bufferDuration delegate:self];
    _recorder.meteringEnabled = YES;
    [_recorder start];
    if (!_recorder.available) {
        _recorder = nil;
        return NO;
    }
    
    _outputQueue = [[MCAudioOutputQueue alloc] initWithFormat:defaultOutputFormat bufferSize:3996 macgicCookie:nil];
    if (!(_outputQueue.available && _recorder.available))
    {
        _outputQueue = nil;
        _recorder = nil;
        return NO;
    }

    NSLog(@"ceatQueue %u", (unsigned int)bufferSizeOut);
    _bufferSize = 3996;
    
    return YES;
}

- (void)threadMain
{
    _failed = YES;
    NSError *error = nil;
    
    if ([[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:NULL])
    {
        //active audiosession
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptHandler:) name:AVAudioSessionInterruptionNotification object:nil];
        if ([[AVAudioSession sharedInstance] setActive:YES error:NULL])
        {
            if (!error)
            {
                _failed = NO;
                //                _audioFileStream.delegate = self;
            }
        }
    }
//
//    //set audiosession category
//    if ([[MCAudioSession sharedInstance] setCategory:kAudioSessionCategory_PlayAndRecord error:NULL])
//    {
//        //active audiosession
////        [[MCAudioSession sharedInstance] setProperty:kAudioSessionProperty_OverrideCategoryDefaultToSpeaker dataSize:sizeof(kAudioSessionOverrideAudioRoute_Speaker) data:&kAudioSessionCategory_PlayAndRecord error:NULL];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruptHandler:) name:MCAudioSessionInterruptionNotification object:nil];
//        if ([[MCAudioSession sharedInstance] setActive:YES error:NULL])
//        {
//            if (!error)
//            {
//                _failed = NO;
//            }
//        }
//    }
    
    if (_failed)
    {
        [self cleanup];
        return;
    }
    
    [self setStatusInternal:MCSAPStatusWaiting];
    BOOL isEof = NO;
    while (self.status != MCSAPStatusStopped && !_failed && _started)
    {
        @autoreleasepool
        {
            //read file & parse
            if (![self createAudioQueue])
            {
                _failed = YES;
                break;
            }
            
            if (!_outputQueue)
            {
                continue;
            }
            
            if (self.status == MCSAPStatusFlushing && !_outputQueue.isRunning)
            {
                break;
            }
            
            //stop
            if (_stopRequired)
            {
                _stopRequired = NO;
                _started = NO;
                [_outputQueue stop:YES];
                break;
            }
            
            //pause
            if (_pauseRequired)
            {
                [self setStatusInternal:MCSAPStatusPaused];
                [_outputQueue pause];
                [self _mutexWait];
                _pauseRequired = NO;
            }
            
            //play
            if ([_buffer bufferedSize] >= _bufferSize || isEof)
            {
                UInt32 packetCount;
                AudioStreamPacketDescription *desces = NULL;
                NSData *data = [_buffer dequeueDataWithSize:_bufferSize packetCount:&packetCount descriptions:&desces];
                if (packetCount != 0)
                {
                    [self setStatusInternal:MCSAPStatusPlaying];
                    _failed = ![_outputQueue playData:data packetCount:packetCount packetDescriptions:desces isEof:isEof];
                    free(desces);
                    if (_failed)
                    {
                        break;
                    }
                    
                    if (![_buffer hasData] && isEof && _outputQueue.isRunning)
                    {
                        [_outputQueue stop:NO];
                        [self setStatusInternal:MCSAPStatusFlushing];
                    }
                }
                else if (isEof)
                {
                    //wait for end
                    if (![_buffer hasData] && _outputQueue.isRunning)
                    {
                        [_outputQueue stop:NO];
                        [self setStatusInternal:MCSAPStatusFlushing];
                    }
                }
                else
                {
                    _failed = YES;
                    break;
                }
            }
            
            //seek
//            if (_seekRequired && self.duration != 0)
//            {
//                [self setStatusInternal:MCSAPStatusWaiting];
//                
//                _timingOffset = _seekTime - _audioQueue.playedTime;
//                [_buffer clean];
//                if (_usingAudioFile)
//                {
//                    [_audioFile seekToTime:_seekTime];
//                }
//                else
//                {
//                    _offset = [_audioFileStream seekToTime:&_seekTime];
//                    [_fileHandler seekToFileOffset:_offset];
//                }
//                _seekRequired = NO;
//                [_audioQueue reset];
//            }
        }
        usleep(2000);
    }
    
    //clean
    [self cleanup];
}


#pragma mark - interrupt
- (void)interruptHandler:(NSNotification *)notification
{
    DLog(@"notif = %@", notification);
    NSError *error;
    UInt32 interruptionState = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntValue];
    
    
    if (interruptionState == AVAudioSessionInterruptionTypeBegan)
    {
        _pausedByInterrupt = YES;
//        [_recorder stop];
//        [_recorder flush];
//        [_recorder reset];
        [_outputQueue pause];
        [self setStatusInternal:MCSAPStatusPaused];
        [_buffer clean];
    }
    else if (interruptionState == AVAudioSessionInterruptionTypeEnded)
    {
        if (self.status == MCSAPStatusPaused && _pausedByInterrupt)
        {
            if ([[AVAudioSession sharedInstance] setActive:YES error:&error])
            {
//                [_recorder reset];
                [_buffer clean];
                _pausedByInterrupt = NO;
                [_recorder start];
                [self play];
            }
        }
    }
}

#pragma mark - parser
//AudioFileStream解析完成的数据都被存储到了_buffer中
//- (void)audioFileStream:(MCAudioFileStream *)audioFileStream audioDataParsed:(NSArray *)audioData
//{
//    [_buffer enqueueFromDataArray:audioData];
//}

/** inputQueue delegate implementation and send audio out */
- (void)inputQueue:(MCAudioInputQueue *)inputQueue inputData:(NSData *)data numberOfPackets:(UInt32)numberOfPackets
{
    //OC
//    [fileHandle writeData:data];
//    NSLog(@"dataLen %d", data.length);
  
    
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    int real_read;
    int real_encode;
    int offset = 0;
    
    short one_frame[160];
    Byte out_buffer[200];
    int out_len[1];
    
    //data 转成 buffer[]
    int arrayLength = ([data length]%2==0) ? (int)[data length]/2 : ((int)[data length]/2)+1;
    short buffer[arrayLength]; // short==2bytes   short[] buffer = new short[bufferSize >> 1]; print arrayLength = 1600
    short value = 0;
    for (int i = 0; i < arrayLength; i++) {
        if (([data length]-(i*2))>=2) {
            //Start form i and length = integer length = 4-bytes
            [data getBytes:&value range:NSMakeRange(i*2, 2)];
        }else {
            [data getBytes:&value range:NSMakeRange(i*2, ([data length]-(i*2)))];
        }
        buffer[i]= value;
    }
    
    NSThread *thread = [NSThread currentThread];
    thread.name = @"sendAudio";
//    NSLog(@"thread:%@ read:%d priority%lf qual:%lu", thread, arrayLength, thread.threadPriority, thread.qualityOfService);

    real_read = arrayLength;
    
    while (offset != real_read) {
        int real_copy = (real_read-offset)>160?160:real_read-offset;
        /**
         160长度复制buffer[]数据到 one_frame 直到全部复制(offset = real_read)
         
         * arraycopy(Object src, int srcPos, Object dest, int destPos, int length)
         * buffer:源数组； offset:源数组要复制的起始位置； one_frame:目的数组； 0:目的数组放置的起始位置； real_copy:复制的长度
         */

        arrayCopy(buffer, offset*2, one_frame, 0, real_copy*2);
        offset += real_copy;
        
        //编码前写入
        if (enabledWriteVideoFile) {
            fwrite(one_frame, 2, real_copy, beforFp);
        }

        /** 要对此操作进行加锁 */
        /**
         音频编码 one_frame编码
         
         @param one_frame  存放一截音频数据数组首地址，从源数组(原始音频)分割下来的
         @param real_copy  one_frame的长度，也是复制的长度
         @param out_buffer 编码输出数组首地址
         @param out_len    输出大小， int *out_size
         
         @return 编码后数据长度
         */
//        @synchronized (self) {
//            real_encode = Speex_encode(one_frame, real_copy, (char *)out_buffer, out_len);
//            
//        }
        real_encode = Speex_encode(one_frame, real_copy, (char *)out_buffer, out_len);

        if (1) { //is_streaming  音频编解码为耗时操作，在此期间is_streaming可能发生变化
            // 复制编码后的数据到 sendBuf 数组，一次性复制完
            arrayCopy(out_buffer, 0, sendBuf, sendBufOffset, real_encode);//0
            
            sendBufOffset += real_encode;
            
            if (sendBufOffset == 160) { //够160长度发送一次，如果这次不够160，先存着等待下次累计够160
                
                
                /**
                 往底层发送音频
                 
                 @param short 初始为0，标记每一帧顺序
                 
                 @return 0 success
                 */
                
                NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
                unsigned int tsInt = [[NSNumber numberWithDouble:nowtime] unsignedIntValue];
                //发送之前写入
                if (enabledWriteVideoFile) {
                    fwrite(sendBuf, 1, sendBufOffset, laterFp);
                }

                devavtp_send_audio(send_audio_seq++, tsInt, sendBufOffset,(char *)sendBuf);
//                printf("offset%d  ts=%d sendBuf%c----%c %d=%d\n",sendBufOffset, tsInt, sendBuf[0], sendBuf[1], real_encode, out_len[0]);

                sendBufOffset = 0;
            }
        }else {
            break; //调出所有循环结束线程
        }
        
        usleep(2000);
    }
    offset = 0;
    
//  });
 
}

- (void)inputQueue:(MCAudioInputQueue *)inputQueue errorOccur:(NSError *)error
{
    
}

#pragma mark - progress
- (NSTimeInterval)progress
{
    if (_seekRequired)
    {
        return _seekTime;
    }
    return _timingOffset + _outputQueue.playedTime;
}

- (void)setProgress:(NSTimeInterval)progress
{
    _seekRequired = YES;
    _seekTime = progress;
}

- (NSTimeInterval)duration
{
    return 0.2;
}

#pragma mark - method
- (void)play
{
    if (!_started)
    {
        _started = YES;
        is_stream = YES;
        [self _mutexInit];
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil];
        _thread.name = @"playAudio";
        [_thread start];
        
        recAudioThread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveAudioWithNewThread) object:nil];
        recAudioThread.name = @"recAudio";
        [recAudioThread start];
        
        
        _bufferSize = 3996;
        _buffer = [MCAudioBuffer buffer];

    }
    else
    {
        if (_status == MCSAPStatusPaused || _pauseRequired)
        {
            _pausedByInterrupt = NO;
            _pauseRequired = NO;
            
            if ([[AVAudioSession sharedInstance] setActive:YES error:NULL])
            {
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:NULL];
                [self _resume];
            }

        }
    }
}

- (void)_resume
{
    [_outputQueue resume];
    [self _mutexSignal];
}

- (void)pause
{
    if (self.isPlayingOrWaiting && self.status != MCSAPStatusFlushing)
    {
        _pauseRequired = YES;
    }
}

- (void)stop
{
    _stopRequired = YES;
    is_stream = NO;
    [self _mutexSignal];
    
}

//--------------------------------------

- (void)receiveAudioWithNewThread
{
    unsigned short seq[1] = {0};
    unsigned int ts[1] = {0};
    unsigned int len[1] = {0};
    Byte payload[20 * 50] = {0};
    Byte decode_frame[20] = {0};
    short out_buf[160] = {0};
    int offset = 0;
    int count = 0;
    
    while (is_stream) { //is_streaming
        /**
         * 接收音频
         
         * seq ：标记每一帧
         * System.currentTimeMillis()：时间戳，设置的结果是为了使音频、视频处于同步
         * payload 160  数据
         */
        *len = 0;
        devavtp_recv_audio(seq, ts, len, (char*)payload);
//        printf("Rec--seq=%d, ts=%d, len=%d", seq[0], ts[0], len[0]);
        
//        audioData = [NSMutableData dataWithBytes:payload length:len[0]];
//        printf("ra--- in SDK recv data len%u data%lu\n",len[0], (unsigned long)audioData.length);
//        
//        [audioData replaceBytesInRange:NSMakeRange(0, len[0]) withBytes:NULL length:0];
        
//        printf("offset:%d == len[0]:%d count%d name:%s riority%lf qual:%lu\n", offset, len[0], count++, threadName, level, qual);

        if (len[0] <= 0) {
            usleep(5000);
            continue;
        }

        while (offset != len[0]) {
//            printf("    offset:%d == len[0]:%d\n", offset, len[0]);

            //payload:源数组； offset:源数组要复制的起始位置； decode_frame:目的数组； 0:目的数组放置的起始位置； 20:复制的长度
            arrayCopy(payload, offset, decode_frame, 0, 20);
//            //编码前写入
//            if (enabledWriteVideoFile) {
//                fwrite(payload, 1, offset, beforFp); //beforFp.spx
//            }
            Speex_decode((char*)decode_frame, out_buf, 20); //解码 char 跟 Byte 类型警告

//            @synchronized (self) {
//                /**
//                 * decode_frame  输入音频数据
//                 *  out_buf 输出数据
//                 */
//                Speex_decode((char*)decode_frame, out_buf, 20); //解码 char 跟 Byte 类型警告
//            }
            
            //音频编解码为耗时操作，在此期间is_streaming可能发生变化，当Stream被销毁后out_track的write操作会导致程序崩溃。
            if (is_stream && (!_pausedByInterrupt)) { //_pausedByInterrupt = YES 被打断， 此时不能再缓存
                MCParsedAudioData *parsedData = [MCParsedAudioData parsedAudioDataWithBytes:[NSMutableData dataWithBytes:out_buf length:320]];
                
                [_buffer enqueueData:parsedData];

            }

            
            offset += 20;
            usleep(1000);
        }
        offset = 0;
        count = 0;
        usleep(2000);
    }
    
    
}

- (void)initForFilePath
{
    char *path = [self GetFilePathByfileName:"rec.pcm"];
    NSLog(@"%s",path);
    fp = fopen(path,"wb");
}
- (char*)GetFilePathByfileName:(char*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *strName = [NSString stringWithFormat:@"%s",filename];
    
    NSString *writablePath = [documentsDirectory stringByAppendingPathComponent:strName];
    
    NSUInteger len = [writablePath length];
    
    char *filepath = (char*)malloc(sizeof(char) * (len + 1));
    
    [writablePath getCString:filepath maxLength:len + 1 encoding:[NSString defaultCStringEncoding]];
    
    return filepath;
}


@end
