//
//  detailHeaderViewController.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/13.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class detailHeaderViewController:myBaseViewController
{


    @IBOutlet weak var lbl_maintext:UILabel!
    
    var is_modified:Bool = false
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lbl_maintext.isHidden = true



        NotificationCenter.default.addObserver(self, selector: #selector(detailHeaderViewController.modify_item_status(notification:)), name: NSNotification.Name(rawValue: "mod_status"), object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(detailHeaderViewController.lblmainStatusoff(notification:)), name: NSNotification.Name(rawValue: "lblmainStatusoff"), object:nil)

        
        
        //btn_restore.frame.size = CGSize(width: 75, height: 75)

        
    }
    
    @objc func lblmainStatusoff(notification:Notification)
    {
     
        lbl_maintext.isHidden = true
        is_modified = false
        
    }
    
    
    @objc func modify_item_status(notification:Notification)
    {
        
        let tmpstr:Int = notification.userInfo?["name"] as! Int

        if tmpstr == 1
        {
            
            is_modified = false
            lbl_maintext.isHidden = true

            

        }
        else
        {
        
            is_modified = true
            lbl_maintext.isHidden = false

        
        
        }
        
        
    }
    
    
    @IBAction func delete_me(_ sender: Any)
    {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "deleteDetail"), object: nil)
        
        lbl_maintext.isHidden = true

        
        
    }

    @IBAction func modify_me(_ sender: Any)
    {
        
        if is_modified //按下取消
        {
        
            lbl_maintext.isHidden = true
            is_modified = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "cancelmodify"), object: nil)

            
        }
        else //按下搜尋
        {

            is_modified = true
            lbl_maintext.isHidden = false
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "modifyDetail"), object: nil)

        
        
        }
        

        
        
    }

    
}
