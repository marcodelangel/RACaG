//
//  ViewController.swift
//  RACaG
//
//  Created by Marco Del Angel on 2/18/17.
//  Copyright © 2017 Marco Del Angel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let myPicker = UIImagePickerController()
    var parentVC:TableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let overlay = imagesViewController(nibName:"imagesViewController", bundle: nil)
        
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
