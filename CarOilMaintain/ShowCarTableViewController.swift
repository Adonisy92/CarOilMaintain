//
//  ShowCarTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/22.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class ShowCarTableViewController: myBaseTableViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    
    
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblCarStyle: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    
    @IBOutlet weak var lblBirthday: UILabel!
    
    @IBOutlet weak var showview: UIView!
    
    @IBOutlet var myTableView: UITableView!
    
    var defaultcarid:String = "0"
    
    var tField: UITextField!
    var tField2: UITextField!
    var txtNickName:String = ""

    var inputType:String = "1" //輸入的項目
    
    //車廠與車型
    
    var PickerCarCompany:UIPickerView = UIPickerView()
    
    //var PickerCarCompanyStyle:UIPickerView = UIPickerView()
    
    var carCompanyArray = [String]()
    var carCompanyId = [String]()
    var carStyle_r = [String]()
    var intCompanyIndex:Int! = 0
    var intCompanyStyleIndex:Int! = 0
    
    

    var carCompany:String=""
    var carStyle:String=""

    //車種
    
    var PickerCarStyle: UIPickerView = UIPickerView()
    var cartype:[String] = ["汽油車", "柴油車" , "油電車", "摩托車"]
    var intCartype:Int = 0//預設汽油車

    //顏色
    
    var PickerCarColor: UIPickerView = UIPickerView()
    var colortype:[String] = ["紅", "藍" , "黃", "銀","灰","綠","黑","白","紫","金"]
    var defaultcarColor:String = "紅" //預設顏色
    var intColorIndex:Int! = 0
    
    //生日

    var PickerBirthday:UIDatePicker = UIDatePicker()
    
    

    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //加入監聽
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShowCarTableViewController.clearcell), name: NSNotification.Name(rawValue: "clearcell"), object: nil)

        
        //self.tableView.isScrollEnabled = true
        
        
       
        //pickview
        
        PickerCarStyle = UIPickerView(frame: CGRect(x:0.0, y:0.0, width:250, height:150))
        PickerCarStyle.delegate =  self;
        PickerCarStyle.dataSource = self;
       // PickerCarStyle.showsSelectionIndicator = true
        PickerCarStyle.tintColor =  UIColor.red
        
        
        PickerCarColor = UIPickerView(frame: CGRect(x:0.0, y:0.0, width:250, height:150))
        PickerCarColor.delegate =  self;
        PickerCarColor.dataSource = self;
        //PickerCarColor.showsSelectionIndicator = true
        PickerCarColor.tintColor =  UIColor.red
        
        PickerBirthday = UIDatePicker(frame: CGRect(x:0.0,y:0.0,width:250,height:150))
        PickerBirthday.datePickerMode = .date
 
        if #available(iOS 13.4, *) {
            PickerBirthday.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        
        
        PickerBirthday.addTarget(self, action: #selector(ShowCarTableViewController.datePickerValueChanged(_:)), for: .valueChanged)
        
        
        PickerCarCompany = UIPickerView(frame: CGRect(x:0.0, y:0.0, width:250, height:150))
        PickerCarCompany.delegate =  self;
        PickerCarCompany.dataSource = self;
        //PickerCarCompany.showsSelectionIndicator = true
        PickerCarCompany.tintColor =  UIColor.red
        
        
       
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker)
    {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.tField.text = selectedDate
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        
        if pickerView == PickerCarCompany
        {
            return 2
        }
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == PickerCarStyle
        {
            return 4
        }
        
        if pickerView == PickerCarColor
        {
        
            return colortype.count
        
        }
        
        if pickerView == PickerCarCompany && component == 0
        {
        
            return carCompanyArray.count
        }

        if pickerView == PickerCarCompany && component == 1
        {
            
            return carStyle_r.count
        }

        
            return 1
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if pickerView == PickerCarStyle
        {
            return cartype[row] as String
        }
        
        if pickerView == PickerCarColor
        {
            
            return colortype[row] as String
            
        }

        if pickerView == PickerCarCompany && component == 0
        {
            
            return carCompanyArray[row] as String
            
        }

        if pickerView == PickerCarCompany && component == 1
        {
            
            return carStyle_r[row] as String
            
        }


        return "test"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == PickerCarStyle
        {
            
            intCartype = row //將車種填入
            return
            
            
        }
        
        if pickerView == PickerCarColor
        {
            
            self.tField.text = colortype[row]
            //defaultcarColor = colortype[row] //預設顏色修改
            return
            
        }
            
        if pickerView == PickerCarCompany && component == 0
        {
            self.tField2.text = carCompanyArray[row]
            //將 style改變
            let mytools = mytool()

            carStyle_r = mytools.read_car_company_style_info(i_companyid: Int(carCompanyId[row])!)

            PickerCarCompany.reloadComponent(1)
            PickerCarCompany.selectRow(0, inComponent: 1, animated: true)
            self.tField.text = carStyle_r[0]
            
            return
        }

        if pickerView == PickerCarCompany && component == 1
        {
            self.tField.text = carStyle_r[row]
            return
        }

        
        return
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 36.0
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
        else if indexPath.row == 3
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
        return 5
    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        switch indexPath.row
        {
        case 0://nickname
            
            inputType = "1"
            
            //需再抓一次車種
            
            let mytools = mytool()
            var carinfo  = [String]()
            carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
            
            intCartype = Int(carinfo[11])!

            
            
            
            displayAlert("\n\n\n\n\n\n\n", input_type: inputType,messagecontent:"請取一個簡短有力暱稱來描述你的愛車")
            
        case 1://車廠型號
            
            //重抓車廠型號
            
            
            let mytools = mytool()
            let mycar =  mytools.read_car_company_info()
            
            carCompanyArray = mycar.carCompany_r
            carCompanyId = mycar.carId_r
            
            let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
            
            carCompany = carinfo[2]
            carStyle = carinfo[3]

           
            
            
            //和自已的車做比對            //要寫預設值
            

            self.intCompanyIndex = self.carCompanyArray.firstIndex(of: self.carCompany)
            if self.intCompanyIndex == nil
            {
                
                intCompanyIndex = 0
                
            }

            
            carStyle_r = mytools.read_car_company_style_info(i_companyid: Int(carCompanyId[intCompanyIndex])!)
            
            
            self.intCompanyStyleIndex = self.carStyle_r.firstIndex(of: self.carStyle)
            if self.intCompanyStyleIndex == nil
            {
                
                intCompanyStyleIndex = 0
                
            }

            //比對完成
            
            
            inputType = "2"
            displayAlert("\n\n\n\n\n\n", input_type: inputType,messagecontent:"選擇車廠型號或自行輸入")
            
            
        case 2://顏色
            
            inputType = "3"

            displayAlert("\n\n\n\n\n\n", input_type: inputType,messagecontent:"選擇顏色或自行輸入")
            
            
        case 3://愛車生日
            
            inputType = "4"
            displayAlert("\n\n\n\n\n\n\n", input_type: inputType,messagecontent:"選擇愛車生日")

            
        default:
            
            return
        }
        
        
    }

    func displayAlert(_ title_i:String,input_type:String,messagecontent:String)
    {
        
        
        let alert = UIAlertController(title:title_i, message: messagecontent, preferredStyle: .alert)
        alert.preferredContentSize = CGSize(width: 450, height: 450)

        

        if inputType == "1"
        {
            
            PickerCarStyle.selectRow(intCartype, inComponent: 0, animated: true)

        
            alert.view.addSubview(self.PickerCarStyle)

            
        }
        
        if input_type == "2"
        {
            
            //避免閃退
            PickerCarCompany.reloadAllComponents()
            
            
            PickerCarCompany.selectRow(self.intCompanyIndex, inComponent: 0, animated: false)
            PickerCarCompany.selectRow(self.intCompanyStyleIndex, inComponent: 1, animated: false)
            
            alert.view.addSubview(self.PickerCarCompany)

            
            //車廠
            alert.addTextField(configurationHandler: self.configurationTextField2)

            
            
        }
        
        if inputType == "3" //顏色
        {
         
            self.intColorIndex = self.colortype.firstIndex(of: self.defaultcarColor)
            if self.intColorIndex == nil
            {
                self.colortype.append(self.defaultcarColor)//將自訂顏色加入陣列
                self.intColorIndex = self.colortype.count - 1

            }
            
            
            PickerCarColor.selectRow(self.intColorIndex, inComponent: 0, animated: false)
            
            alert.view.addSubview(self.PickerCarColor)

            
        }
        
        if inputType == "4" //生日
        {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd"
            let date = dateFormatter.date(from: self.lblBirthday.text!)

            
            self.PickerBirthday.date = date!
            
            alert.view.addSubview(self.PickerBirthday)
            
        }
        
        
        

        alert.addTextField(configurationHandler: self.configurationTextField)

        
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            //print("Done !!")
            //按下確定
            
            switch self.inputType
            {
            case "1":
                self.lblNickName.text = self.tField.text!
                self.txtNickName = self.tField.text!
                let mytools = mytool()
                mytools.update_car_nickname_type(i_carid: Int(self.defaultcarid)!, i_carNickName: self.txtNickName, i_cartype: self.intCartype)
                
            case "2":
                self.lblCarStyle.text = self.tField2.text! + " " + self.tField.text!
                let mytools = mytool()
                mytools.update_car_company(i_carid: Int(self.defaultcarid)!, i_carCompany: self.tField2.text!, i_carStyle: self.tField.text!)

            case "3"://顏色
                self.lblColor.text = self.tField.text!
                self.defaultcarColor = self.tField.text!
                let mytools = mytool()
                mytools.update_car_color(i_carid: Int(self.defaultcarid)!, i_carColor: self.defaultcarColor)
                //重抓 index值
                self.intColorIndex = self.colortype.firstIndex(of: self.defaultcarColor)
                if self.intColorIndex == nil
                {
                    self.colortype.append(self.defaultcarColor)//將自訂顏色加入陣列
                    
                }
                
            case "4":
                self.lblBirthday.text = self.tField.text!
                let mytools = mytool()
                mytools.update_car_birthday(i_carid: Int(self.defaultcarid)!, i_carBirthday: self.lblBirthday.text!)
                
                
                
            default:
                return
            }
            
            //按下確定就要 update
            //self.save_info()
            

            
            self.tableView.reloadData()
            
            
            
        }))
        self.present(alert, animated: true, completion:nil)
        
        
    }

    
    func configurationTextField(_ textField: UITextField!)
    {
        tField = textField
        tField.clearButtonMode = .whileEditing
        tField.keyboardType = .default
        
        switch inputType
        {
        case "1":
            tField.text = lblNickName.text
            tField.delegate = self
            
        //tField.becomeFirstResponder()
        case "2":
            
            let mytools = mytool()
            let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
            
            tField2.text! = carinfo[2]
            tField.text! = carinfo[3]
            tField.delegate = self
            
        case "3":
            tField.text = lblColor.text
            tField.delegate = self
            
            
        case "4"://生日
            tField.text = lblBirthday.text
            tField.isUserInteractionEnabled = false
            tField.delegate = nil
            
            
        default:
            return
        }
        
        
    }

    
    func configurationTextField2(_ textField: UITextField!)
    {
        tField2 = textField
        tField2.clearButtonMode = .whileEditing
        tField2.keyboardType = .default
        
       
            tField2.text = carCompany
            tField2.delegate = self
            
        
        
    }

    
    @objc func clearcell()
    {
        
        //跳出訊息問要不要建立新車
        //新資料一筆
        
        let mytools = mytool()
        mytools.insert_newcar()
        
        //傳回 defaultid
        
        defaultcarid = mytools.return_new_carid()
        
        //要在carTotalKM中加一筆

        mytools.insert_cartotalKM(defaultid: defaultcarid)
        
        mytools.save_car_default(defaultid: defaultcarid)
        
        //維修資料頁面也要加
        
        _ = mytools.insert_car_repaire_column_by_carid_newcar(defaultid: defaultcarid)
        
        
        
        //清空 cell

        //lblCarStyle.adjustsFontSizeToFitWidth = true
        //lblCarStyle.baselineAdjustment = UIBaselineAdjustment.alignCenters
        
        //lblCarStyle.minimumScaleFactor = 0.5
        

        
        lblNickName.text = "未命名"
        lblCarStyle.text = "未命名 無"
        lblColor.text = "黑"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)

        lblBirthday.text = result
        
        
        tableView.reloadData()
        
        
        return
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let mytools = mytool()
        
        
        //default car
        
        defaultcarid = mytools.read_car_default()
        
        
        var carinfo  = [String]()
        carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
        
        //print(carinfo)
        
        //取出資本資料
        lblNickName.text = carinfo[1]
        lblCarStyle.text = carinfo[2] + " " + carinfo[3]
        carCompany = carinfo[2]
        carStyle = carinfo[3]
        
        lblBirthday.text = carinfo[4]
        lblColor.text = carinfo[5]
        
        intCartype = Int(carinfo[11])!
        defaultcarColor = carinfo[5]
        
        tableView.reloadData()
        
        PickerCarStyle.reloadAllComponents()
        PickerCarColor.reloadAllComponents()
        PickerCarCompany.reloadAllComponents()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if inputType == "1"
        {
        //nickname才要check
        
            guard let text = textField.text else { return true }
        
            let newLength = text.count + string.count - range.length
            return newLength <= 5 // Bool
        }
        else
        {
            
            return true
            
        }
        
        
    }

        
    

}
