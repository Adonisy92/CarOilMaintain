//
//  DropBoxTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/4.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit
import SwiftyDropbox
import SystemConfiguration
import Foundation


class DropBoxTableViewController: myBaseTableViewController,UIPickerViewDelegate,UIPickerViewDataSource
{

    var hudView = UIView()
    let backupitem = ["資料庫","圖片"]
    var picname = [String]()
    
    var nowselect :Int = 0 //預設是資料庫
    
    
    var activityIndicator = UIActivityIndicatorView()

    var t: Timer?
    

    
    var DboxFolder:[String] = ["請按右上角連線，會在 DropBox","建立oilPro/DB與images目錄"]
    
    @IBOutlet weak var mypickview: UIPickerView!
    
    
    
    
    @IBOutlet weak var btn_backup: UIButton!
    
    @IBAction func backup_click(_ sender: Any)
    {
        //先詢問
        switch nowselect
        {
        case 0:
            //資料庫
            
            let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "資料庫備份到雲端請勿關閉視窗", preferredStyle: .alert)
            
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
                
                self.actionStart()
                
                //備份
                self.btn_backup.isEnabled = false
                if let client = DropboxClientsManager.authorizedClient
                {
                    
                    let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
                    let data = NSData(contentsOfFile: dst)
                    let fileData = data as Data?
                    
                    
                    
                    client.files.upload(path: "/oilPro/DB/OilInfo.sqlite", mode: .overwrite , autorename: false, clientModified: nil, mute: false, input: fileData!).response{response, error in
                        if (response != nil)
                        {
                            
                            let alert = UIAlertController(title: "訊息", message: "資料備份完成！", preferredStyle: .alert)
                            
                            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
                            
                            
                            alert.addAction(okButton)
                            
                            self.present(alert, animated: true, completion:nil)
                            self.show_file()
                            self.actionEnd()
                            self.btn_backup.isEnabled = true
                            self.tableView.reloadData()

                            
                        }
                    }
                    
                    
                }
                
                
                
                
            }
            
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            
            actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)
            
            
        case 1:
            //圖
            
            let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "車圖備份到雲端請勿關閉視窗", preferredStyle: .alert)
            
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
                
                
                self.actionStart()
                
                //備份
                self.btn_backup.isEnabled = false
                
                if let client = DropboxClientsManager.authorizedClient
                {
                    
                    var dst:String = NSHomeDirectory()+"/Documents/MyCarImage.jpg"
                    var data = NSData(contentsOfFile: dst)
                    var fileData = data as Data?
                    
                    let fileManager = FileManager.default

                    
                    if fileManager.fileExists(atPath: dst)
                    {

                    
                    client.files.upload(path: "/oilPro/images/MyCarImage.jpg", mode: .overwrite , autorename: false, clientModified: nil, mute: false, input: fileData!).response{response, error in
                                           }
                        
                        
                    
                    }
                    
                    //let pic_count = self.piccount()
                    let mytools = mytool()
                    let mycarid = mytools.read_car_id()
                    
                    
                    for i in 0..<mycarid.count
                    {
                    
                        dst = NSHomeDirectory()+"/Documents/MyCarImage\(mycarid[i]).jpg"
                        data = NSData(contentsOfFile: dst)
                        fileData = data as Data?
                        
                        if fileManager.fileExists(atPath: dst)
                        {
                            
                            
                            client.files.upload(path: "/oilPro/images/MyCarImage\(mycarid[i]).jpg", mode: .overwrite , autorename: false, clientModified: nil, mute: false, input: fileData!).response{response, error in
                            }
                            

                            
                        }

                        
                    
                    
                    
                    }

                    let alert = UIAlertController(title: "訊息", message: "車圖備份完成！", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
                    
                    
                    alert.addAction(okButton)
                    
                    self.present(alert, animated: true, completion:nil)
                    self.show_file()
                    self.actionEnd()
                    self.btn_backup.isEnabled = true
                    self.tableView.reloadData()


                    
                }
                
                
                
                
            }
            
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            
            actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)

            
            
            break
            
            
        case 2:
            
            
            let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "全部資料備份到雲端請勿關閉視窗", preferredStyle: .alert)
            
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
                
                
                self.actionStart()
                
                //備份
                self.btn_backup.isEnabled = false
                
                if let client = DropboxClientsManager.authorizedClient
                {
                    
                    var dst:String = NSHomeDirectory()+"/Documents/MyCarImage.jpg"
                    var data = NSData(contentsOfFile: dst)
                    var fileData = data as Data?
                    
                    let fileManager = FileManager.default
                    
                    
                    if fileManager.fileExists(atPath: dst)
                    {
                        
                        
                        client.files.upload(path: "/oilPro/images/MyCarImage.jpg", mode: .overwrite , autorename: false, clientModified: nil, mute: false, input: fileData!).response{response, error in
                        }
                        
                        
                        
                    }
                    
                    //let pic_count = self.piccount()
                    let mytools = mytool()
                    let mycarid = mytools.read_car_id()
                    
                    
                    for i in 0..<mycarid.count
                    {
                        
                        dst = NSHomeDirectory()+"/Documents/MyCarImage\(mycarid[i]).jpg"
                        data = NSData(contentsOfFile: dst)
                        fileData = data as Data?
                        
                        if fileManager.fileExists(atPath: dst)
                        {
                            
                            
                            client.files.upload(path: "/oilPro/images/MyCarImage\(mycarid[i]).jpg", mode: .overwrite , autorename: false, clientModified: nil, mute: false, input: fileData!).response{response, error in
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
                    data = NSData(contentsOfFile: dst)
                    fileData = data as Data?
                    
                    
                    
                    client.files.upload(path: "/oilPro/DB/OilInfo.sqlite", mode: .overwrite , autorename: false, clientModified: nil, mute: false, input: fileData!).response{response, error in
                        if (response != nil)
                        {
                            
                            
                            
                        }
                    }
                    
                    
                    //沒有的話載入
                    
                    let fm:FileManager = FileManager()
                    
                    let src:String = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
                    
                    dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
                    
                    if !fm.fileExists(atPath: dst) {
                        do {
                            try
                                fm.copyItem(atPath: src, toPath: dst)
                        } catch _ {
                        }
                    }
                    
                    
                    
                    data = NSData(contentsOfFile: dst)
                    fileData = data as Data?
                    
                    client.files.upload(path: "/oilPro/DB/OilInfoCar1.sqlite", mode: .overwrite , autorename: false, clientModified: nil, mute: false, input: fileData!).response{response, error in
                        if (response != nil)
                        {
                            
                            let alert = UIAlertController(title: "訊息", message: "全部資料備份完成！", preferredStyle: .alert)
                            
                            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
                            
                            
                            alert.addAction(okButton)
                            
                            self.present(alert, animated: true, completion:nil)
                            self.show_file()
                            self.actionEnd()
                            self.btn_backup.isEnabled = true
                            self.tableView.reloadData()
                            
                            
                        }
                    }


                    
                    
                    
                }
                
                
                
                
            }
            
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            
            actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)

            
            
            
            
            
            break
            
        default:
            break
        }
      
        
    }
    
    
    @IBOutlet weak var btn_restore: UIButton!
    
    
    @IBAction func restore_click(_ sender: Any)
    {
        
        //先詢問
        
        switch nowselect
        {
        case 0:
            
            let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "資料庫將會從雲端下載至手機端，請勿關閉視窗", preferredStyle: .alert)
            
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
                //Do some other stuff
                
                
                //下載檔案
                
                self.actionStart()
                
                self.btn_restore.isEnabled = false
                
                let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
                
                
                if let client = DropboxClientsManager.authorizedClient
                {
                    
                    client.files.download(path: "/oilPro/DB/OilInfo.sqlite")
                        .response { response, error in
                            if let response = response {
                                let fileContents = response.1
                                
                                do {
                                    try fileContents.write(to: URL(fileURLWithPath: dst), options: .atomic)
                                } catch {
                                    print(error)
                                }
                                
                            }
                            else if let error = error {
                                print(error)
                            }
                    }
                    
                    //第二個
                    
                    let dst1 = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
                    
                    
                    client.files.download(path: "/oilPro/DB/OilInfoCar1.sqlite")
                        .response { response, error in
                            if let response = response {
                                let fileContents = response.1
                                
                                do {
                                    try fileContents.write(to: URL(fileURLWithPath: dst1), options: .atomic)
                                } catch {
                                    print(error)
                                }
                                
                            }
                            else if let error = error {
                                print(error)
                            }
                    }
                    
                    
                    
                    let alert = UIAlertController(title: "訊息", message: "資料復原完成！", preferredStyle:.alert)
                    
                    let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
                    
                    
                    alert.addAction(okButton)
                    
                    self.present(alert, animated: true, completion:nil)
                    
                    self.actionEnd()
                    
                    
                    self.btn_restore.isEnabled = true
                    
                    let mytools = mytool()
                    mytools.save_car_default(defaultid: "0")
                    
                }
                
                
                
            }
            
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            
            actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)

            
            
            break
            
        case 1:
            
            let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "車圖將會從雲端下載至手機端，請勿關閉視窗", preferredStyle: .alert)
            
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default)
            { action -> Void in
                //下載檔案
                _ = DispatchQueue.global()
                DispatchQueue.main.async
                    {
                        let alert = UIAlertController(title: "訊息", message: "下載中...", preferredStyle: .alert)
                        
                        
                        
                        let progressBar = UIProgressView(progressViewStyle: .default)
                        progressBar.setProgress(0.0, animated: true)
                        progressBar.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
                        alert.view.addSubview(progressBar)
                        self.present(alert, animated: true, completion: nil)
                        
                        var progress: Float = 0.0
                        
                        
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                if let client = DropboxClientsManager.authorizedClient
                                {
                                    //車圖
                                    let dst2:String = NSHomeDirectory()+"/Documents/MyCarImage.jpg"
                                    if let client = DropboxClientsManager.authorizedClient
                                    {
                                       

                                        client.files.download(path: "/oilPro/images/MyCarImage.jpg")
                                            .progress { progressData in
                                                
                                                progress = Float(progressData.fractionCompleted)

                                                
                                            }
                                            .response { response, error in
                                                if let response = response
                                                {
                                                    let fileContents = response.1
                                                    
                                                    do
                                                    {
                                                        try fileContents.write(to: URL(fileURLWithPath: dst2), options: .atomic)
                                                        
                                                        
                                                    } catch
                                                    {
                                                        print(error)
                                                    }
                                                    
                                                }
                                                else if let error = error {
                                                    print(error)
                                                }
                                                
                                                
                                                
                                                
                                                
                                        }
                                        
                                        
                                    }
                                    
                                    //第二張
                                    let mytools = mytool()
                                    let carid_r = mytools.read_car_id()
                                    var dst3 = [String]()
                                    for i in 0..<carid_r.count
                                    {
                                        dst3.append(NSHomeDirectory()+"/Documents/MyCarImage\(carid_r[i]).jpg")
                                        
                                        
                                    
                                    }
                                    
                                    
                                    for i in 0..<carid_r.count
                                    {
                                        client.files.download(path: "/oilPro/images/MyCarImage\(carid_r[i]).jpg")
                                            .progress { progressData in
                                                progress = Float(progressData.fractionCompleted)
                                                
                                            }
                                            .response { response, error in
                                                if let response = response {
                                                    let fileContents = response.1
                                                    
                                                    do {
                                                        try fileContents.write(to: URL(fileURLWithPath: dst3[i]), options: .atomic)
                                                        

                                                        
                                                        
                                                        
                                                        
                                                    } catch {
                                                        print(error)
                                                    }
                                                    
                                                }
                                                else if let error = error {
                                                    print(error)
                                                }
                                        }
                                    }//for
                                }

                                repeat {
                                    
                                    DispatchQueue.main.async(flags: .barrier)
                                    {
                                        progressBar.setProgress(progress, animated: true)
                                    }
                                } while progress < 1.0

                                
                                DispatchQueue.main.async
                                    {
                                        
                                        alert.dismiss(animated: true, completion: nil);
                                }
                                
                        }
                        
                        
                        
                        
                }

                
                
            }//action
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(nextAction)
            self.present(actionSheetController, animated: true, completion: nil)
            
            
            
            
            
            
            break
        case 2:
            let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "全部資料將會從雲端下載至手機端，請勿關閉視窗", preferredStyle: .alert)
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default)
            { action -> Void in
                //下載檔案
                _ = DispatchQueue.global()
                        DispatchQueue.main.async
                            {
                                let mytools = mytool()
                                
                                mytools.save_car_default(defaultid: "0")
                                
                                let alert = UIAlertController(title: "訊息", message: "下載中...", preferredStyle: .alert)
                                let progressBar = UIProgressView(progressViewStyle: .default)
                                progressBar.setProgress(0.0, animated: true)
                                progressBar.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
                                alert.view.addSubview(progressBar)
                                self.present(alert, animated: true, completion: nil)

                                var progress: Float = 0.0
                                
                                DispatchQueue.global(qos: .background).async
                                    {
                                        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
                                        if let client = DropboxClientsManager.authorizedClient
                                        {
                                            client.files.download(path: "/oilPro/DB/OilInfo.sqlite")
                                               
                                                .response { response, error in
                                                    if let response = response {
                                                        let fileContents = response.1
                                                        
                                                        do {
                                                            try fileContents.write(to: URL(fileURLWithPath: dst), options: .atomic)
                                                        } catch {
                                                            print(error)
                                                        }
                                                        
                                                    }
                                                    else if let error = error {
                                                        print(error)
                                                    }
                                            }
                                            //第二個
                                            let dst1 = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
                                            client.files.download(path: "/oilPro/DB/OilInfoCar1.sqlite")
                                              
                                                .response { response, error in
                                                    if let response = response {
                                                        let fileContents = response.1
                                                        
                                                        do {
                                                            try fileContents.write(to: URL(fileURLWithPath: dst1), options: .atomic)
                                                        } catch {
                                                            print(error)
                                                        }
                                                        
                                                    }
                                                    else if let error = error {
                                                        print(error)
                                                    }
                                            
                                            //車圖
                                            let dst2:String = NSHomeDirectory()+"/Documents/MyCarImage.jpg"
                                           
                                                client.files.download(path: "/oilPro/images/MyCarImage.jpg")
                                                    .progress { progressData in
                                                        
                                                        progress = Float(progressData.fractionCompleted)
                                                        
                                                        
                                                    }
                                                    .response { response, error in
                                                        if let response = response {
                                                            let fileContents = response.1
                                                            
                                                            do {
                                                                try fileContents.write(to: URL(fileURLWithPath: dst2), options: .atomic)
                                                            } catch {
                                                                print(error)
                                                            }
                                                            
                                                        }
                                                        else if let error = error {
                                                            print(error)
                                                        }
                                                }
                                            }
                                            let mytools = mytool()
                                            let carid_r = mytools.read_car_id()
                                            var dst3 = [String]()
                                            for i in 0..<carid_r.count
                                            {
                                                dst3.append(NSHomeDirectory()+"/Documents/MyCarImage\(carid_r[i]).jpg")
                                            }
                                            
                                            
                                            for i in 0..<carid_r.count
                                            {
                                                client.files.download(path: "/oilPro/images/MyCarImage\(carid_r[i]).jpg")
                                                    .progress { progressData in
                                                        
                                                        progress = Float(progressData.fractionCompleted)
                                                        
                                                        
                                                    }
                                                    
                                                    .response { response, error in
                                                        if let response = response {
                                                            let fileContents = response.1
                                                            
                                                            do {
                                                                try fileContents.write(to: URL(fileURLWithPath: dst3[i]), options: .atomic)
                                                            } catch {
                                                                print(error)
                                                            }
                                                            
                                                        }
                                                        else if let error = error {
                                                            print(error)
                                                        }
                                                }
                                            }//for
                                        }
                                        
                                        repeat {
                                            DispatchQueue.main.async(flags: .barrier) {
                                                progressBar.setProgress(progress, animated: true)
                                            }
                                        } while progress < 1.0
                                        
                                        DispatchQueue.main.async
                                            {
                                            alert.dismiss(animated: true, completion: nil);
                                        }
                                        
                                
                                
                                }
                                

                        }
                
                
            }
            
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            //Create and an option action
            
            actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            self.present(actionSheetController, animated: true, completion: nil)

            
            break
        default:
            break
        }

        



        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        //print(NSHomeDirectory())
        
        if let client = DropboxClientsManager.authorizedClient
        {
            
            //顯示使用者資訊
            client.users.getCurrentAccount().response
                { response, error in
                    if let account = response {
                        self.navigationItem.title = account.name.givenName
                        self.navigationItem.rightBarButtonItem?.title = "離線"

                    } else
                    {
                        if let error = error {
                            switch error as CallError
                            {
                            case .internalServerError( _, _, _):
                                self.btn_backup.isHidden = true
                                break
                                
                             
                            default:
                                self.btn_backup.isHidden = true
                                
                                
                                
                            }
                            
                        }
                    }
            }
            
            client.files.listFolder(path: "/OilPro/DB").response { response, error in
                if response == nil
                {
                    //找不到
                    
                
                    //建目錄
                    
                    self.create_folder()
                    
                    
                }
            }
            
            client.files.listFolder(path: "/OilPro/images").response { response, error in
                if response == nil
                {
                    //找不到
                    
                    
                    //建目錄
                    
                    self.create_folder()
                    
                    
                }
            }

            
            btn_backup.isHidden = false
            btn_restore.isHidden = true

            
            self.show_file()

        }
        else
        {
        
            btn_backup.isHidden = true
            btn_restore.isHidden = true
        
        }
        
        
    
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !isInternetAvailable()
        {
            
            let alert = UIAlertController(title: "訊息", message: "請檢查網路連線", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //按下確定
                //存圖
            
                self.navigationController?.popViewController(animated: true)

                
            
            })
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)
            
            return
            
        }

        mypickview.dataSource = self
        mypickview.delegate = self
 
        
        if DropboxClientsManager.authorizedClient == nil
        {
        
            self.navigationItem.title = "未連線"
            self.navigationItem.rightBarButtonItem?.title = "按我連線"
        }
        else
        {

            self.navigationItem.rightBarButtonItem?.title = "離線"
        }
       
        
        tableView.dataSource = self
        tableView.delegate = self

        
        let image = UIImage(named: "backup.png")?.withRenderingMode(.alwaysTemplate)
        btn_backup.setImage(image, for: .normal)
        btn_backup.tintColor = UIColor.white
        //btn_backup.frame.size = CGSize(width: 75, height: 75)
        //btn_backup.setTitleColor(UIColor.white, for: UIControlState.normal)

        let image1 = UIImage(named: "restore.png")?.withRenderingMode(.alwaysTemplate)
        btn_restore.setImage(image1, for: .normal)
        btn_restore.tintColor = UIColor.white
        //btn_restore.frame.size = CGSize(width: 75, height: 75)

        
        
        
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DboxFolder.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        // Configure the cell...

        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.blue
        cell.accessoryType = .none
        cell.selectionStyle = .none

        cell.textLabel?.text = DboxFolder[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && DboxFolder.count > 1
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
            
        else if indexPath.row == 0 && DboxFolder.count == 1
        {
            
            let imageView = UIImageView(frame: self.view.frame)
            let selimageView = UIImageView(frame: self.view.frame)
            let image = UIImage(named: "topAndBottomRow")!
            let selimage = UIImage(named: "topAndBottomRowSelected")!
            
            
            imageView.image = image
            selimageView.image = selimage
            
            cell.backgroundView = imageView
            cell.selectedBackgroundView = selimageView
            
            
            
        }
            
        else if indexPath.row == DboxFolder.count - 1
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

  

    func create_folder()
    {
    
    
        //建立目錄
        
        if let client = DropboxClientsManager.authorizedClient
        {
            client.files.createFolderV2(path: "/oilPro/DB").response { response, error in
                if let response = response
                {
                    print(response)
                }
                else if let error = error
                {
                    print(error.description)
                    
                }
            }

            client.files.createFolderV2(path: "/oilPro/images").response { response, error in
                if let response = response
                {
                    print(response)
                }
                else if let error = error
                {
                    print(error)
                    
                }
            }

            
        }

    
        return
    
    
    }
    
    
    func show_file()
    {

        if let client = DropboxClientsManager.authorizedClient
        {
         
            if nowselect == 0
            {
            
                client.files.listFolder(path: "/OilPro/DB").response { response, error in
                    if response != nil
                    {
                    
                        let entries: [Files.Metadata] = (response?.entries)!

                        self.printEntries(entries)
 
 
                    }
                    else
                    {
                
                        self.DboxFolder.removeAll()
                        self.DboxFolder.append("無資料庫檔案")
                
                
                    }
                
                }
            }
            
            if nowselect == 1 //圖
            {
                
                client.files.listFolder(path: "/OilPro/images").response { response, error in
                    if response != nil
                    {
                        
                        let entries: [Files.Metadata] = (response?.entries)!
                        

                        self.printEntriesimage(entries)
                        
                        
                    }
                    else
                    {
                        
                        self.DboxFolder.removeAll()
                        self.DboxFolder.append("無車圖檔")
                        
                        
                    }
                    
                }
            }
            
            
            if nowselect == 2 //車加圖
            {
                
                client.files.listFolder(path: "/OilPro/DB").response { response, error in
                    if response != nil
                    {
                        
                        let entries: [Files.Metadata] = (response?.entries)!
                        
                        self.printEntriesALL(entries,type: 1) //車
                        
                        
                    }
                    else
                    {
                        
                        self.DboxFolder.removeAll()
                        self.DboxFolder.append("無資料庫檔")
                        
                        
                    }
                    
                }
                
                client.files.listFolder(path: "/OilPro/images").response { response, error in
                    if response != nil
                    {
                        
                        let entries: [Files.Metadata] = (response?.entries)!
                        
                        self.printEntriesALL(entries,type: 2) //圖
                        
                        
                    }
                    else
                    {
                        
                        self.DboxFolder.removeAll()
                        self.DboxFolder.append("無車圖檔")
                        
                        
                    }
                    
                }
                
                
            }
            
            
            
            
        }
        
        
        return
    }
    
    
    
    func printEntries(_ entries: [Files.Metadata])
    {
        
        
        DboxFolder.removeAll()
        
        for entry: Files.Metadata in entries
        {
            
            
            DboxFolder.append(entry.name)
            
            
            
            
        }
        
        if DboxFolder.count == 0
        {
            DboxFolder.append("無資料庫檔")
            btn_restore.isHidden = true

        }
        else
        {
        
            btn_restore.isHidden = false
        
        }
        
        tableView.reloadData()
//        print(DboxFolder)
        
    }
    
    
    func printEntriesimage(_ entries: [Files.Metadata])
    {
        
        
        DboxFolder.removeAll()
        
        for entry: Files.Metadata in entries
        {
            
            
            DboxFolder.append(entry.name)
            
            
        }
        
        if DboxFolder.count == 0
        {
            DboxFolder.append("無車圖檔")
            btn_restore.isHidden = true
        }
        else
        {
            
            btn_restore.isHidden = false
            
        }
        
        tableView.reloadData()
        //        print(DboxFolder)
        
    }
    
    func printEntriesALL(_ entries: [Files.Metadata],type:Int)
    {
        
        if type == 1
        {

            DboxFolder.removeAll()
            
            
        }
        
        for entry: Files.Metadata in entries
        {
            
            
            DboxFolder.append(entry.name)
            
            
        }
        
        if DboxFolder.count == 0 && type == 2
        {
            DboxFolder.append("無資料庫與車圖檔")
            btn_restore.isHidden = true

        }
        else if DboxFolder.count >= 2
        {
            
            btn_restore.isHidden = false
            
        }

        if type == 2
        {
            
            tableView.reloadData()
        
        }
        //        print(DboxFolder)
        
    }

    
    
    @IBAction func click_me(_ sender: Any)
    {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

    @IBAction func dropbox_connect(_ sender: Any)
    {
        
        if self.navigationItem.rightBarButtonItem?.title == "按我連線"
        {
            
        
            //account_info.read files.content.read files.content.write files.metadata.read
            
            
            let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read","files.metadata.read","files.metadata.write","files.content.read","files.content.write"], includeGrantedScopes: false)
               DropboxClientsManager.authorizeFromControllerV2(
                   UIApplication.shared,
                   controller: self,
                   loadingStatusDelegate: nil,
                   openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                   scopeRequest: scopeRequest
               )
            
            
        }
        else
        {
            
            DropboxClientsManager.unlinkClients()
            
            self.navigationController?.popViewController(animated: true)
            
        }

        
    }
    
    
    func actionStart()
    {
        
        
        self.startTimer()
        
        var screenx: Int
        var screeny: Int
        
        screenx = Int(UIScreen.main.bounds.width)
        screeny = Int(UIScreen.main.bounds.height)
        
        self.hudView.tag = 1
        self.hudView.frame = CGRect(x: screenx/2 - 90 , y: screeny/3 - 70, width: 200, height: 100)
        
        
        self.hudView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.hudView.clipsToBounds = true
        self.hudView.layer.cornerRadius = 10.0
        
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.hudView.frame.width/2, y: self.hudView.frame.height/2, width: 20, height: 20))
        activityIndicator.tag = 2
        
        //set the initial property
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        
        
        self.hudView.addSubview(activityIndicator)
        

        
        self.view.addSubview(self.hudView)

    
    
    
    }
    
    
    func actionEnd()
    {
        
        activityIndicator.stopAnimating()
        //2.0.3pro
        let tmpimg: UIView? = (view.viewWithTag(1))
        if tmpimg != nil
        {
            tmpimg?.removeFromSuperview()
        }

        /*
        let tmpimg2: UIView? = (view.viewWithTag(2))
        if tmpimg2 != nil
        {
            tmpimg2?.removeFromSuperview()
        }

        let tmpimg3: UIView? = (view.viewWithTag(3))
        if tmpimg3 != nil
        {
            tmpimg3?.removeFromSuperview()
        }
         */


        
    }

    func startTimer()
    {
        t = Timer.scheduledTimer(timeInterval: 3000.0, target: self, selector: #selector(self.onTick), userInfo: nil, repeats: false)
    }
    
    @objc func onTick(_ timer: Timer)
    {
        //do smth
        
        //let alert = UIAlertController(title: "訊息", message: "連線時間過長，自動中斷，請再重試", preferredStyle: UIAlertControllerStyle.alert)
        
        //let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        //alert.addAction(okButton)
        
        //self.present(alert, animated: true, completion:nil)
        
        
        stopTimer()
        
        
        
    }
    
    func stopTimer()
    {
        t?.invalidate()
        self.actionEnd()
    }

    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return backupitem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return backupitem[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        nowselect = row
        show_file()
        
        //0代表資料庫
        //1代表圖片
        //2代表全部
        
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = backupitem[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
    
    func piccount() -> Int //回傳圖片數量
    {
    
        var carnum:Int = 0
        
        var paths = [String]()
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask

        var imagename:String = "MyCarImage.jpg"

        paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)

        let fileManager = FileManager.default


        
        if let dirPath = paths.first
        {

            //不用算第1台的
            var imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imagename)


            
            //取回carid的陣列
            //read_car_id
            
            let mytools = mytool()
            
            let carid_r = mytools.read_car_id()
            
            for i in 0..<carid_r.count
            {

                imagename = "MyCarImage\(carid_r[i]).jpg"

                imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(imagename)

                if fileManager.fileExists(atPath: imageURL.path)
                {
                
                    carnum += 1
                
                }

            
            }
            
            
            
        }
    
        return carnum
    
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
