//
//  input_main_TableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class input_main_TableViewController: myBaseTableViewController,UITextFieldDelegate
{
    var addOrModified:String = "add" //預設是新增
    var smgindex:Int = 0 //預設選到全部
    var maintain_menu = [String]() //選單
    let mytools = mytool()
    var totalKm:String = ""
    var tFieldtotalkm:UITextField!
    var tFieldFillDate:UITextField!
    var input_Maintain_id:String = "0"
    
    var maintainornot:String = "1"
    var input_date:String = ""
    var Pickerdate:UIDatePicker = UIDatePicker()

    
    @IBOutlet weak var save_item: UIBarButtonItem!
    @IBOutlet weak var lbltotalkm: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var segcontrol: UISegmentedControl!
    
    @IBAction func save_me(_ sender: Any)
    {
        if addOrModified == "add"
        {
        
        mytools.insert_maintain_main(maintainkm: totalKm, maintainDate: input_date, maintainornot: maintainornot)

        }
        else
        
        {
            
            let ms = maintain()
            _ = ms.update_maintain_main(MaintainID: input_Maintain_id, Maintainkm: totalKm, Maintaindate: input_date, maintainornot: maintainornot)

            NotificationCenter.default.post(name: Notification.Name(rawValue: "setisEdited"), object: nil)


        
        }
        self.navigationController?.popViewController(animated: true)

        
        
    }
    
    @IBAction func click_me(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let attributes = [NSAttributedString.Key.font:  UIFont(name: "American Typewriter", size: 17.0)!,NSAttributedString.Key.foregroundColor: UIColor.white]

        
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .normal)

        
    }

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if addOrModified == "add"
        {
            navigationItem.title = "主單新增"
            switch smgindex
            {
            case 0:
                maintainornot = "1"
            case 1:
                maintainornot = "1"
            case 2:
                maintainornot = "0"
            case 3:
                maintainornot = "3"
            default:
                break
                
            }
            
            let mytools = mytool()
            
            let tmp_totalkm:Float = Float(mytools.read_total_lastkm())!
            
            totalKm = String(format: "%.0f", tmp_totalkm)

            
            self.lbltotalkm.text = "\(totalKm)公里"

            save_item.isEnabled = true

            
        }
        else
        {
        
            navigationItem.title = "主單修改"
            //讀主單資訊
            let rs = mytools.read_maintain_main(maintain_id: input_Maintain_id)
            
            self.lblDate.text = rs.inputdate
            input_date = rs.inputdate
            totalKm = rs.totalkm
            self.lbltotalkm.text = "\(totalKm)公里"

            if rs.segindex == "0" //配件
            {
                maintainornot = "0"
                smgindex = 2
            }
            if rs.segindex == "1" //保養
            {
                maintainornot = "1"
                smgindex = 1
            }
            if rs.segindex == "3"
            {
                //停車
                maintainornot = "3"
                smgindex = 3
            }
            
            save_item.isEnabled = true

            
        
        }

        //save_item.image = UIImage(named: "save7575")
        
        
        
        maintain_menu = mytools.read_maintain_menu()
        segcontrol.removeAllSegments()
        
        for i in 0...2
        {
            segcontrol.insertSegment(withTitle: maintain_menu[i], at: i, animated: false)
        }
    
        if smgindex == 0
        {
            segcontrol.selectedSegmentIndex = 0
        }

        else
        {
            segcontrol.selectedSegmentIndex = smgindex - 1
        }
        
        segcontrol.addTarget(self, action: #selector(changetap(_:)), for: .valueChanged)
        
        //取今天
        
        Pickerdate = UIDatePicker(frame: CGRect(x:0.0,y:0.0,width:250,height:150))
        Pickerdate.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            Pickerdate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        
        Pickerdate.addTarget(self, action: #selector(input_main_TableViewController.datePickerValueChanged(_:)), for: .valueChanged)

        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.string(from: Date())

        if addOrModified != "edit"
        {
            lblDate.text = dateObj
            input_date = dateObj
            lbltotalkm.text = "\(totalKm)公里"
        }
        
        
    }

    @objc func changetap(_ segControl: UISegmentedControl)
    {
    
    
        smgindex = segcontrol.selectedSegmentIndex
        switch smgindex
        {
        case 0:
            maintainornot = "1"
        case 1:
            maintainornot = "0"
        case 2:
            maintainornot = "3"
        default:
            break
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
            
        else if indexPath.row == 2
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            //總里程
            let alert = UIAlertController(title:"", message: "輸入總里程數", preferredStyle: .alert)
            
            
            alert.addTextField(configurationHandler: self.configurationTextFieldtotalkm)
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //按下確定
                
                self.totalKm = self.tFieldtotalkm.text!
                
                self.lbltotalkm.text = "\(self.tFieldtotalkm.text ?? "")公里"
                
                if self.tFieldtotalkm.text != ""
                {
                
                    self.save_item.isEnabled = true
                
                }
                else
                {
                
                    self.save_item.isEnabled = false
                    
                }
                
                
            }))
            self.present(alert, animated: true, completion:nil)

            
        }

        if indexPath.row == 1
        {
            //日期
            
            let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "選擇日期", preferredStyle: .alert)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd"
            let date = dateFormatter.date(from: input_date)
            
            self.Pickerdate.date = date!
            
            alert.view.addSubview(self.Pickerdate)
            
            alert.addTextField(configurationHandler: self.configurationTextFieldDate)
            
            
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //print("Done !!")
                //按下確定
                self.input_date = self.tFieldFillDate.text!
                
                
                
            }))
            self.present(alert, animated: true, completion:nil)

            
        }
        
    }
    
    
    func configurationTextFieldtotalkm(_ textField: UITextField!)
    {
        tFieldtotalkm = textField
        tFieldtotalkm.clearButtonMode = .whileEditing
        tFieldtotalkm.keyboardType = .numberPad
        tFieldtotalkm.text = totalKm
        tFieldtotalkm.delegate = self
        
    }

    func configurationTextFieldDate(_ textField: UITextField!)
    {
        tFieldFillDate = textField
        tFieldFillDate.isUserInteractionEnabled = false
        tFieldFillDate.text = input_date
        tFieldFillDate.delegate = self
        
    }

    
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 7 // Bool
        
        
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
        input_date = selectedDate
        lblDate.text = selectedDate
        
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
