//
//  SecondViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class SettingMainViewController:myBaseTableViewController
{
  
    var mybutton = UIButton()
    
    @IBOutlet weak var up_oil: UISwitch!


    
    override func viewDidAppear(_ animated: Bool)
    {
        
        super.viewDidAppear(true)
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        
        
        mybutton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        
        
        self.navigationItem.titleView = mybutton
        
        //free
        mybutton.isEnabled = false
        
        
    }

  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
        
            //進階設定
            performSegue(withIdentifier: "advencesetting",
                         sender: self)

        
        
        }
        
        if indexPath.row == 1
        {

            //車輛顯示在預設中
            //free
            
            let alert = UIAlertController(title: "訊息", message: "只有新油耗維修 Pro版才能設定預設車輛", preferredStyle: .alert)
            
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)

            
        }
        
        if indexPath.row == 3
        {
            //版本歷程
            performSegue(withIdentifier: "historyinfo",
                         sender: self)


        }
        
        
        
    }
    
    
    
    @objc func pressButton(button: UIButton)
    {
        
        
        performSegue(withIdentifier: "todefaultcar4",
                     sender: self)
        
        
        
        
        
        
    }
    
    
    @IBAction func click_oilswitch(_ sender: Any)
    {
        
        let mytools = mytool()
        
        if (up_oil.isOn == false) //變成 false
        {
            mytools.save_oil_upload(defaultid: "0")
            up_oil.setOn(false, animated: false)

        }
            else
        {
            //變成 on時，檢查一下是否有 device id
         

            let mydevice = mytools.getOilDeviceID()
            
            if mydevice == "0"
            {
                
                //print("註冊 deviceid")
                
                let mytools = mytool()
                let car_default = mytools.read_car_default()
                let myweb = myWebService()
                let carinfo = mytools.read_car_info(defaultcarid: car_default)

                myweb.reg_oil_user(car_info: carinfo)
                
                
                
            }
            
                mytools.save_oil_upload(defaultid: "1")
                up_oil.setOn(true, animated: false)
                
                
        }
 
        
        
        
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let mytools = mytool()
        
        let defaultcarid = mytools.read_car_default()
        let oil_upload = mytools.read_oil_upload_default()

        
        let carinfo:[String] = mytools.read_car_info(defaultcarid: defaultcarid)
        
        mybutton.setTitle("\(carinfo[1])設定", for: .normal)

        if (oil_upload == "0")
        {
            up_oil.setOn(false, animated: false)
            
            
        }
        else
        {
            
            up_oil.setOn(true, animated: false)
            //檢查有沒有 updateid，沒有，順便加
            
            //print("註冊 deviceid")
            
            let mytools = mytool()
            
            let mydevice = mytools.getOilDeviceID()
            
            if mydevice == "0"
            {
            
                let car_default = mytools.read_car_default()
                let myweb = myWebService()
                let carinfo = mytools.read_car_info(defaultcarid: car_default)

                myweb.reg_oil_user(car_info: carinfo)
            
            }
            
            
        }

        
        
    }
    

    
    
}

