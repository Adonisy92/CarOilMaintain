//
//  AdvenceSettingTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/2.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import MessageUI



class AdvenceSettingTableViewController: myBaseTableViewController,UIPickerViewDataSource,UIPickerViewDelegate,URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate
{
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: Foundation.URLSession!
    
    var tField: UITextField!
    var tField2: UITextField!
    var tField3: UITextField!
    var tField4: UITextField!
    
    var hudView = UIView()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var t: Timer?


    
    @IBOutlet weak var lblupdate_date: UILabel!
    
    //維修
    
    var tField5: UITextField!
    var tField6: UITextField!
    var tField7: UITextField!
    
    //總里程
    
    var tField8: UITextField!

    
    var oilinfo = [String]()
    var maintaininfo = [String]()
    var lastwalkkm:String = "0"

    
    var PickeroilStyle:UIPickerView = UIPickerView()
    var BackupStyle:UIPickerView = UIPickerView()

    
    var oilStyle:[String] = ["行走里程", "總里程數"]
    var backupstyle:[String] = ["iCloud","DropBox","email"]
    var defaultOilStyle:Int = 0 //行走里程是預設
    var defaultbackupStyle:Int = 0 //dropbox是預設

    @IBOutlet weak var lbl_oiltype: UILabel!
    
    @IBAction func click_me(_ sender: Any)
    {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)

        
        PickeroilStyle.dataSource = self
        PickeroilStyle.delegate = self
        BackupStyle.dataSource = self
        BackupStyle.delegate = self
        
        let mytools = mytool()
        defaultOilStyle = mytools.return_oil_option()
        
        if defaultOilStyle == 0
        {
            lbl_oiltype.text = "行走里程"
        }
        else
        {
        
            lbl_oiltype.text = "總里程數"
        
        }
        

        let carsetting_updatedate = mytools.carsetting_update_date()
        
        lblupdate_date.text = "更新日期:\(carsetting_updatedate)"


        
        if mytools.check_carid_column() != true
        {
            
            _ = mytools.add_repaireTable_column_carid() //加一個欄位
            _ = mytools.insert_car_repaire_column_by_carid() //塞值
            _ = mytools.add_maintain_picurl_defaultcar() //pic欄位
            _ = mytools.add_maintain_picurl_new_car()

            
        }
        
        if mytools.check_cateogyr_orders_num() != true
        {
            
            //檢查分類是否有 orders_num欄位
            _ = mytools.add_category_ordersnums()

            
            
        }
        
        if mytools.check_products_orders_num() != true
        {
            
            //檢查產品是否有 orders_num欄位

            _ = mytools.add_product_ordersnums()
            
            
        }
        
        

    
        
        
    }

   

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
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
            
        else if indexPath.row == 7
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
    
    func configurationTextField(_ textField: UITextField!)
    {
        tField = textField
        tField.clearButtonMode = .whileEditing
        tField.keyboardType = .default
        tField.text = oilinfo[0]
        tField.delegate = self
        
        
        
    }
    
    func configurationTextField2(_ textField: UITextField!)
    {
        tField2 = textField
        tField2.clearButtonMode = .whileEditing
        tField2.keyboardType = .default
        tField2.text = oilinfo[1]
        tField2.delegate = self
        
        
        
    }
    
    func configurationTextField3(_ textField: UITextField!)
    {
        tField3 = textField
        tField3.clearButtonMode = .whileEditing
        tField3.keyboardType = .default
        tField3.text = oilinfo[2]
        tField3.delegate = self
        
        
        
    }
    
    func configurationTextField4(_ textField: UITextField!)
    {
        tField4 = textField
        tField4.clearButtonMode = .whileEditing
        tField4.keyboardType = .default
        tField4.text = oilinfo[3]
        tField4.delegate = self
        
        
        
    }

    
    func configurationTextField5(_ textField: UITextField!)
    {
        tField5 = textField
        tField5.clearButtonMode = .whileEditing
        tField5.keyboardType = .default
        tField5.text = maintaininfo[0]
        tField5.delegate = self
        
        
        
    }
    
    func configurationTextField6(_ textField: UITextField!)
    {
        tField6 = textField
        tField6.clearButtonMode = .whileEditing
        tField6.keyboardType = .default
        tField6.text = maintaininfo[1]
        tField6.delegate = self
        
        
        
    }
    
    func configurationTextField7(_ textField: UITextField!)
    {
        tField7 = textField
        tField7.clearButtonMode = .whileEditing
        tField7.keyboardType = .default
        tField7.text = maintaininfo[2]
        tField7.delegate = self
        
        
        
    }

    
    func configurationTextField8(_ textField: UITextField!)
    {
        tField8 = textField
        tField8.clearButtonMode = .whileEditing
        tField8.keyboardType = .decimalPad
        tField8.text = self.lastwalkkm
        tField8.delegate = self
        
        
        
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
            //總里程式修改
            
            let alert = UIAlertController(title:"", message: "開始算油耗時的總里程數設定", preferredStyle: .alert)
            //alert.preferredContentSize = CGSize(width: 450, height: 300)
            
            
            alert.addTextField(configurationHandler: self.configurationTextField8)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in

                //按下確定
                
                //先檢查資料對不對
                
                
                
                //按下確定就要 update
                //self.save_info()
                
                let tmp_lastkm = Float(self.tField8.text!)
                var tmplastkm:String = ""
                
                if tmp_lastkm != nil
                {
                
                    tmplastkm = String(format: "%.1f", tmp_lastkm!)
                
                }
                else
                {
                
                    tmplastkm = "0"
                    
                }
                
                
                let mytools = mytool()
                
                mytools.update_total_lastkm(lastkm: tmplastkm)
                self.reload_setting()
                //修改完成
                
                
            }))
            self.present(alert, animated: true, completion:nil)
            
            
        }
        if indexPath.row == 1
        {
            //產品分類設定
            performSegue(withIdentifier: "productcategorysetting",
                         sender: self)

        }
        
        if indexPath.row == 2
        {
            //產品名稱設定
            
            performSegue(withIdentifier: "goproducts",
                         sender: self)

            
            
        }
        
        
        if indexPath.row == 3
        {
            //維修 menu 
            let alert = UIAlertController(title:"", message: "自訂選單設定", preferredStyle: .alert)
            //alert.preferredContentSize = CGSize(width: 450, height: 300)
            
            
            alert.addTextField(configurationHandler: self.configurationTextField5)
            
            alert.addTextField(configurationHandler: self.configurationTextField6)
            
            alert.addTextField(configurationHandler: self.configurationTextField7)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //print("Done !!")
                //按下確定
                
                self.maintaininfo[0] = self.tField5.text!
                self.maintaininfo[1] = self.tField6.text!
                self.maintaininfo[2] = self.tField7.text!
                
                
                //按下確定就要 update
                //self.save_info()
                
                
                let mytools = mytool()
                
                let rs_id = mytools.read_maintain_id()
                
                mytools.update_maintain_menu(repaireinfo: self.maintaininfo, repaireid: rs_id)
                
                //self.tableView.reloadData()
                
                
                
            }))
            self.present(alert, animated: true, completion:nil)
            
            

            
            
        }
        
        
        
        
        
        
        if indexPath.row == 4
        {
            //油種設定
            
            let alert = UIAlertController(title:"", message: "油種資訊", preferredStyle: .alert)
            //alert.preferredContentSize = CGSize(width: 450, height: 300)
            
            
            alert.addTextField(configurationHandler: self.configurationTextField)

            alert.addTextField(configurationHandler: self.configurationTextField2)

            alert.addTextField(configurationHandler: self.configurationTextField3)

            alert.addTextField(configurationHandler: self.configurationTextField4)

            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //print("Done !!")
                //按下確定

                self.oilinfo[0] = self.tField.text!
                self.oilinfo[1] = self.tField2.text!
                self.oilinfo[2] = self.tField3.text!
                self.oilinfo[3] = self.tField4.text!
                
                
                //按下確定就要 update
                //self.save_info()
                
                
                let mytools = mytool()
                
                mytools.update_oil_type(oilinfo: self.oilinfo)
                
                
                //self.tableView.reloadData()
                
                
                
            }))
            self.present(alert, animated: true, completion:nil)


            
            
        }
        
        
        
        if indexPath.row == 5
        {
        //最新車廠名單下載
        
            
            self.update_db()
        
        
        
        
        }
        
        
        
        
        if indexPath.row == 6
        {
            
            //油耗選項設定
            
            let mytools = mytool()
            let defaultcarid = mytools.read_car_default()

            var car_info = [String]()
            
            car_info = mytools.read_car_info(defaultcarid: defaultcarid)
            
            let nickname = car_info[1]
            
            let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "請選擇\(nickname)里程計算法", preferredStyle: .alert)
            //alert.preferredContentSize = CGSize(width: 450, height: 450)
            PickeroilStyle.frame = CGRect(x: 0, y: 0, width: 270, height: 150)

            PickeroilStyle.selectRow(defaultOilStyle, inComponent: 0, animated: true)

            alert.view.addSubview(self.PickeroilStyle)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //print("Done !!")
                //按下確定
                
 
                //抓出所選值
                
                mytools.update_oil_option(oilOption_i: self.defaultOilStyle)
                
                
                //存入資料庫
                
                //顯示
                
                let mytools = mytool()
                self.defaultOilStyle = mytools.return_oil_option()
                
                if self.defaultOilStyle == 0
                {
                    self.lbl_oiltype.text = "行走里程"
                }
                else
                {
                    
                    self.lbl_oiltype.text = "總里程數"
                    
                }

                
                
            }))
            self.present(alert, animated: true, completion:nil)

            
            
        }
        
        
        if indexPath.row == 7
        {
            
            //雲端備份
            
            
            let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "請選擇備份方式", preferredStyle: .alert)
            //alert.preferredContentSize = CGSize(width: 450, height: 450)
            BackupStyle.frame = CGRect(x: 0, y: 0, width: 270, height: 150)
            BackupStyle.selectRow(defaultbackupStyle, inComponent: 0, animated: true)
            
            alert.view.addSubview(self.BackupStyle)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //print("Done !!")
                //按下確定
                
            
                switch self.defaultbackupStyle
                {
                case 0:
                    self.performSegue(withIdentifier: "icloudbackup",sender: self)
                case 1:
                    self.performSegue(withIdentifier: "connectdropbox",sender: self)

                case 2:
                    self.sendMail()
                default:
                    return
                    
                }
                
                
                

                
            }))
            
            self.present(alert, animated: true, completion:nil)

            
            
            
        }
        
       

        
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
     
        if pickerView == BackupStyle
        {
            return 3
        }
        return 2
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {

        if pickerView == BackupStyle
        {
            
            return backupstyle[row]
            
        }
        

        
        return oilStyle[row]
        //需抓資料庫的預設設定
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if pickerView == BackupStyle
        {
            
            defaultbackupStyle = row
            
        }
        defaultOilStyle = row
        
    }
    
    
    func update_db()
    {
     
        if !isInternetAvailable()
        {

            let alert = UIAlertController(title: "訊息", message: "請檢查網路連線", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)
            
            return
        }
        
        

        
        let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "開始下載車型資料...", preferredStyle: .alert)
        
        let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
            //Do some other stuff
            
            //刪資料庫並且將檔案從 Bundle加入
            
            self.actionStart()
            
            self.del_db_file()
            
            self.copy_from_url() //從 internet抓資料
            
            
            
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

        
        
        return
    }
    
    
    func del_db_file()
    {
        
        let fm:FileManager = FileManager()
        
        let dst:String = NSHomeDirectory()+"/Library/carSetting.sqlite"
        if  fm.fileExists(atPath: dst)
        {
            
            do {
                try fm.removeItem(atPath: dst)
                
                
            } catch let error as NSError
            {
                
                print(error)
                
            }
            
        }
        
        return
        
        
    }

    
    func copy_from_url()
    {
        let url = URL(string: "https://pse.is/3qn3wf")!
        
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
        
        
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL)
    {
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]

        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath + "/carSetting.sqlite")
        
        
        do
        {
            try fileManager.copyItem(at: location, to: destinationURLForFile)
            
        }catch
        {
            print("An error occurred while moving file to destination url")
        }
        
    }

    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?)
    {
        downloadTask = nil
        
        //完成
        
        
        
        if (error != nil)
        {
            print(error.debugDescription)
        }
        else
        {
            
            let dst:String = NSHomeDirectory()+"/Library/carSetting.sqlite"
            
            
            if sizeForLocalFilePath(dst) == 0
            {
                
                self.copy_from_url() //從頭 internet抓資料

                self.backgroundSession.finishTasksAndInvalidate()
                
                //self.backgroundSession = nil
                
                
            }
            else
            {
                let alert = UIAlertController(title: "訊息", message: "下載完成！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default , handler:{ (UIAlertAction)in
                    //按下確定
                    //存圖
                    
                    self.backgroundSession.finishTasksAndInvalidate();

                    self.actionEnd()
                   
                    
                    
                }))
                
                
                
                //self.backgroundSession = nil

                self.present(alert, animated: true, completion: nil)
                
                let mytools = mytool()
                
                let carsetting_updatedate = mytools.carsetting_update_date()
                
                lblupdate_date.text = "更新日期:\(carsetting_updatedate)"
                
                
            }
            
            
            
        }
    }
    
    
    func sizeForLocalFilePath(_ filePath:String) -> UInt64
    {
        
        var fileSize : UInt64 = 0
        
        do {
            let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
            
            if let _attr = attr {
                fileSize = _attr.fileSize();
            }
        } catch {
            print("Error: \(error)")
        }
        return fileSize
        
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
    
        let mytools = mytool()
        
        let defaultcarid:String = mytools.read_car_default()
        
        let carinfo = mytools.read_car_info(defaultcarid:defaultcarid )
        
        
        
        self.navigationItem.title = "\(carinfo[1])設定"
        
        
        self.reload_setting()


        
    }
    
    func reload_setting()
    {
        
        let mytools = mytool()

        oilinfo = mytools.read_oil_type()
        maintaininfo = mytools.read_maintain_menu()
        lastwalkkm = mytools.read_total_lastkm()
        //載入lastkm
        
       
        
        

        
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
        
        let tmpimg2: UIView? = (view.viewWithTag(2))
        if tmpimg2 != nil
        {
            tmpimg2?.removeFromSuperview()
        }
        
        
    }
    
    func startTimer()
    {
        t = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.onTick), userInfo: nil, repeats: false)
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

    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

    }
    

    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

        
    }
    
    
    func sendMail()
    {
        
        if !MFMailComposeViewController.canSendMail()
        {
            
            //不能寄信
            
            let actionSheetController: UIAlertController = UIAlertController(title: "資訊", message: "無法寄信，請設定mail功能！", preferredStyle: .alert)
            
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
                //Do some other stuff
                
            }
            
            actionSheetController.addAction(nextAction)
            
            self.present(actionSheetController, animated: true, completion: nil)
            
            return
            
        }
        
        let emailTitle = "你的新油耗維修資料庫"
        let messageBody = "hi,附件是你備份的新油耗維修資料庫"
        
        let toRecipients = [""]
        
        
        //初始化郵件編輯器並填入郵件內容
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        
        let fileData = try? Data(contentsOf: URL(fileURLWithPath: dst))

        
        let mimeType = "sqlite"
        
        
        
        mailComposer.addAttachmentData(fileData!, mimeType: mimeType, fileName: "OilInfo.sqlite")


        
        
        //將郵件視圖控制器呈現在畫面上
        
        present(mailComposer, animated: true, completion: nil)
        
        
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        
        
        switch result
        {
            
        case MFMailComposeResult.cancelled:
            //print("取消")
            controller.dismiss(animated: true, completion: nil)
            
        case MFMailComposeResult.sent:
            let actionSheetController: UIAlertController = UIAlertController(title: "資訊", message: "信已寄出！", preferredStyle: .alert)
            
            let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
                //Do some other stuff
                
            }
            
            actionSheetController.addAction(nextAction)
            
            //Present the AlertController
            controller.dismiss(animated: true, completion: nil)
            
            self.present(actionSheetController, animated: true, completion: nil)
            
        default:
            controller.dismiss(animated: true, completion: nil)
            break
        }
        
        
        
    }
    

    
    
   
}
