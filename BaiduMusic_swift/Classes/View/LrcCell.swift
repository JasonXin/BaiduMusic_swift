//
//  LrcCell.swift
//  BaiduMusic_swift
//
//  Created by jason on 15/7/2.
//  Copyright (c) 2015年 JasoneIo. All rights reserved.
//

import UIKit

class LrcCell: UITableViewCell {
    
    var lrcLabel: UILabel!
    
    
    
    func lrcData(lrc:LrcModel) {
        
        lrcLabel.text = lrc.word
        
    }
    
    
    
    
    class func cellWithTableView(tableView:UITableView) ->AnyObject {
        let Identifier:String = "cell"
        
        var cell: LrcCell? = tableView.dequeueReusableCellWithIdentifier(Identifier) as? LrcCell
        if cell == nil {
            cell = LrcCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        //歌词控件
        lrcLabel = UILabel(frame: self.bounds)
        lrcLabel.font = UIFont.systemFontOfSize(18)
        lrcLabel.textColor = UIColor.whiteColor()
        lrcLabel.textAlignment = NSTextAlignment.Center
        lrcLabel.numberOfLines = 0
        self.addSubview(lrcLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
