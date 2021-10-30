//
//  header_oilViewController.swift
//  CarOilMaintain
//
//  Created by 楊先民 on 2017/7/28.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class header_oilViewController: myBaseViewController {

    
    @IBOutlet weak var lbl_header: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(header_oilViewController.show_oil_header(notification:)), name: NSNotification.Name(rawValue: "show_oil_header"), object:nil)


    }


    @objc func show_oil_header(notification:Notification)
    {
        
        let tmpstr:Int = notification.userInfo?["name"] as! Int
        
        switch tmpstr
        {
        case 0:
            lbl_header.text = "請選擇資料列編輯"
            
        case 1:
            lbl_header.text = "半年內油耗"

        case 2:
            lbl_header.text = "半年以上到三年內油耗"
            
        case 3:
            lbl_header.text = "三年以上油耗"

        default:
            break
        }
        
    }

    
}
