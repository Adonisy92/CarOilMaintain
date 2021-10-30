//
//  compareViewController.swift
//  CarOilMaintain
//
//  Created by 楊先民 on 2021/10/22.
//  Copyright © 2021 YOUNG SEN-MING. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class mycompareViewController: myBaseViewController, WKUIDelegate
{

    @IBOutlet weak var mytestview: WKWebView!
    var uploadOilDeviceID:String = "0" //上傳油耗的檔案
    var urlAddress: String = ""

    

    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

        mytestview.uiDelegate = self

        
        let mytools = mytool()
        uploadOilDeviceID = mytools.getOilDeviceID()
        urlAddress = "http://adonisy94.westus.cloudapp.azure.com/oilinfo/topoil.aspx?deviceid=\(uploadOilDeviceID)"
        
        
        
        //建立一個NSURL物件

        let url = URL(string: urlAddress)
        

        let requestObj = URLRequest(url: url!)

        
        
        mytestview.load(requestObj)
    }
    
    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

    }
    

    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

        
    }


    
    
}
