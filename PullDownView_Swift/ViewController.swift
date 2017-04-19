//
//  ViewController.swift
//  PullDownView_Swift
//
//  Created by Tech-zhangyangyang on 2017/4/18.
//  Copyright © 2017年 Tech-zhangyangyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button:UIButton = UIButton(type: .custom)
        button.frame = CGRect(x:40,y:100,width:100,height:60)
        button.backgroundColor = UIColor.orange
        button.setTitle("有图标下拉", for:.normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(button1Clicked(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button2:UIButton = UIButton(type: .custom)
        button2.frame = CGRect(x:180,y:100,width:100,height:60)
        button2.backgroundColor = UIColor.orange
        button2.setTitle("无图标下拉", for:.normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.setTitleColor(UIColor.white, for: .highlighted)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button2.addTarget(self, action: #selector(button2Clicked(sender:)), for: .touchUpInside)
        self.view.addSubview(button2)
    }

    func button1Clicked(sender:UIButton) {
        let point = CGPoint(x:sender.frame.origin.x + sender.frame.size.width/2 , y: sender.frame.origin.y + sender.frame.size.height)
        let titles:Array = ["有图iOS开发进阶1", "价格", "评论","销量", "价格", "评论"]
        let images:Array = ["icon.png", "icon.png", "icon.png","icon.png", "icon.png", "icon.png"]
        let pullDown = PullDownView(point:point, titles:titles, images:images)
        pullDown.cellClickClosure = {(index) -> Void in
            print("select index" + String(index))
        }
        pullDown.show()
    }
    
    func button2Clicked(sender:UIButton) {
        let point = CGPoint(x:sender.frame.origin.x + sender.frame.size.width/2 , y: sender.frame.origin.y + sender.frame.size.height)
        let titles:Array = ["无图iOS开发进阶1", "无图iOS开发进阶2", "无图iOS开发进阶3"]
        let images:Array = Array<String>()
        let pullDown = PullDownView(point:point, titles:titles, images:images)
        pullDown.cellClickClosure = {(index) -> Void in
            print("select index" + String(index))
        }
        pullDown.show()
    }
}

