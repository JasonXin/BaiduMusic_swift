//
//  PlayingMusicsViewController.swift
//  BaiduMusic_swift
//
//  Created by jason on 15/6/30.
//  Copyright (c) 2015年 JasoneIo. All rights reserved.
//

import UIKit
import AVFoundation

class PlayingMusicsViewController: UIViewController,AVAudioPlayerDelegate {
    /**  纪录歌曲模型*/
    var playingMusic:Musics?
    /**  监听当前歌曲播放进度*/
    var currentTimer:NSTimer?
    /**  监听当前歌词播放进度*/
    var lrcTimer:CADisplayLink?
    
    @IBOutlet weak var currentTimeView: UIButton!
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var songLabel: UILabel!
    
    @IBOutlet weak var singerLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var slider: UIButton!
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    @IBOutlet weak var lrcview: LrcView!
    
    @IBAction func lrcOrPic(sender: UIButton) {
        
        if lrcview.hidden {
            lrcview.hidden = false
            sender.selected = true
            
            addlrcTimer()
        }else{
            lrcview.hidden = true
            sender.selected = false
            
            removelrcTimer()
        }
        
    }
    
    
    //下一首
    @IBAction func nextMusic() {
        
        var window:UIWindow = UIApplication.sharedApplication().windows.last as! UIWindow
        window.userInteractionEnabled = false
        
        //重置当前歌曲
        resetPlayingMusics()
        
        //下一首的歌曲
        AudioTool.setPlayingMusic(AudioTool.nextMusic())
        
        startPlayingMusics()
        
        window.userInteractionEnabled = true
        
    }
    //上一首
    @IBAction func previousMusic() {
        var window:UIWindow = UIApplication.sharedApplication().windows.last as! UIWindow
        window.userInteractionEnabled = false
        
        //重置当前歌曲
        resetPlayingMusics()
        
        //下一首的歌曲
        AudioTool.setPlayingMusic(AudioTool.previousMusic())
        
        startPlayingMusics()
        
        window.userInteractionEnabled = true
    }
    
    //暂停／播放
    @IBAction func playOrPause() {
        
        if playOrPauseBtn.selected { //暂停
            playOrPauseBtn.selected = false
            
            AudioTool.pauseMusic(playingMusics!.fileName)
            
            removeCurrentTimeTimer()
            removelrcTimer()
            
        }else{//播放
            playOrPauseBtn.selected = true
            
            AudioTool.playMusic(playingMusics!.fileName)
            
            addCurrentTimeTimer()
            addlrcTimer()
        }
        
    }
    
    
    /**  进度条点击方法*/
    @IBAction func tapProgressBg(sender: UITapGestureRecognizer) {
        //获得触摸点
        var point:CGPoint = sender.locationInView(sender.view)
        
        avplay!.currentTime = Double(point.x / sender.view!.frame.size.width) * avplay!.duration
         
        updateCurrentTime()
        
    }
    
    /**  滑块拖动方法方法*/
    @IBAction func sliderPan(sender: UIPanGestureRecognizer) {
        
        //获得挪动的距离
        var t:CGPoint = sender.translationInView(sender.view!)
        sender.setTranslation(CGPointZero, inView: sender.view)//挪动一点就清空距离
        
        var sliderMaxX:CGFloat = self.view.frame.size.width - slider.frame.size.width
        //控制滑块和进度条的frame
        slider.frame.origin.x += t.x
        
        if slider.frame.origin.x < 0 {
            slider.frame.origin.x = 0
        }else if slider.frame.origin.x > sliderMaxX{
            slider.frame.origin.x = sliderMaxX
        }
        
        progressView.frame.size.width = slider.center.x
        
        //设置时间
        
        var progress:Double = Double(slider.frame.origin.x / sliderMaxX)
        var time:NSTimeInterval = avplay!.duration * progress
        slider.setTitle(strWithTime(time), forState: UIControlState.Normal)
        
        //显示半透明指示文字
        currentTimeView.setTitle(slider.currentTitle, forState: UIControlState.Normal)
        currentTimeView.frame.origin.x = slider.frame.origin.x
        
        //开始拖拽就停止定时器
        if sender.state == UIGestureRecognizerState.Began {
            
            removeCurrentTimeTimer()
            
            
            currentTimeView.hidden = false
            
            currentTimeView.frame.origin.y = currentTimeView.superview!.frame.size.height - 5 - currentTimeView.frame.size.height
            
        }else if sender.state == UIGestureRecognizerState.Ended { //松开重新添加定时器
            
            //设置播放器时间
            avplay!.currentTime = time
            
            addCurrentTimeTimer()
            
            
            currentTimeView.hidden = true
        }
        
        
    }
    
    
    //退出播放界面
    @IBAction func exit() {
        
        //移除定时器
        removeCurrentTimeTimer()
        removelrcTimer()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.view.frame.origin.y = self.view.frame.size.height
            
            }, completion: { finished in
                
                self.view.hidden = true
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    /** 显示播放控制器*/
    func showPlayingVC() {
        var window:UIWindow = UIApplication.sharedApplication().windows.last as! UIWindow
        self.view.hidden = false
        self.view.frame = window.bounds
        window.addSubview(self.view)

        self.view.frame.origin.y = self.view.frame.size.height

        
        //检测是否换了歌曲
        if playingMusic?.name != AudioTool.playingMusic().name {
            //重置音乐
            resetPlayingMusics()
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.view.frame.origin.y = 0
            },completion: { finished in
              
            //播放音乐
            self.startPlayingMusics()
                
        })
        
    }
    
    //播放音乐
    func startPlayingMusics() {
        
        if playingMusic == AudioTool.playingMusic()  {
            
            //开始定时器
            addCurrentTimeTimer()
            
            addlrcTimer()
            
            return
        }

        var musicsModel:Musics = AudioTool.playingMusic()
        
        playingMusic = musicsModel //把正在播放的歌存起来
        
        iconView.image = UIImage(named: playingMusic!.icon)
        singerLabel.text = playingMusic!.singer
        songLabel.text = playingMusic!.name
        
        
        //开始播放
       var avplays = AudioTool.playMusic(AudioTool.playingMusic().fileName)
        
        avplays?.delegate = self
        //设置时长
        durationLabel.text = strWithTime(avplays!.duration)
        
        
        //开始定时器
        addCurrentTimeTimer()
        addlrcTimer()
        
        
        //设置播放按钮的状态
        playOrPauseBtn.selected = true
        
        
        
       //传递歌词数据
        LrcView.lrcName(playingMusics!.lrcName)
        
        
    }
    
    /**  时间长度转为时间字符串*/
    func strWithTime(time:NSTimeInterval) -> String {
        var minute:Int = Int(time/60)
        var second:Int = Int(time%60)
        
        return String(minute) + ":" + String(second)
    }
    
    //重置正在播放的音乐
    func resetPlayingMusics() {
        
        //重置界面数据
        iconView.image = UIImage(named: "play_cover_pic_bg")
        singerLabel.text = nil
        songLabel.text = nil
        durationLabel.text = nil
        
        //停止播放
        if playingMusic?.fileName == nil {return}
        AudioTool.stopMusic(playingMusic!.fileName)
        
        //清空正在播放的歌曲
        avplay = nil
        
        //停止定时器
        removeCurrentTimeTimer()
        removelrcTimer()
        
        //设置播放按钮的状态
        playOrPauseBtn.selected = false
    }
    
    /**  定时器的添加*/
    func addCurrentTimeTimer() {
    
        //正在播放才能接着放歌
        if avplay!.playing == false {return}
        
        removeCurrentTimeTimer()
        
        /**  这边先调用下，让滑块上立刻显示播放时间进度*/
        updateCurrentTime()
        
        currentTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCurrentTime", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(currentTimer!, forMode: NSRunLoopCommonModes)
    }
    
     /**  定时器的移除*/
    func removeCurrentTimeTimer() {
        currentTimer?.invalidate()
        currentTimer = nil
    }
    
    
    /**   更新播放进度*/
    func updateCurrentTime() {
        //计算进度值
        var progress = avplay!.currentTime / avplay!.duration
        
        var sliderMaxX:CGFloat = self.view.frame.size.width - slider.frame.size.width
        
        slider.frame.origin.x = sliderMaxX * CGFloat(progress)
        
        //设置滑块上的播放时间
        slider.setTitle(strWithTime(avplay!.currentTime), forState: UIControlState.Normal)
        
        //设置进度条
        progressView.frame.size.width = slider.center.x
    }

    
    
    
    /**  歌词定时器的添加*/
    func addlrcTimer() {
        
        //正在播放才能接着放歌
        if avplay!.playing == false || lrcview.hidden {return}
        
        removelrcTimer()
        
        /**  这边先调用下，让滑块上立刻显示播放时间进度*/
        updateLrc()
        
        lrcTimer = CADisplayLink(target: self, selector: "updateLrc")
        lrcTimer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    /**  歌词定时器的移除*/
    func removelrcTimer() {
        
        lrcTimer?.invalidate()
        lrcTimer = nil
    }
    
    
    func updateLrc() {
        
        lrcview.time = avplay!.currentTime
        
    }
    
    
    
    /**  AVAudioPlayerDelegate  代理方法*/
    
    /**  自动播放下一首*/
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        nextMusic()
    }
    
    /**  当播放器遇到中断时调用*/
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        
        if avplay!.playing {
            playOrPause()
        }
    }
    
    /**  中断结束的时候调用*/
    func audioPlayerEndInterruption(player: AVAudioPlayer!, withOptions flags: Int) {
        
    }
    
}
