//
//  StatsCustomTabBarController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/11.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class StatsCustomTabBarController: UITabBarController {

    var mybutton = UIButton()
    //@IBOutlet weak var financialTabBar: UITabBar!

    
    override func viewWillAppear(_ animated: Bool)
    {
        

        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshimg"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshtext"), object: nil)

        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloaddata"), object: nil)
        
        let mytools = mytool()
        
        let defaultcarid = mytools.read_car_default()
        
        let carinfo:[String] = mytools.read_car_info(defaultcarid: defaultcarid)
        
        mybutton.setTitle("\(carinfo[1])統計", for: .normal)

        
    }

    override func viewDidAppear(_ animated: Bool)
    {
        
        super.viewDidAppear(true)
        
        
        

        
        
        
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

     
        
        
        
        
        //UITabBar.appearance().barTintColor = UIColor.systemGray // Its strange why this method didn't worked for you?.Try updating your post with viewDidLoad.Its a better way to understand the issue.
        //UITabBar.appearance().tintColor = UIColor.purple


        //let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        
        
        
        //顯示 titleView
        
        //最上頭那個xx統計按鈕

        
        mybutton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        
        let logoImagedown = UIImageView(frame: CGRect(x:0, y:0, width: 200, height: 45))
        logoImagedown.contentMode = .scaleAspectFit
        
        let logoImageup = UIImageView(frame: CGRect(x:0, y:0, width: 200, height: 45))
        logoImageup.contentMode = .scaleAspectFit
        
        
        
        let logodown = UIImage(named: "myButton8030down.png")
        logoImagedown.image = logodown
        
        let logoup = UIImage(named: "myButton8030up.png")
        logoImageup.image = logoup
        
        mybutton.setBackgroundImage(logoup, for: .normal)
        mybutton.setBackgroundImage(logodown, for: .highlighted)
        
        mybutton.setTitle("統計", for: .normal)
        
        mybutton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        
        
        self.navigationItem.titleView = mybutton
        
        //free
        mybutton.isEnabled = false
        
        
        self.navigationItem.title = "返回"
        
        //檢查有無輸入基本資料
        


        
        

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /* 新的會跑掉
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.origin.y + 60
        self.tabBar.frame = tabFrame
        
         */
        
        
       
        
    }

    
    @objc func pressButton(button: UIButton)
    {
        
        performSegue(withIdentifier: "todefaultcar3",
                     sender: self)
        
        
    }

    override func viewDidLayoutSubviews() {
        
        //新版的把 tabBar 放在上面的寫法
        let height = navigationController?.navigationBar.frame.maxY
            tabBar.frame = CGRect(x: 0, y: height ?? 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        //－－－－－－－－－－－－－－－－終止－－－－－－－－－－－－－－－－－－－－－－－－－－－－
        

        
        
        
        
        
            super.viewDidLayoutSubviews()
        
    }
    
    

}
