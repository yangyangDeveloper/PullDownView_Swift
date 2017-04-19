//
//  PullDownView.swift
//  PullDownView_Swift
//
//  Created by Tech-zhangyangyang on 2017/4/18.
//  Copyright © 2017年 Tech-zhangyangyang. All rights reserved.
//

import UIKit

public class PullDownView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var borderColor:UIColor!
    var showPoint:CGPoint!
    var titleArray:[String]!
    var imageArray:[String]!
    var tableView:UITableView!
    var cellClickClosure:((_ index: NSInteger ) -> ())?
    
    let rowHeight:CGFloat = 44
    let sapce:CGFloat = 2
    let pullDownArrowHeight:CGFloat = 10
    let pullDownArrowCurvature:CGFloat = 6
    let handerView:UIButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.borderColor = self.RGBColor(200, 200, 200)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(point: CGPoint, titles: [String], images: [String]) {
        self.init()
        self.showPoint = point
        self.titleArray = titles
        self.imageArray = images
        self.frame = self.getViewFrame()
      
        var rect = self.frame
        rect.origin.x = sapce
        rect.origin.y = pullDownArrowHeight + sapce
        rect.size.width -= sapce * 2
        rect.size.height -= sapce - pullDownArrowHeight
        tableView = UITableView(frame:rect)
        tableView.delegate = self;
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        self.addSubview(self.tableView)
    }

    func getViewFrame() -> CGRect {
        var frame:CGRect = CGRect.zero
        // 高
        frame.size.height = CGFloat(self.titleArray.count) * rowHeight + sapce + pullDownArrowHeight
        // 宽
        
        for (_,value) in self.titleArray.enumerated() {
            let option     = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
            let size = CGSize(width:300 ,height: 100)
            let strSize = (value as AnyObject).boundingRect(with:size, options: option, attributes: attributes, context: nil).size
            let width:CGFloat = strSize.width
            frame.size.width = max(width, frame.size.width)
        }
        
        // 左边距10 + 文本长度 + 右边距40
        frame.size.width = 10 + frame.size.width + 40
        // 如果有icon，左边距 + 图片自身宽
        if self.titleArray.count == self.imageArray.count {
            frame.size.width += 35
        }
        // X(设置左间隔 最小5)
        frame.origin.x = self.showPoint.x - frame.size.width/2
        if frame.origin.x < 5 {
            frame.origin.x = 5
        }
        // Y
        frame.origin.y = self.showPoint.y
        return frame
    }
    
    func show() {
        // 添加一个蒙层
        self.handerView.frame = UIScreen.main.bounds
        self.handerView.backgroundColor = UIColor.clear
        self.handerView.addTarget(self, action: #selector(self.dismiss1), for: .touchUpInside)
        self.handerView.addSubview(self)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self.handerView)
        
        let arrowPoint1:CGPoint = self.convert(self.showPoint, from: self.handerView)
        self.layer.anchorPoint = CGPoint(x: arrowPoint1.x / self.frame.size.width,y: arrowPoint1.y/self.frame.size.height)
        self.frame = self.getViewFrame()
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.alpha = 1
        }) { (finished) in
            UIView.animate(withDuration:0.08, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { 
                self.transform = CGAffineTransform.identity
            }, completion: { (finished) -> Void in})
        }
    }
    
    func dismiss1()  {
        self.dismiss(animate: true)
    }
    
    func dismiss(animate: Bool)  {
        if !animate {
            self.handerView.removeFromSuperview()
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        }) { (true) in
            self.handerView.removeFromSuperview()
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identtifier";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier);
        }
        cell?.backgroundView = UIView()
        cell?.backgroundColor = self.RGBColor(245, 245, 245)
        if self.imageArray.count == self.titleArray.count {
            cell?.imageView?.image = UIImage(named:self.imageArray[indexPath.row])
            
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell?.textLabel?.text = self.titleArray[indexPath.row]
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated: true);
        if cellClickClosure != nil {
            cellClickClosure!(indexPath.row)
        }
        self.dismiss(animate: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    public override func draw(_ rect: CGRect) {
        self.borderColor.set()
        let drawingRect = CGRect(x:0,y:10,width:self.bounds.size.width,height:self.bounds.size.height - pullDownArrowHeight)
        
        let topLeft     = CGPoint(x:drawingRect.minX, y:drawingRect.minY)
        let topRight    = CGPoint(x:drawingRect.maxX, y:drawingRect.minY)
        let bottomRight = CGPoint(x:drawingRect.maxX, y:drawingRect.maxY)
        let bottomLeft  = CGPoint(x:drawingRect.minX, y:drawingRect.maxY)
        let yMin = drawingRect.minY
      
        let arrowPoint = self.convert(self.showPoint, from: self.handerView)
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: topLeft)
        
        let point1 = CGPoint(x:arrowPoint.x - pullDownArrowHeight , y:yMin)
        let point2 = CGPoint(x:arrowPoint.x - pullDownArrowHeight + pullDownArrowCurvature, y:yMin)
        let point3 = CGPoint(x:arrowPoint.x + pullDownArrowHeight , y:yMin)
        let point4 = CGPoint(x:arrowPoint.x + pullDownArrowHeight - pullDownArrowCurvature, y:yMin)
        
        bezierPath.addLine(to: point1)
        bezierPath.addCurve(to: arrowPoint, controlPoint1: point2, controlPoint2: arrowPoint)
        bezierPath.addCurve(to: point3, controlPoint1: arrowPoint, controlPoint2: point4)
        
        bezierPath.addLine(to: topRight)
        bezierPath.addLine(to: bottomRight)
        bezierPath.addLine(to: bottomLeft)

        self.RGBColor(245, 245, 245).setFill()
        bezierPath.fill()
        bezierPath.close()
        bezierPath.stroke()
    }
    
    func RGBColor (_ r:CGFloat,_ g:CGFloat,_ b:CGFloat)-> UIColor{
        return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
}
