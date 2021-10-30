//
//  headeroilByYearViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/19.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class headeroilByYearViewController: myBaseViewController
{

    @IBAction func click_me(_ sender: UIButton)
    {


        NotificationCenter.default.post(name: Notification.Name(rawValue: "connect_chart"), object: nil,userInfo: nil)

        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
