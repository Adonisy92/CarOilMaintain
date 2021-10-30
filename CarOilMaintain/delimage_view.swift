//
//  delimage_view.swift
//  CarOilMaintain
//
//  Created by 楊先民 on 2021/10/9.
//  Copyright © 2021 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class detail_imageViewController:myBaseViewController,UIScrollViewDelegate
{
    
    var paths = [String]()
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask


    var detail_image:String = ""
    var tmpstr:String = ""
    
    
    @IBOutlet weak var detail_view: UITextView!
    
    @IBOutlet weak var detail_img: UIImageView!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    override func viewDidLoad()
    {
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(detail_imageViewController.change_detail_image), name: NSNotification.Name(rawValue: "change_detail_image"), object: nil)
        
        addGestures()


        
    }

    func addGestures()
        {

            //4. Pinch
            myScrollView.minimumZoomScale = 1.0
            myScrollView.maximumZoomScale = 5.0
            myScrollView.delegate = self
            
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGetstureDetected))
            view.addGestureRecognizer(pinchGesture)


        }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.detail_img
    }

    @objc func pinchGetstureDetected(recognizer:UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            //print("開始縮放")
        } else if recognizer.state == .changed {
            // 圖片原尺寸
            let frm = detail_img.frame

            // 縮放比例
            let scale = recognizer.scale

            // 目前圖片寬度
            let w = frm.width

            // 目前圖片高度
            let h = frm.height

            // 縮放比例的限制為 0.5 ~ 2 倍
            if w * scale > 100 && w * scale < 400 {
                detail_img.frame = CGRect(
                  x: frm.origin.x, y: frm.origin.y,
                  width: w * scale, height: h * scale)
                self.view.addSubview(detail_img)

            }
        } else if recognizer.state == .ended {
            //print("結束縮放")
        }

    }

    
    
    @objc func change_detail_image(notification:Notification)
    {
 
        
        self.tmpstr = notification.userInfo?["detail"] as! String

        self.detail_image = notification.userInfo?["detailimage"] as! String

                
        detail_view.text = tmpstr
        
        
        self.loadAlbums()
        
    }
    
    
    func loadAlbums()
    {

        paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            
            
            
            
            
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(self.detail_image)
            
            let image    = UIImage(contentsOfFile: imageURL.path)



            
            
            //detail_img.layer.cornerRadius = 30
            //detail_img.clipsToBounds = true
            detail_img.image = image

                


                


            
        }
 
    
        return
        
        
    }
    
    
}

extension UIImageView {
    var contentRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

