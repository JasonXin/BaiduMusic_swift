//
//  AudioTool.swift
//  BaiduMusic_swift
//
//  Created by jason on 15/6/29.
//  Copyright (c) 2015年 JasoneIo. All rights reserved.
//

import UIKit
import AVFoundation

var avplay:AVAudioPlayer?
var musicsDict = Dictionary<String,AVAudioPlayer>()
var musicsArr:Array<Musics>!
var playingMusics:Musics?

class AudioTool: NSObject {

    
    
    //懒加载返回歌曲模型数组
    lazy var musicsArrs:Array<Musics> = {
        musicsArr = AudioTool.MusicsDataArr()
        return musicsArr
        }()
    
    //类方法  返回歌曲的模型数组
    class func MusicsDataArr() -> Array<Musics>{
        var musicsArr:[Musics] = Array()
        
        var arr = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("Musics", ofType: "plist")!)
        
        
        for dict  in arr! {
            var musics:Musics = Musics(musicsDict: dict as! Dictionary<String, String>)
            
            musicsArr.append(musics)
        }
        
        return musicsArr
        
    }
    
    
    
    
    //播放音乐  fileName 音乐文件名
    class func playMusic(fileName:String) -> AVAudioPlayer?{ //(类型方法－》类似oc中的静态方法)
        
        
        if fileName.isEmpty {return nil}
        
        avplay = musicsDict[fileName]
    
        
        if avplay == nil {
            var url:NSURL? = NSBundle.mainBundle().URLForResource(fileName as String, withExtension: nil)!
            
            
            if url == nil {return nil}
            
            avplay = AVAudioPlayer(contentsOfURL: url, error: nil)
            
            
            if (avplay!.prepareToPlay() == false) {return nil}
            
            musicsDict[fileName] = avplay!
            

            
        }
        
        //缓冲
        avplay?.prepareToPlay()
        
        if avplay?.playing == false {
            avplay!.play()
        }
        
        return avplay
    }
    
    //暂停音乐  fileName 音乐文件名
    class func pauseMusic(fileName:String){
        if fileName.isEmpty {return }
        
        avplay = musicsDict[fileName]
        
        avplay?.pause()
        
        
    }
    
    //取消当前音乐播放  fileName 音乐文件名
    class func stopMusic(fileName:String){
        
        if fileName.isEmpty {return }
        
        avplay = musicsDict[fileName]
        
        avplay?.stop()
        
        musicsDict.removeValueForKey(fileName)
    }

    
    /**  下一首歌*/
    class func nextMusic() -> Musics{
        var nextIndex:Int = 0
        if (playingMusics != nil) {
            var arr = musicsArr as NSArray
            var playingIndex:Int = arr.indexOfObject(playingMusics!)
            
            nextIndex = playingIndex + 1
            
            if nextIndex >= musicsArr.count {
                nextIndex = 0
            }
            
        }
        
        return musicsArr[nextIndex]
    }
    
    /**  上一首歌*/
    class func previousMusic() -> Musics{
        var previousIndex:Int = 0
        if (playingMusics != nil) {
            var arr = musicsArr as NSArray
            var playingIndex:Int = arr.indexOfObject(playingMusics!)
            
            previousIndex = playingIndex - 1
            
            if previousIndex < 0 {
                previousIndex = musicsArr.count - 1
            }
            
        }
        return musicsArr[previousIndex]
    
    }
    
    
    /**  正在播放的歌*/
    class func playingMusic() -> Musics{
    
        
        return playingMusics!
    }
    
     /**  设置正在播放的歌*/
    class func setPlayingMusic(music:Musics){
        
        var arr = musicsArr as NSArray
        
        if  arr.containsObject(music) == false {
            return
        }
        
        playingMusics = music
        
        
    }
    
}
