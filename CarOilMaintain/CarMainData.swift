//
//  SecondViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit


class CarMainDataViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //顯示 titleView
        
        let mybutton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 45))
        
        let logoImagedown = UIImageView(frame: CGRect(x:0, y:0, width: 150, height: 45))
        logoImagedown.contentMode = .scaleAspectFit
        
        let logoImageup = UIImageView(frame: CGRect(x:0, y:0, width: 150, height: 45))
        logoImageup.contentMode = .scaleAspectFit
        
        
        
        let logodown = UIImage(named: "myButton8030down.png")
        logoImagedown.image = logodown
        
        let logoup = UIImage(named: "myButton8030up.png")
        logoImageup.image = logoup
        
        mybutton.setBackgroundImage(logoup, for: .normal)
        mybutton.setBackgroundImage(logodown, for: .highlighted)
        
        mybutton.setTitle("車籍資料", for: .normal)
        
        mybutton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)

        //free
        mybutton.isEnabled = false
        
        self.navigationItem.titleView = mybutton
        
        
       
        
    }
    
    @IBAction func click_me(_ sender: UIBarButtonItem)
    {
        
        
        //建新資料
        
        //預設car改變
        //free
        displayAlert(title_i: "訊息", messagecontent: "Pro版才有多台車的功能")

        
       
    }
    
    
   
    
    @objc func pressButton(button: UIButton)
    {
        
        
       
        
        performSegue(withIdentifier: "todefaultcar2",
                     sender: self)

        
        
    }
    

    @IBAction func choose_pic(_ sender: UIBarButtonItem)
    {
        
        
        performSegue(withIdentifier: "choosecarpic",
                     sender: self)

        //navigationController?.popViewController(animated:true)
        
    }
   
    
    func displayAlert(title_i:String,messagecontent:String)
    {
        
        
        let alert = UIAlertController(title:title_i, message: messagecontent, preferredStyle: .alert)
        
        
        
        
        
        alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion:nil)
        
        
    }
    
    


    
    
}

