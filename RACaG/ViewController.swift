//
//  ViewController.swift
//  RACaG
//
//  Created by Marco Del Angel on 2/18/17.
//  Copyright © 2017 Marco Del Angel. All rights reserved.
//

import UIKit
import AVFoundation

protocol ImageViewControllerDelegate {
    func takePicture() -> UIImage
    func goBack()
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let myPicker = UIImagePickerController()
    var parentVC:TableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let overlay = imagesViewController(nibName:"imagesViewController", bundle: nil)

        overlay.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            myPicker.delegate = self
            myPicker.sourceType = .camera
            myPicker.showsCameraControls = false
            myPicker.cameraOverlayView = overlay.view
            
            let screenSize:CGSize = UIScreen.main.bounds.size
            let ratio:CGFloat = 4.0 / 3.0
            let cameraHeight:CGFloat = screenSize.width * ratio
            let scale:CGFloat = screenSize.height / cameraHeight
            
            myPicker.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraHeight) / 2.0)
            myPicker.cameraViewTransform = myPicker.cameraViewTransform.scaledBy(x: scale, y: scale)
            
            self.present(myPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController : ImageViewControllerDelegate {
    func takePicture() -> UIImage {
        let imageSize = UIScreen.main.bounds.size as CGSize;
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        for obj : AnyObject in UIApplication.shared.windows {
            if let window = obj as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    // so we must first apply the layer's geometry to the graphics context
                    context!.saveGState();
                    // Center the context around the window's anchor point
                    context!.translateBy(x: window.center.x, y: window.center
                        .y);
                    // Apply the window's transform about the anchor point
                    context!.concatenate(window.transform);
                    // Offset by the portion of the bounds left of and above the anchor point
                    context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                                         y: -window.bounds.size.height * window.layer.anchorPoint.y);
                    
                    // Render the layer hierarchy to the current context
                    window.layer.render(in: context!)
                    
                    // Restore the context
                    context!.restoreGState();
                }
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
       
        return image!
    }
    func goBack() {
    self.imagePickerControllerDidCancel(myPicker)
    }
}
