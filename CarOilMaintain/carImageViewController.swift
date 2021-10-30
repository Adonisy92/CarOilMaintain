//
//  carImageViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/29.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class carImageViewController: myBaseViewController
{

    @IBOutlet weak var carimg: UIImageView!
    //var carimg = UIImageView()
    var defaulcarid:String = "0"
    
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask

    var paths = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(carImageViewController.clearcell), name: NSNotification.Name(rawValue: "clearcell"), object: nil)
        
        let mytoos = mytool()
        
        defaulcarid = mytoos.read_car_default()

        loadAlbums()
        
        
        self.view.addSubview(carimg)
        
        
        
    }

    
    override func viewDidAppear(_ animated: Bool)
    {
        
        
        let mytools = mytool()
        
        defaulcarid = mytools.read_car_default()
        loadAlbums()
//        self.view.setNeedsDisplay()
        
    }

    func loadAlbums()
    {

        paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            
            
            var mycarname:String = ""
            
            if defaulcarid == "0"
            {
            
                mycarname = "MyCarImage.jpg"
                
            }
                
            else
            {
            
                mycarname = "MyCarImage\(defaulcarid).jpg"
            
            }
            
            
            
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(mycarname)
            
            let image    = UIImage(contentsOfFile: imageURL.path)
            // Do whatever you want with the image

            if (image == nil)
            {
            
                //carimg.frame = CGRect(x: 20, y: 0, width: screenSize.width - 50, height: screenSize.width - 50 )

                carimg.image = UIImage(named: "noimage.png")

                
                
            }
            else
            {
                
                carimg.image = image
            }
                
        }
            


                


            
        }
 
    
        
        
    


    @objc func clearcell()
    {
    
        //新增一台車要把圖片清空
    
        carimg.image = nil
        

    
    
    }
    
    
  }
