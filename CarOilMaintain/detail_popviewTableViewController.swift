//
//  detail_popviewTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/24.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class detail_popviewTableViewController: myBaseTableViewController
{


    var is_modified:Bool = false
    var is_deleted:Bool = false //預設沒按刪除

    
    @IBOutlet weak var lblupdate: UILabel!
    @IBOutlet weak var lbldelete: UILabel!
    @IBOutlet weak var imgupdate: UIImageView!
    @IBOutlet weak var imgdelete: UIImageView!
    

    @IBOutlet weak var del_tableviewcell:UITableViewCell?
    @IBOutlet weak var update_tableviewcell:UITableViewCell?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 82.0/255.0, green: 234.0/255.0, blue: 185.0/255.9, alpha: 1.0)




       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0 && !is_modified && !is_deleted// 沒按刪除修改
        {
            is_modified = true
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "modifyDetail"), object: nil)

            NotificationCenter.default.post(name: Notification.Name(rawValue: "mod_status"), object: self,userInfo: ["name": 0])
            
            self.dismiss(animated: true, completion: nil)
            
            
            
        }
        else if indexPath.row == 0 && !is_deleted// 取消
        {
            is_modified = false
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cancelmodify"), object: nil)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "mod_status"), object: self,userInfo: ["name": 1])
            
            self.dismiss(animated: true, completion: nil)
            
            
            
        }

        
        if indexPath.row == 1 && !is_deleted && !is_modified// 沒按修改刪除
        {
            is_deleted = true
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "deleteDetail"), object: nil)


            
            self.dismiss(animated: true, completion: nil)
            
            
            
        }
        else if indexPath.row == 1 && is_deleted && !is_modified// 取消
        {
            is_deleted = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "deleteDetail"), object: nil)

            self.dismiss(animated: true, completion: nil)
            
            
            
        }

       
        
        
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
            
        else if indexPath.row == 1
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
        
        
        if is_modified
        {
            lblupdate.text = "取消"
            imgupdate.image = UIImage(named: "cancel7575")
            del_tableviewcell?.selectionStyle = .none
        }
        else
        {
            
            lblupdate.text = "修改"
            imgupdate.image = UIImage(named: "modify7575")
            del_tableviewcell?.selectionStyle = .default
            
            
        }
        
        if is_deleted
        {
            lbldelete.text = "取消"
            imgdelete.image = UIImage(named: "cancel7575")
            update_tableviewcell?.selectionStyle = .none
            
            
        }
        else
        {
            
            lbldelete.text = "刪除"
            imgdelete.image = UIImage(named: "del7575")
            update_tableviewcell?.selectionStyle = .default
            
            
        }
        
        
    }


}
