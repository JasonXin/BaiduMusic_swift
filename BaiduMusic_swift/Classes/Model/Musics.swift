//
//  Musics.swift
//  BaiduMusic_swift
//
//  Created by jason on 15/6/30.
//  Copyright (c) 2015年 JasoneIo. All rights reserved.
// 

import UIKit

class Musics: NSObject {
  
    /**歌曲名  */
    var name:String!
    
     /**歌曲大图  */
    var icon:String!
    
     /**歌曲文件名  */
    var fileName:String!
    
     /**歌词文件名  */
    var lrcName:String!
    
     /**歌手  */
    var singer:String!
    
     /**歌手图标  */
    var singerIcon:String!
    

    init(musicsDict:Dictionary<String,String>){
        
        name = musicsDict["name"]
        icon = musicsDict["icon"]
        fileName = musicsDict["filename"]
        lrcName = musicsDict["lrcname"]
        singer = musicsDict["singer"]
        singerIcon = musicsDict["singerIcon"]
        
    }
    
        
}
