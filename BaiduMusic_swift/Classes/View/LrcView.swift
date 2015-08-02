//
//  LrcView.swift
//  BaiduMusic_swift
//
//  Created by jason on 15/7/1.
//  Copyright (c) 2015年 JasoneIo. All rights reserved.
//

import UIKit

var lrcLinesArr:Array<LrcModel> = Array()
var lrcTableView:UITableView?
var currentTime:NSTimeInterval!
var currentIndex:Int?

class LrcView: UIVisualEffectView,UITableViewDataSource,UITableViewDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        var tableView:UITableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.addSubview(tableView)
        lrcTableView = tableView
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lrcTableView?.frame = self.bounds
        lrcTableView?.contentInset = UIEdgeInsetsMake(lrcTableView!.frame.size.height*0.5, 0, lrcTableView!.frame.size.height*0.5, 0)
    }
    
    //从PlayingMusicViewController 把歌词传递过来
    class func lrcName(lrc:String) {
        
        //清空数组
        lrcLinesArr.removeAll(keepCapacity: true)
        
        //加载歌词
        var url:NSURL = NSBundle.mainBundle().URLForResource(lrc, withExtension: nil)!
        var lrcStr:String =  String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)!
        
        let lrcArr:Array = lrcStr.componentsSeparatedByString("\n")
        
        for lrcCmp in lrcArr {
            var line:LrcModel = LrcModel()
            lrcLinesArr.append(line)
            
            if !lrcCmp.hasPrefix("[") {continue}
            
            //如果是歌词的头部信息
            if lrcCmp.hasPrefix("[ti:") || lrcCmp.hasPrefix("[ar:") || lrcCmp.hasPrefix("[al:") {
                
                var wordStr:String = lrcCmp.componentsSeparatedByString(":").last!
                let endIndex = advance(wordStr.endIndex, -1)
                line.word = wordStr.substringToIndex(endIndex)
            }else{ //歌词文本
                
                var wordArr:Array = lrcCmp.componentsSeparatedByString("]")
                let startIndex = advance(wordArr.first!.startIndex, 1)
                line.time = wordArr.first?.substringFromIndex(startIndex)
                line.word = wordArr.last
            }
        }
        //刷新表格
        lrcTableView?.reloadData()
        
    }
    
    var time:NSTimeInterval{
        get{
            return currentTime!
        }
        set{
            
            //取小数点后两位
            //var a = 1.2232322424244
            //var b = Double(Int(a * 100)) / 100
            //将 Int类型 8 转成 08   String(format: "%02d", i)
            
            
            currentTime = newValue
            
            var minueTemp:Int = Int(currentTime / 60)
            var secondTemp:Int = Int(currentTime % 60)
            
            var msecondTemp1:Double = currentTime - (Double(Int(currentTime)))
            var msecondTemp2:Double = Double(Int(msecondTemp1 * 100)) / 100
            var msecondTemp3:Int = Int(msecondTemp2*100)
            
            let minue:String = String(format: "%02d",minueTemp)
            let second:String = String(format: "%02d",secondTemp)
            let msecond:String = String(format: "%02d",msecondTemp3)
            
            let currentStr:String = minue + ":" + second + "." + msecond
            
            
            (lrcLinesArr as NSArray).enumerateObjectsUsingBlock({ object, index, stop in
                
                var lrc = object as? LrcModel
                
                
                //println(lrc.time)
                
                
                var currentLineTime:String? = lrc?.time
                
                //println(lrc.time)
                
                var nextLineTime:String?
                
                var nextId:Int? = index + 1
                
                
                if nextId < lrcLinesArr.count {
                    nextLineTime = lrcLinesArr[nextId!].time
                }
                
                
                if (currentLineTime?.isEmpty != nil && nextLineTime?.isEmpty != nil){
                    
                    if (currentStr as NSString).compare(currentLineTime!) !=  NSComparisonResult.OrderedAscending && (currentStr as NSString).compare(nextLineTime!) ==  NSComparisonResult.OrderedAscending && currentIndex != index {
                        
                        
                        var reloadRows:Array  = [NSIndexPath(forRow: index, inSection: 0),NSIndexPath(forRow: index - 1, inSection: 0)]
                        
                        currentIndex = index
                        
                        lrcTableView?.reloadRowsAtIndexPaths(reloadRows, withRowAnimation: UITableViewRowAnimation.None)
                        
                        var indexPath:NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
                        
                        lrcTableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                    }
                    
                }
                
                
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrcLinesArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:LrcCell = LrcCell.cellWithTableView(tableView) as! LrcCell
        
        cell.lrcData(lrcLinesArr[indexPath.row])
        
        
        if currentIndex == indexPath.row {
            cell.lrcLabel?.font = UIFont.boldSystemFontOfSize(23)
            cell.lrcLabel?.textColor = UIColor(red: 62/255.0, green: 179/255.0, blue: 250/255.0, alpha: 1.0)
        }else{
            cell.lrcLabel?.font = UIFont.systemFontOfSize(16)
            cell.lrcLabel?.textColor = UIColor.whiteColor()
        }
        
        
        
        return cell
        
    }
    
    
    
    
}
