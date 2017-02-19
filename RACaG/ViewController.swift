//
//  ViewController.swift
//  RACaG
//
//  Created by Marco Del Angel on 2/18/17.
//  Copyright © 2017 Marco Del Angel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePan(recognizer:UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view{
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
    recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == UIGestureRecognizerState.ended{
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x)+(velocity.y * velocity.y))
            let slideMultiplier = magnitude / 600
            
            let slideFactor = 0.1 * slideMultiplier
            
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            UIView.animate(withDuration: Double(slideFactor * 2),
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {recognizer.view!.center = finalPoint},
                           completion: nil)
        }
        
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer){
        if let view = recognizer.view {
            view.transform = CGAffineTransform.init(scaleX: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }

    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer){
        if let view = recognizer.view{
            view.transform = CGAffineTransform.init(rotationAngle: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
}

