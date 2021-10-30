//
//  main_popviewTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/24.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class main_popviewTableViewController: UITableViewController
{
    
    
    @IBOutlet weak var del_tableviewcell:UITableViewCell?
    @IBOutlet weak var update_tableviewcell:UITableViewCell?
    @IBOutlet weak var search_tableviewcell:UITableViewCell?
    
    @IBOutlet weak var imgupdate: UIImageView!
    @IBOutlet weak var imgdelete: UIImageView!
    @IBOutlet weak var imgsearch: UIImageView!


    @IBOutlet weak var lblupdate: UILabel!
    @IBOutlet weak var lbldelete: UILabel!
    @IBOutlet weak var lblsearch: UILabel!
    
    var smgindex:Int = 0

    
    var isSearch:Bool = false //預設不是搜尋
    var isDelete:Bool = false //是否按下刪除
    var isEdit:Bool = false //是否按下修改
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //彈出來的視窗背景（有點亮綠色）
        self.view.backgroundColor = UIColor(red: 82.0/255.0, green: 234.0/255.0, blue: 185.0/255.9, alpha: 1.0)
        
        
        if isEdit && !isDelete
        {
            lblupdate.text = "取消"
            imgupdate.image = UIImage(named: "cancel7575")
            del_tableviewcell?.selectionStyle = .none
            search_tableviewcell?.selectionStyle = .none
        }
        else if !isEdit && !isDelete
        {
            
            lblupdate.text = "修改"
            imgupdate.image = UIImage(named: "modify7575")
            del_tableviewcell?.selectionStyle = .default
            search_tableviewcell?.selectionStyle = .default
            
            
        }
        
        if isDelete && !isEdit
        {
            lbldelete.text = "取消"
            imgdelete.image = UIImage(named: "cancel7575")
            update_tableviewcell?.selectionStyle = .none
            search_tableviewcell?.selectionStyle = .none
            
            
        }
        else if !isDelete && !isEdit
        {
            
            lbldelete.text = "刪除"
            imgdelete.image = UIImage(named: "del7575")
            update_tableviewcell?.selectionStyle = .default
            search_tableviewcell?.selectionStyle = .default
            
            
        }
        
        
        if isSearch
        {
            lblsearch.text = "清除搜尋"
            imgsearch.image = UIImage(named: "clean.png")
            
            
        }
        else
        {
            
            lblsearch.text = "搜尋"
            imgsearch.image = UIImage(named: "search7575")
            
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
            
        else if indexPath.row == 5
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
            if isEdit && !isDelete //取消修改
            {
                
                self.isEdit = false
                self.isDelete = false
                
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "請選資料列編輯","value":"cancel"])

                
                //改 maintainmain 的 isedit 屬性
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "EndEdit"), object: nil,userInfo: nil)

                
                
            }
            else if !isDelete // 沒有刪除才能按下修改
            {
            
                self.isEdit = true
                self.isDelete = false
                
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "請選資料列編輯","value":"edit"])
                
                
                //改 maintainmain 的 isedit 屬性
            
                NotificationCenter.default.post(name: Notification.Name(rawValue: "StartEdit"), object: nil,userInfo: nil)

            
            }
            
            
            
            
            break
        case 1:
            //刪除
            if isDelete && !isEdit  //取消刪
            {
                
                isDelete = false
                isEdit = false
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "canceldelclick"), object: nil,userInfo:nil)

                
            }
            else if !isEdit //沒有修改才能刪除
            {
            
                NotificationCenter.default.post(name: Notification.Name(rawValue: "delclick"), object: nil,userInfo:nil)

            
            }
            

            
            
            
            break
        case 2:
            //搜尋
            
            if !isSearch //搜尋
            {
            
            isSearch = true
            
            self.dismiss(animated: true, completion: nil)

            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "search_me"), object: nil,userInfo:nil)
            }
            else //取消
            {

                isSearch = false
                
                self.dismiss(animated: true, completion: nil)
                
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "cancel_Search"), object: nil,userInfo:nil)

            
            }
            
        case 3:
            //列出半年內
            NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "半年內保修主單","value":"rangeshow"])
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "range_show"), object: self,userInfo: ["range_i": 1])

            
            
            
            break
            
        case 4:
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "半年-三年內保修主單","value":"rangeshow"])

            NotificationCenter.default.post(name: Notification.Name(rawValue: "range_show"), object: self,userInfo: ["range_i": 2])

            
            break
            
        case 5:
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "三年以上保修主單","value":"rangeshow"])

            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "range_show"), object: self,userInfo: ["range_i": 3])

            
            break
            
            
            

            
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    

    
}
