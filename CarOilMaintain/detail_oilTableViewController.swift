//
//  detail_oilTableViewController.swift
//  CarOilMaintain
//
//  Created by 楊先民 on 2017/7/28.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class detail_oilTableViewController: myBaseTableViewController
{

    var show_detail_type:String = "1" //代表半年內

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor(red: 82.0/255.0, green: 234.0/255.0, blue: 185.0/255.9, alpha: 1.0)

    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
            
            let imageView = UIImageView(frame: self.view.frame)
            let selimageView = UIImageView(frame: self.view.frame)
            let image = UIImage(named: "topRow")!
            let selimage = UIImage(named: "topRowSelected")!
            
            
            imageView.image = image
            selimageView.image = selimage
            
            cell.backgroundView = imageView
            cell.selectedBackgroundView = selimageView
            
            
            
        }
            
        else if indexPath.row == 3
        {
            
            let imageView = UIImageView(frame: self.view.frame)
            let selimageView = UIImageView(frame: self.view.frame)
            
            
            let image = UIImage(named: "bottomRow")!
            let selimage = UIImage(named: "bottomRowSelected")!
            
            
            imageView.image = image
            selimageView.image = selimage
            
            
            cell.backgroundView = imageView
            cell.selectedBackgroundView = selimageView
            
            
            
            
            
        }
        else
        {
            
            let imageView = UIImageView(frame: self.view.frame)
            let selimageView = UIImageView(frame: self.view.frame)
            
            
            let image = UIImage(named: "middleRow")!
            let selimage = UIImage(named: "middleRowSelected")!
            
            imageView.image = image
            selimageView.image = selimage
            
            
            cell.backgroundView = imageView
            cell.selectedBackgroundView = selimageView
            
            
        }
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            //修改
            
            show_detail_type = "0"
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_month"), object: self,userInfo: ["name": 0])


            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_header"), object: self,userInfo: ["name": 0])

            
            break
            
        case 1:
            
            show_detail_type = "1"

            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_month"), object: self,userInfo: ["name": 1])

            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_header"), object: self,userInfo: ["name": 1])

            
            break
            
        case 2:
            
            show_detail_type = "2"

            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_month"), object: self,userInfo: ["name": 2])

            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_header"), object: self,userInfo: ["name": 2])

            
            
            break
            
            
        case 3:
            
            show_detail_type = "3"

            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_month"), object: self,userInfo: ["name": 3])

            NotificationCenter.default.post(name: Notification.Name(rawValue: "show_oil_header"), object: self,userInfo: ["name": 3])

            
            
            break
        default:
            break
        }
        
        
        self.dismiss(animated: true, completion: nil)

        
        
        
    }
    
    
}
