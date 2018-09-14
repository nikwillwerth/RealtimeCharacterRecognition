//
//  DrawableImageView.swift
//  ML
//
//  Created by Nik Willwerth on 9/14/18.
//  Copyright © 2018 Nik Willwerth. All rights reserved.
//

import UIKit

class DrawableImageView: UIImageView
{
    private var lastPoint: CGPoint!
    private var completionHandler: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        self.backgroundColor = .black
    }
    
    func drawLine(from:CGPoint,to:CGPoint)
    {
        UIGraphicsBeginImageContext(CGSize(width: frame.width * 2, height: frame.height * 2))
        self.image?.draw(at: CGPoint(x: 0, y: 0))
        let line = UIBezierPath()
        line.move(to: from)
        line.addLine(to: to)
        line.lineCapStyle = .round
        line.lineWidth = 15 // Width of line set here
        UIColor.white.setStroke() // Color of line set here (set to white for erase)
        line.stroke()
        self.image =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // Double the values inside a CGPoint (so it works with retina 2x display
    func doub(p:CGPoint) -> CGPoint
    {
        return CGPoint(x: p.x * 2, y: p.y * 2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        lastPoint = doub(p: touches.first!.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        drawLine(from: lastPoint, to: doub(p: touches.first!.location(in: self)))
        lastPoint = doub(p: touches.first!.location(in: self))
        
        if let completion = completionHandler
        {
            completion()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let completion = completionHandler
        {
            completion()
        }
    }
    
    func setOnTouchesEnded(completion: @escaping () -> Void)
    {
        completionHandler = completion
    }
    
    func clear()
    {
        let rect = CGRect(origin: .zero, size: (self.image?.size)!)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIColor.black.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cgImage = image?.cgImage
        
        self.image = UIImage(cgImage: cgImage!)
    }
}
