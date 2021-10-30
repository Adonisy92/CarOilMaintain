//
//  oilMainTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/6.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class oilMainTableViewController: myBaseTableViewController,UITextFieldDelegate
{

    @IBOutlet weak var lblFillOilDate: UILabel!
    @IBOutlet weak var lblworkKM: UILabel!
    @IBOutlet weak var lbloilPrice: UILabel!
    @IBOutlet weak var lblfillOil: UILabel!
    @IBOutlet weak var lbltotalPrice: UILabel!
    
    @IBOutlet weak var save_item: UIBarButtonItem!

    
    @IBOutlet weak var back_item: UIBarButtonItem!
    
    
    var PickerFilldate:UIDatePicker = UIDatePicker()

    var tFieldtotalMoney = UITextField() //加油金額
    var tFieldFillDate = UITextField() //加油日期
    var tFieldFillLitre = UITextField() //加油公升
    var tFieldCreditCard = UITextField() //每公升油價

    var tFieldLastKm = UITextField() //上次里程
    var tFieldNowKm = UITextField() //這次里程
    var tFieldWalkKM = UITextField() //行走里程
    

    
    let seg_oiltype = UISegmentedControl() //加油類型
    let seg_oilfill = UISegmentedControl(items: ["加滿","未滿"])

    let seg_creditcard = UISegmentedControl(items: ["現金","信用卡"])
    
    
    var mybutton = UIButton()
    
    var defaultcarid:String = "0"
    var isModified:Bool = false //沒修改
    var fillyear:String = "" //年
    var fillmonth:String = "" //月
    var fillday:String = "" //日
    var filldate:String = "" //日期
    
    var filloilID:String = "" //修改傳過來的 filloilid
    var modifyOilinfo = [String]() //將修改的油耗傳進陣列
    
    //初始
    let myoilinfo = OilInfo()
    
    
    //預設定新增油耗
    var isEditoil:Bool = false
    

   
    override func viewDidAppear(_ animated: Bool)
    {
        
        super.viewDidAppear(true)
        
        
        let mytools = mytool()
        
        
        _ = mytools.read_oil_upload_default() //是否上傳油耗

        

        
        //default car(不要亂改）此為切換車輛時，顯示最近油耗的資訊
        
        defaultcarid = mytools.read_car_default()
        tableView.reloadData()
        
    }

    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {

        let mytools = mytool()
        
        if (mytools.check_have_oil() == 0 || isEditoil) //沒油耗或是修改
        {
            return 1
        }
            else
        {
        
            return 2
        
        }
    }
    
    @objc func emptyoil()
    {
        self.myoilinfo.walkKM = ""
        self.myoilinfo.fillLitre = ""
        self.myoilinfo.fillMoney = ""
        self.myoilinfo.nowKM = ""
        
        self.lblworkKM.text = "公里"
        self.lblfillOil.text = "公升"
        self.lbltotalPrice.text = "元"
        
        self.save_item.isEnabled = false
        
        
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //print(NSHomeDirectory())
        NotificationCenter.default.addObserver(self, selector: #selector(oilMainTableViewController.emptyoil), name: NSNotification.Name(rawValue: "emptyoil"), object: nil)
        
        let mytools = mytool()

        let ioildefault = mytools.read_oil_upload_default()

        if (ioildefault == "1")
        {
            
            //自動上傳油耗
            let mydevice = mytools.getOilDeviceID()
            let myweb = myWebService()
            let car_default = mytools.read_car_default()
            let carinfo = mytools.read_car_info(defaultcarid: car_default)

            if mydevice == "0" //有油耗但是沒有 id,先產生 id
            {
                myweb.reg_oil_user(car_info: carinfo)
            }

            //上傳油耗
            let totalkm = mytools.read_update_oil_info().totalkm
            let totallibre = mytools.read_update_oil_info().totallibre
            
            myweb.upload_oil(deviceid: mydevice, walkkm: totalkm, litre: totallibre)
            //更新 car資訊
            
            myweb.update_oil_user(car_info: carinfo)
           
            
        }

        
        //資料結構檢查

        if (!mytools.check_repairtable())
        {
        //沒有 repairtable
            
            mytools.create_RepaireTabletable()
            mytools.insert_RepaireTable()
        
        }
        //檢查有沒有三筆資料
        
        if !mytools.check_RepaireTable_count()
        {
            
            mytools.insert_RepaireTable()
            
        }
        
        
        if (!mytools.check_oilTypetable())
        {
        
            mytools.create_oilTypeTable()
            mytools.insert_oilTypeTable()
        
        }
        
        //資料重建
        
        //pro版的第一台 carid 是 1,要改成 0
        
        mytools.update_onecarid()
        
        //oilInfoCar1可能沒有 deviceid
        
        if (!mytools.checkcarupdateDeviceid())
        {
            mytools.alterTableDeviceid()
        }


        //升級資料庫
        
        let upgrade = upgrade_DB()
        
    
        
        if !upgrade.check_FillOil_carid()
        {
            //FillOil沒有 carid 欄位表示是2個檔案時期的資料庫
            //加 pk，設定自動編號 （重建時設定pk，並且自動編號，匯入舊資料）
        
            let mytools = mytool()
            mytools.update_onecarid()
            mytools.alterTableDeviceid()
            _ = upgrade.add_car_pk()
            _ = upgrade.copy_OilInfo1_to_OilInfo_car() //把car1的車 copy 到 oilinfo資料庫
              _ = upgrade.add_FillOil_carid() //加一個 carid
            //取出 FillOil的 fillOilID 最大值，假設為 X
            let x = upgrade.return_max_filloilID()
            upgrade.add_FillOil1_x_value(x: x)
            _ = upgrade.copy_FillOil1_to_FillOil_car()
            //取出 MainTainMain 的 MainTainID 最大值，假設為 Y
            let y = upgrade.return_max_maintainID()
            upgrade.add_Maintain_y_value(y: y)
            _ = upgrade.add_maintain_carid()
            _ = upgrade.copy_OilInfo1_to_OilInfo_maintain()
        //parkinfo 加一個carid的欄位
        _ = upgrade.add_parkinfo_carid()
        //將 oilinfocar1 的 parkinfo 匯入 oilinfo 的 parkinfo
        _ = upgrade.copy_OilInfo1_to_OilInfo_parkinfo()
                //nowkm轉換
            let rs = upgrade.return_nowkm_array()
            upgrade.update_oilinfo_lastkm(carid: rs.carid, lastkm: rs.lastkm, nowkm: rs.nowkm)
       //===============檢查結束
            //刪除 oilinfocar1檔案
        mytools.del_exist_oilinfocar1()
        }
        
        
        upgrade.check_error()
        
        

        
        if !isEditoil
        {

            
            //顯示 titleView
        
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
        
            mybutton.setTitle("油耗", for: .normal)
        
            mybutton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        
            //free
            mybutton.isEnabled = false
        
            self.navigationItem.titleView = mybutton
        

            //檢查有無輸入基本資料
        
        
            let mytools = mytool()
        
            let nickname :String = mytools.read_car_nickname()
        
            if nickname == "未命名"
            {
            //跳出警告畫面
                
                let alert = UIAlertController(title: "歡迎光臨", message: "你是第一次使用，建議填寫車籍資料", preferredStyle: .alert)
                
                
                let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
                
                
                alert.addAction(okButton)
                
                self.present(alert, animated: true, completion:nil)

            
            }
                
                back_item.image = nil
                back_item.isEnabled = false
                
        
        }
        else //按下編輯
        {
        
            let mytools = mytool()
            self.defaultcarid = mytools.read_car_default()
            
        
        
        }
        
        //加油日期
        
        PickerFilldate = UIDatePicker(frame: CGRect(x:0.0,y:0.0,width:250,height:150))
        PickerFilldate.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            PickerFilldate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        
        PickerFilldate.addTarget(self, action: #selector(oilMainTableViewController.datePickerValueChanged(_:)), for: .valueChanged)

        
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker)
    {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.tFieldFillDate.text = selectedDate
        
    }


    @objc func pressButton(button: UIButton)
    {
        
        isModified = false //切換車要改
        
        performSegue(withIdentifier: "todefaultcar",
                     sender: self)
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && indexPath.section == 0
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
            
        else if indexPath.row == 0 && indexPath.section == 1
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
            
        else if indexPath.row == 4
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


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 1
        {
            
            return 44.0
            
        }
    
        return 0.0
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let carinfo:[String] = mytools.read_car_info(defaultcarid: defaultcarid)

        let defaultcarNickName = carinfo[1]
        
        
     
        if section == 1
        {
            
            let customView = UIView(frame: CGRect(x: CGFloat(10.0), y: CGFloat(0.0), width: CGFloat(300.0), height: CGFloat(44.0)))
            
            let oilImage = UIImage(named: "uploadoilinfo.png")

            let imageView = UIImageView(frame: CGRect(x: 26, y: 5, width: 35, height: 35))
            
            imageView.image = oilImage

            let headerLabel = UILabel(frame: CGRect.zero)
            headerLabel.backgroundColor = UIColor.clear
            headerLabel.isOpaque = false
            headerLabel.textColor = UIColor.white
            headerLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(18))
            headerLabel.frame = CGRect(x: CGFloat(100.0), y: CGFloat(0.0), width: CGFloat(300.0), height: CGFloat(44.0))

            headerLabel.text = "\(defaultcarNickName)最近油耗資訊"

            
            customView.addSubview(imageView)
            customView.addSubview(headerLabel)
            
            return customView

            
            
        }
        
       return nil
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        
        if !isModified && !isEditoil//沒改再取預設
        {
        
            let mytools = mytool()
        
            let defaultcarid = mytools.read_car_default()
        
            let carinfo:[String] = mytools.read_car_info(defaultcarid: defaultcarid)
        
            mybutton.setTitle("\(carinfo[1])油耗", for: .normal)
        
            myoilinfo.reload_info()
        
            lblworkKM.text = "公里"
            lbloilPrice.text = "\(myoilinfo.oilPrice)元"
            lblfillOil.text = "\(myoilinfo.fillLitre)公升"
            lbltotalPrice.text = "\(myoilinfo.fillMoney)元"
            //抽取年月日
  
            filldate = myoilinfo.fillDate
            fillyear = filldate.substring(to: 4)
            fillmonth = filldate.substring(with: 5..<7)
            fillday = filldate.substring(from: 8)
            lblFillOilDate.text = "\(self.fillyear)年\(fillmonth)月\(fillday)日"

        }
        else if isEditoil
        {
        //此為修改
            
//            read_oil_by_fillid
            navigationItem.title = "油耗修改"
            
            let mytools = mytool()
            let newcarid = mytools.read_car_default()
            
            if newcarid != defaultcarid
            {
                self.navigationController?.popViewController(animated: true)
                
                return
                
            }

            
            let myus = mytool()
            
            modifyOilinfo = myus.read_oil_by_fillid(fillid: self.filloilID)
            
            myoilinfo.walkKM = modifyOilinfo[4]
            myoilinfo.oilPrice = modifyOilinfo[1]
            
            
            myoilinfo.fillLitre = modifyOilinfo[3]
            
            
            
            
            myoilinfo.fillMoney = modifyOilinfo[2]
            myoilinfo.fillDate = modifyOilinfo[0]
            myoilinfo.oilType = modifyOilinfo[7]
            myoilinfo.payType = modifyOilinfo[6]
            myoilinfo.fillOil = modifyOilinfo[5]
            
            let nowwork_km = modifyOilinfo[4]
            let flonowwork_km:Float = Float(nowwork_km) ?? 0
            let string_flonow = String(format:"%.2f",flonowwork_km)

            
            lblworkKM.text = "\(string_flonow)公里"
            
            
            lbloilPrice.text = "\(modifyOilinfo[1])元"
            
            
            
            //加油公升
                        
            let nowfillLitre = modifyOilinfo[3]
            let flonowfillLitre:Float = Float(nowfillLitre) ?? 0
            let string_flonowLitre = String(format:"%.2f",flonowfillLitre)
            lblfillOil.text = "\(string_flonowLitre)公升"

            
            
            
            
            lbltotalPrice.text = "\(modifyOilinfo[2])元"
            //抽取年月日
            
            filldate = modifyOilinfo[0]
            fillyear = filldate.substring(to: 4)
            fillmonth = filldate.substring(with: 5..<7)
            fillday = filldate.substring(from: 8)
            lblFillOilDate.text = "\(self.fillyear)年\(fillmonth)月\(fillday)日"

            self.isModified = true
            self.show_rightbutton()
        
        
        }
        
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:

            if indexPath.section == 0
            {
                //行走里程
                //先判斷該車是用行走里程還是總里程來算
            
                let mytools = mytool()
                if mytools.return_oil_option() == 0 || isEditoil //(修改油耗)
                {
                    let alert = UIAlertController(title:"", message: "輸入可以歸零的里程數", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: self.configurationTextFieldWalkKM(_:))
                
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                    //按下確定
                    
                    //檢查
                    var tmp_walkkm = CFloat(self.tFieldWalkKM.text!)
                    
                    if tmp_walkkm == nil
                    {
                        
                        tmp_walkkm = 0
                        
                    }

                    let tmpwalkkm = String(format: "%.1f", tmp_walkkm!)
                    
                    self.myoilinfo.walkKM = tmpwalkkm
                    self.lblworkKM.text = "\(self.myoilinfo.walkKM)公里"
                    self.isModified = true
                   
                    self.show_rightbutton()
                    
                    
                }))

                    self.present(alert, animated: true, completion:nil)
                    return

                

                    //顯示一個 textbox
                }
                else
                {
                
                    let alert = UIAlertController(title:"", message: "輸入不能歸零的總里程\n第一欄油耗開始計算時的總里程\n第二欄加油時的總里程", preferredStyle: .alert)
                
                    alert.addTextField(configurationHandler: self.configurationTextFieldLastKM(_:))

                    alert.addTextField(configurationHandler: self.configurationTextFieldNowKM(_:))

                    tFieldNowKm.becomeFirstResponder()
                
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                        //按下確定
                    
                        //檢查

                        var tmp_lastkm = CFloat(self.tFieldLastKm.text!)
                        var tmp_nowkm = CFloat(self.tFieldNowKm.text!)

                    
                        if tmp_lastkm == nil
                        {
                        
                            tmp_lastkm = 0
                        
                        }
                    
                        if (tmp_nowkm == nil)
                        {
                    
                            tmp_nowkm = 0
                    
                    
                        }
                    
                        let tmplastkm = String(format: "%.1f", tmp_lastkm!)
                        let tmpnowkm = String(format: "%.1f", tmp_nowkm!)

                        let tmpwalkkm = Float(tmpnowkm)! - Float(tmplastkm)!
                    
                        if tmpwalkkm < 0
                        {
                    
                            self.myoilinfo.nowKM = tmplastkm
                            self.lblworkKM.text = "0公里"
                            self.myoilinfo.walkKM = "0.0"
                            self.isModified = true
                            self.show_rightbutton()

                            return
                        
                    
                        }
                    
                    
                        self.myoilinfo.nowKM = tmpnowkm
                        self.myoilinfo.walkKM = "\(String(format:"%.1f",tmpwalkkm))"
                        self.lblworkKM.text = "\(String(format:"%.1f",tmpwalkkm))公里"
                        self.isModified = true
                        self.show_rightbutton()
                    }))
                
                    self.present(alert, animated: true, completion:nil)
                    return
                }
            }
            else
            {
                //第二個 section
            
                performSegue(withIdentifier: "oildetailform",
                             sender: self)

            
            
            }
            
        case 1:
            //公升油價與現金信用
            self.seg_creditcard.frame = CGRect(x:10,y:70,width:250,height:40)
            self.seg_creditcard.selectedSegmentIndex = Int(myoilinfo.payType)!
            //self.seg_creditcard.backgroundColor = UIColor.white
            

            let attributes = [NSAttributedString.Key.font:  UIFont(name: "American Typewriter", size: 17.0)!,NSAttributedString.Key.foregroundColor: UIColor.black]

            
            UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .normal)


            
            
            
            let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "輸入每公升油價", preferredStyle: .alert)
            
            
            alert.view.addSubview(self.seg_creditcard)
            
            alert.addTextField(configurationHandler: self.configurationTextFieldCreditCard)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //按下確定
                
                if self.tFieldCreditCard.text != ""
                {
                //公升油價
                    
                    var tmp_oilprice = CFloat(self.tFieldCreditCard.text!)
                    if tmp_oilprice == nil
                    {
                    
                        tmp_oilprice = 30
                    
                    }
                
                    let tmpoilprice = String(format: "%.2f", tmp_oilprice!)
                    
                    self.myoilinfo.oilPrice = tmpoilprice
                    self.lbloilPrice.text = "\(self.myoilinfo.oilPrice)元"
                    self.isModified = true
                    self.myoilinfo.payType = String(self.seg_creditcard.selectedSegmentIndex)
                    self.show_rightbutton()
                    
                    if self.tFieldFillLitre.text != ""
                    {
                        var tmp_litre = CFloat(self.tFieldFillLitre.text!)
                        
                        if tmp_litre == nil
                        {
                            
                            tmp_litre = 0.0
                            
                        }
                    
                        let tmp_total = tmp_litre! * tmp_oilprice!

                        let tmptotal = String(format: "%.f", tmp_total)

                        self.myoilinfo.fillMoney = tmptotal
                        
                        self.lbltotalPrice.text = self.myoilinfo.fillMoney + "元"
                    
                        self.show_rightbutton()

                    
                    
                    
                    }
                    
                }//最外圈
                

                
                
                
                
            }))
            self.present(alert, animated: true, completion:nil)
            return
            
        case 2:
            //加油公升 （92、95） 還有加滿，未滿
            //先取加油種類
            let mytools = mytool()
            let oiltype = mytools.read_oil_type()
            
            self.seg_oiltype.frame = CGRect(x:10,y:20,width:250,height:40)
            self.seg_oiltype.removeAllSegments()
            
            var i:Int = 0
            for element in oiltype
            {
                
                self.seg_oiltype.insertSegment(withTitle: element , at: i, animated: false)
                i+=1

            }
            
            seg_oiltype.selectedSegmentIndex = Int(self.myoilinfo.oilType)!
            
            self.seg_oilfill.frame = CGRect(x:10,y:70,width:250,height:40)
            
            self.seg_oilfill.selectedSegmentIndex = Int(myoilinfo.fillOil)!
            
            let attributes = [NSAttributedString.Key.font:  UIFont(name: "American Typewriter", size: 17.0)!,NSAttributedString.Key.foregroundColor: UIColor.black]

            
            UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .normal)

            
            let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "輸入加油公升", preferredStyle: .alert)
            

            alert.view.addSubview(self.seg_oiltype)
            alert.view.addSubview(self.seg_oilfill)

            alert.addTextField(configurationHandler: self.configurationTextFieldFillLitre)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //按下確定

                if self.tFieldFillLitre.text != ""
                {
                
                    //需求檢查
                    var tmp_litre = CFloat(self.tFieldFillLitre.text!)
                    
                    if tmp_litre == nil
                    {
                    
                        tmp_litre = 0.0
                    
                    }
                    
                    
                    
                    let tmplitre = String(format: "%.2f", tmp_litre!)
                    
                    let tmp_oilprice = CFloat(self.myoilinfo.oilPrice)
                    
                    
                    self.myoilinfo.fillLitre = tmplitre
                    self.lblfillOil.text = "\(self.myoilinfo.fillLitre)公升"
                    self.isModified = true
                    self.myoilinfo.oilType = String(self.seg_oiltype.selectedSegmentIndex)
                    self.myoilinfo.fillOil = String(self.seg_oilfill.selectedSegmentIndex)
                    
                    
                    let tmp_total = tmp_litre! * tmp_oilprice!
                    
                    let tmptotal = String(format: "%.f", tmp_total)
                    
                    self.myoilinfo.fillMoney = tmptotal
                    
                    self.lbltotalPrice.text = "\(self.myoilinfo.fillMoney)元"

                    self.show_rightbutton()

                
                }
                
                
                
            }))
            self.present(alert, animated: true, completion:nil)
            return
        case 3:
            //加油金額
            //維修 menu
            //加入一個連動功能
            //公升有輸入則不連動
            
            let alert = UIAlertController(title:"", message: "輸入加油金額", preferredStyle: .alert)
            
            
            
            alert.addTextField(configurationHandler: self.configurationTextFieldtotalMoney)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //按下確定
                
                
                self.myoilinfo.fillMoney = self.tFieldtotalMoney.text!
                self.lbltotalPrice.text = "\(self.myoilinfo.fillMoney)元"
                
                if (self.myoilinfo.fillLitre == "")
                {
                    //沒輸入
                    
                    //換算回公升
                    
                    var tmp_oilprice = CFloat(self.myoilinfo.oilPrice)
                    if tmp_oilprice == nil
                    {
                        
                        tmp_oilprice = 30
                        
                        self.myoilinfo.oilPrice = "30"
                        self.lbloilPrice.text = "30元"
                        
                    }
                    
                    var tmp_fillmoney = CFloat(self.myoilinfo.fillMoney)
                    
                    if tmp_fillmoney == nil
                    {
                        
                        tmp_fillmoney = 0
                        
                        
                        
                    }
                    
                    let tmp_fillLitre = tmp_fillmoney! / tmp_oilprice!
                    
                    let tmpfillLitre = String(format: "%.2f", tmp_fillLitre)
                    
                    self.myoilinfo.fillLitre = tmpfillLitre
                    
                    self.lblfillOil.text = "\(tmpfillLitre)公升"

                
                
                
                }
                
                
                
                
                self.isModified = true
                self.show_rightbutton()

                
            }))
            self.present(alert, animated: true, completion:nil)

            
            
            return
        case 4:
            //加油日期
            
            let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "選擇加油日期", preferredStyle: .alert)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd"
            let date = dateFormatter.date(from: myoilinfo.fillDate)
            
            
            self.PickerFilldate.date = date!
            
            alert.view.addSubview(self.PickerFilldate)

            alert.addTextField(configurationHandler: self.configurationTextFieldFillDate)
            
            
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //print("Done !!")
                //按下確定
                
                   self.myoilinfo.fillDate = self.tFieldFillDate.text!
                //抽取年月日
                
                self.filldate = self.myoilinfo.fillDate
                self.fillyear = self.filldate.substring(to: 4)
                self.fillmonth = self.filldate.substring(with: 5..<7)
                self.fillday = self.filldate.substring(from: 8)
                self.lblFillOilDate.text = "\(self.fillyear)年\(self.fillmonth)月\(self.fillday)日"
                self.isModified = true
                self.show_rightbutton()

                
                
                
            }))
            self.present(alert, animated: true, completion:nil)
            return
        
        default:
            return
            
            
        }
    }
    
    func configurationTextFieldtotalMoney(_ textField: UITextField!)
    {
        tFieldtotalMoney = textField
        tFieldtotalMoney.clearButtonMode = .whileEditing
        tFieldtotalMoney.keyboardType = .numberPad
        tFieldtotalMoney.text = myoilinfo.fillMoney
        tFieldtotalMoney.delegate = self
        
    }
        
        
        
      
        
    func configurationTextFieldFillDate(_ textField: UITextField!)
    {
        tFieldFillDate = textField
        tFieldFillDate.isUserInteractionEnabled = false
        tFieldFillDate.text = myoilinfo.fillDate
        tFieldFillDate.delegate = self
            
    }
    
    func configurationTextFieldFillLitre(_ textField: UITextField!)
    {
        tFieldFillLitre = textField
        tFieldFillLitre.clearButtonMode = .whileEditing
        tFieldFillLitre.keyboardType = .decimalPad
        
        if isEditoil
        {

            let nowfillLitre = myoilinfo.fillLitre
            let flonowfillLitre:Float = Float(nowfillLitre) ?? 0
            let string_flonowLitre = String(format:"%.2f",flonowfillLitre)

            lblfillOil.text = "\(string_flonowLitre)公升"
            tFieldFillLitre.text = string_flonowLitre


        }
        else
        {
            lblfillOil.text = "\(myoilinfo.fillLitre)公升"
            tFieldFillLitre.text = myoilinfo.fillLitre


        }

        tFieldFillLitre.delegate = self
        
        
    }
    
    func configurationTextFieldCreditCard(_ textField: UITextField!)
    {
        tFieldCreditCard = textField
        tFieldCreditCard.clearButtonMode = .whileEditing
        tFieldCreditCard.keyboardType = .decimalPad
        tFieldCreditCard.text = myoilinfo.oilPrice
        tFieldCreditCard.delegate = self
        
    }
    
    
    func configurationTextFieldLastKM(_ textField: UITextField!)
    {
        tFieldLastKm = textField
        tFieldLastKm.isUserInteractionEnabled = false
        tFieldLastKm.text = myoilinfo.lastKm
        tFieldLastKm.delegate = self

        
    }

    
    func configurationTextFieldNowKM(_ textField: UITextField!)
    {
        tFieldNowKm = textField
        tFieldNowKm.clearButtonMode = .whileEditing
        tFieldNowKm.keyboardType = .decimalPad
        tFieldNowKm.text = myoilinfo.nowKM
        tFieldNowKm.delegate = self
        
    }

    
    func configurationTextFieldWalkKM(_ textField: UITextField!)
    {
        tFieldWalkKM = textField
        tFieldWalkKM.clearButtonMode = .whileEditing
        tFieldWalkKM.keyboardType = .decimalPad
        if isEditoil
        {
            let nowwork_km = myoilinfo.walkKM
            let flonowwork_km:Float = Float(nowwork_km) ?? 0
            let string_flonow = String(format:"%.2f",flonowwork_km)

            tFieldWalkKM.text = string_flonow
        }
        else
        {
            tFieldWalkKM.text = myoilinfo.walkKM
        }
        tFieldWalkKM.delegate = self
        
    }

    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == tFieldNowKm
        {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 8 // Bool
        }
        else
        {
        
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 6 // Bool
        
        }

      
    }

    
    @IBAction func save_oil(sender: UIBarButtonItem)
    {
        
        if !isEditoil //新增
        {
        myoilinfo.insert_oil(fillDate_i: myoilinfo.fillDate, oilPrice_i: myoilinfo.oilPrice, FillMoney_i: myoilinfo.fillMoney, FillLitre_i: myoilinfo.fillLitre, workKM_i: myoilinfo.walkKM, filloil_i: myoilinfo.fillOil, payType_i: myoilinfo.payType, oilType_i: myoilinfo.oilType)
            
            
            //上傳油耗資訊檢查
            
            let mytools = mytool()
            let oil_upload = mytools.read_oil_upload_default()
            if (oil_upload == "1")
            {
                let mydevice = mytools.getOilDeviceID()
                let myweb = myWebService()
                let car_default = mytools.read_car_default()
                let carinfo = mytools.read_car_info(defaultcarid: car_default)

                if mydevice == "0" //有油耗但是沒有 id,先產生 id
                {
                    
                    myweb.reg_oil_user(car_info: carinfo)
                }

                //上傳油耗
                let totalkm = mytools.read_update_oil_info().totalkm
                let totallibre = mytools.read_update_oil_info().totallibre
                
                myweb.upload_oil(deviceid: mydevice, walkkm: totalkm, litre: totallibre)
                //更新 car資訊
                
                myweb.update_oil_user(car_info: carinfo)
                
                
                

            }

            
            

        let alert = UIAlertController(title: "訊息", message: "油耗新增完成！", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion:nil)


        self.lblworkKM.text = "公里"
        self.lblfillOil.text = "公升"
        self.lbltotalPrice.text = "元"
        
        myoilinfo.walkKM = ""
        myoilinfo.fillLitre = ""
        myoilinfo.fillMoney = ""
        myoilinfo.nowKM = ""
        
        //更新最新的 lastkm
        myoilinfo.lastKm = myoilinfo.readLastKMinfoFromDB()

        
        isModified = false
        show_rightbutton()
        
        tableView.reloadData()
        }
        else
        {
        //修改
        
            myoilinfo.update_oil(fillDate_i: myoilinfo.fillDate, oilPrice_i: myoilinfo.oilPrice, FillMoney_i: myoilinfo.fillMoney, FillLitre_i: myoilinfo.fillLitre, workKM_i: myoilinfo.walkKM, filloil_i: myoilinfo.fillOil, payType_i: myoilinfo.payType, oilType_i: myoilinfo.oilType,filloilID: filloilID)
            
            
            let alert = UIAlertController(title: "訊息", message: "油耗修改完成！", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
              
                self.navigationController?.popToRootViewController(animated: true)
                
                
            }))
            
            
            
            self.present(alert, animated: true, completion:nil)
            
            
 

            
        
        
        }
        
        
    }

    func show_rightbutton()
    {

        if self.myoilinfo.check_fill_alldata()
        {
            //顯示右上角的儲存
            
            self.save_item.isEnabled = true
            
            
        }
        else
        {
            
            self.save_item.isEnabled = false
            
        }

    }
    
    
    @IBAction func back_item_clickme(_ sender: UIBarButtonItem)
    {
        
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    
    
    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    
    
    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: true)

        
    }

    
    
}



extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
