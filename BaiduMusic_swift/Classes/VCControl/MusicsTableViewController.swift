//
//  MusicsTableViewController.swift
//  BaiduMusic_swift
//
//  Created by jason on 15/6/30.
//  Copyright (c) 2015年 JasoneIo. All rights reserved.
//

import UIKit

class MusicsTableViewController: UITableViewController {
    
   
    //懒加载播放音乐控制器
    lazy var playingVC:PlayingMusicsViewController = {
        var tempPlayingVC = PlayingMusicsViewController(nibName: "PlayingMusicsViewController", bundle: nil)
        return tempPlayingVC
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 65
        
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AudioTool().musicsArrs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Identifier:String = "cell"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(Identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }
        
        var musicsModel:Musics = AudioTool().musicsArrs[indexPath.row]
        
        cell?.textLabel?.text = musicsModel.name
        cell?.detailTextLabel?.text = musicsModel.singer
        cell?.imageView?.image = UIImage(named: musicsModel.singerIcon)
        
        return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        AudioTool.setPlayingMusic(AudioTool().musicsArrs[indexPath.row])
        
        //显示播放界面
        playingVC.showPlayingVC()
    
        
    }
    
}
