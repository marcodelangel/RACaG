//
//  TableViewController.swift
//  RACaG
//
//  Created by Marco Del Angel on 3/4/17.
//  Copyright © 2017 Marco Del Angel. All rights reserved.
//

import UIKit

protocol ImageViewControllerDelegate {
    func takePicture() -> UIImage
    func goBack()
}

class TableViewController: UITableViewController {
    
    var cellBackground = [UIImage]()
    var subView = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellBackground.append(UIImage(named:"1")!)
        cellBackground.append(UIImage(named:"2")!)
        cellBackground.append(UIImage(named:"3")!)
        cellBackground.append(UIImage(named:"4")!)
        cellBackground.append(UIImage(named:"5")!)
        
        let subview1 = UIImageView.init(image: cellBackground[0])
        let subview2 = UIImageView.init(image: cellBackground[1])
        let subview3 = UIImageView.init(image: cellBackground[2])
        let subview4 = UIImageView.init(image: cellBackground[3])
        let subview5 = UIImageView.init(image: cellBackground[4])

        subView.append(subview1)
        subView.append(subview2)
        subView.append(subview3)
        subView.append(subview4)
        subView.append(subview5)
        
        let screenSize = UIScreen.main.bounds
        let cellHeight =  screenSize.height / 6
        
        tableView.rowHeight = cellHeight
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var rows = 0
        
        if section == 0{
            
            rows = 1
        }
        
        if section == 1{
            
            rows = cellBackground.count
        }
        
        
        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if indexPath.section == 0{
            
            let image = UIImage(named: "6")
            let imageViewBackgroundSection1 = UIImageView.init(image: image)
            cell.backgroundView = imageViewBackgroundSection1
            
        }
        
        if indexPath.section == 1{
            
            cell.backgroundView = self.subView[indexPath.row]
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.selectedBackgroundView?.alpha = 0.5
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "stages"{
        let vc = storyboard?.instantiateViewController(withIdentifier: "child") as! ViewController
        vc.parentVC = self
        present(vc, animated: true, completion: nil)
        
        }

    }
}
extension TableViewController : ImageViewControllerDelegate {
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
       dismiss(animated: true, completion: nil)
    }
}
