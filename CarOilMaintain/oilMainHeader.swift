//
//  oilMainHeader.swift
//  CarOilMaintain
//
//  Created by 楊先民 on 2017/9/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class oilMainHeader: myBaseViewController
{
    @IBOutlet weak var empty_oil: UIButton!

    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        let image = UIImage(named: "del7575")?.withRenderingMode(.alwaysTemplate)
        empty_oil.setImage(image, for: .normal)
        empty_oil.tintColor = UIColor.white

        

        // Do any additional setup after loading the view.
    }

  
    @IBAction func empty_click(_ sender: UIButton)
    {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "emptyoil"), object: nil)

        
    }
    

  

}
