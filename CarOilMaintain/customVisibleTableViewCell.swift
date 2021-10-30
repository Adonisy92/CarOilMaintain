//
//  customVisibleTableViewCell.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/16.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class customVisibleTableViewCell: UITableViewCell
{

    
    @IBOutlet weak var lblcar_nickname: UILabel!
    @IBOutlet weak var lblcar_style: UILabel!
    @IBOutlet weak var sw_visible: UISwitch!

    var carid:String = ""
    
    
    @IBAction func change_me(_ sender: Any)
    {
        
        let mytools = mytool()
        
        if sw_visible.isOn
        {
        
            mytools.update_visible_status(carid: carid, status: "0")
        }
        else
        {

            mytools.update_visible_status(carid: carid, status: "1")

            
        }
        
        
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadtable"), object: nil) 先暫時拿掉不然會有錯

        
    }
    
    func setcarid(carid:String)
    {
        self.carid = carid
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
