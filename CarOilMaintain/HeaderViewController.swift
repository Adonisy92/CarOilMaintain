//
//  HeaderViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/11.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class HeaderViewController: myBaseViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate
{

    
    var nowSegindex:Int = 0
    
    var carProductCategory = [String]()
    var carProductCategoryID = [String]()
    var carProducts = [String]()
    var carProductsID = [String]()
    
    var tFieldCategory = UITextField() //分類名稱
    var tFieldProductName = UITextField() //產品名稱

    var productCategoryID:String = "" //分類編號
    var productid:String = "" //輸入的產品編號
    
    var isSearch:Bool = false //不在搜尋中
    
    var productName:String = "" //搜尋的 productname

    
    var PickerProducts:UIPickerView = UIPickerView()

    
    @IBOutlet weak var lblmain_view: UILabel!

    
    @IBOutlet weak var myseg: UISegmentedControl!
    
    
    @objc func search_me()
    {
        if isSearch
        {

            cancel_Search()

            
            
        }
        else //搜尋
        {
        let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "輸入搜尋的品項", preferredStyle: .alert)
        
        reload_component()
        
        alert.view.addSubview(self.PickerProducts)
        
        
        alert.addTextField(configurationHandler: self.configurationTextFieldCategory(_:))
        alert.addTextField(configurationHandler: self.configurationTextFieldProducts(_:))
        
        
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            //按下確定

            self.isSearch = true
            
            //圖改成swap
            
            self.lblmain_view.frame = CGRect(x: 80, y: 50, width: 180, height: 21)
            self.lblmain_view.text = "搜尋:\(self.productName)"


            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.productid,"seg":self.nowSegindex])

            
            
            
        }))
        
            
        self.present(alert, animated: true, completion:nil)
        
       // UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        if component == 0
        {
            
            return carProductCategoryID.count
            
        }
        
        
        return carProducts.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if component == 0
        {
            return carProductCategory[row]
        }
        
        return carProducts[row]
        
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if component == 0
        {
            
            self.tFieldCategory.text = carProductCategory[row]
            //產品內容改變
            let mytools = mytool()
            
            let rs = mytools.read_product_name(categoryid: carProductCategoryID[row])
            
            carProducts = rs.pname
            carProductsID = rs.pid
            
            if carProducts.count != 0
            {
                self.tFieldProductName.text = carProducts[0]
                self.productName = carProducts[0]
                self.productid = carProductsID[0]
            }
            else
            {
                
                self.tFieldProductName.text = "無產品名稱"
                self.productName = "無產品名稱"
                self.productid = "0"
                
            }
            PickerProducts.reloadComponent(1)
            PickerProducts.selectRow(0, inComponent: 1, animated: true)
            
            return
            
            
        }
            
        else
        {
            
            
            self.tFieldProductName.text = carProducts[row]
            self.productName = carProducts[row]
            self.productid = carProductsID[row]
            
            
            
        }
        
        
        
    }
    
    func configurationTextFieldCategory(_ textField: UITextField!)
    {
        
        tFieldCategory = textField
        tFieldCategory.isUserInteractionEnabled = false
        tFieldCategory.text = carProductCategory[0]
        tFieldCategory.delegate = self
        
        self.productCategoryID = carProductCategoryID[0]
        
        
    }
    
    
    func configurationTextFieldProducts(_ textField: UITextField!)
    {
        
        tFieldProductName = textField
        tFieldProductName.isUserInteractionEnabled = false
        tFieldProductName.text = carProducts[0]
        tFieldProductName.delegate = self

        productName = carProducts[0]

        
        self.productid = carProductsID[0]
        
    }


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let frame = UIScreen.main.bounds
        myseg.frame = CGRect(x:0, y:0,
                             width:frame.width, height:40)
   
        

        myseg.addTarget(self, action: #selector(changetap(_:)), for: .valueChanged)
        
        stylizeFonts()
        
        

        NotificationCenter.default.addObserver(self, selector: #selector(HeaderViewController.changeseg), name: NSNotification.Name(rawValue: "changeseg"), object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(HeaderViewController.cancel_Search), name: NSNotification.Name(rawValue: "changejpg"), object:nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(HeaderViewController.lbl_changetext(notification:)), name: NSNotification.Name(rawValue: "lblchangetext"), object:nil)

        //search_me
        

        NotificationCenter.default.addObserver(self, selector: #selector(HeaderViewController.search_me), name: NSNotification.Name(rawValue: "search_me"), object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(HeaderViewController.cancel_Search), name: NSNotification.Name(rawValue: "cancel_Search"), object:nil)

        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func changetap(_ segControl: UISegmentedControl)
    {
        
        switch segControl.selectedSegmentIndex
        {
            
        case 0:
            nowSegindex = 0
            if isSearch
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.productid,"seg":self.nowSegindex])

            }
            else
            {

            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self,userInfo: ["name": nowSegindex])
            }
            break
        case 1:
            nowSegindex = 1
            //cancel_Search()
            if isSearch
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.productid,"seg":self.nowSegindex])
                
            }
            else
            {

            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self,userInfo: ["name": nowSegindex])
            
            }
            
            break
            
        case 2:
            
            nowSegindex = 2
            //cancel_Search()
            if isSearch
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.productid,"seg":self.nowSegindex])
                
            }
            else
            {

            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self,userInfo: ["name": nowSegindex])
            }
            
            break
            
        case 3:
            nowSegindex = 3
            //cancel_Search()

            if isSearch
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.productid,"seg":self.nowSegindex])
                
            }
            else
            {

            NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self,userInfo: ["name": nowSegindex])
            }
            break
        default:
            break
        }
        
    }
    
    func stylizeFonts()
    {
        
        
        
        let attributes = [NSAttributedString.Key.font:  UIFont(name: "American Typewriter", size: 17.0)!,NSAttributedString.Key.foregroundColor: UIColor.white]

        
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .normal)

        
        
    }
    
    func reloadSegitem()
    {
        myseg.removeAllSegments()
        
        
        let mytools = mytool()
        
        let items = mytools.read_maintain_menu()
        
        myseg.insertSegment(withTitle: "全部", at: 0, animated: false)
        
        myseg.insertSegment(withTitle: items[0], at: 1, animated: false)
        
        myseg.insertSegment(withTitle: items[1], at: 2, animated: false)
        
        
        myseg.insertSegment(withTitle: items[2], at: 3, animated: false)
        myseg.selectedSegmentIndex = nowSegindex
        stylizeFonts()

    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        self.reloadSegitem()

        
    }
    
   
    @objc func changeseg()
    {
        myseg.selectedSegmentIndex = 0
        nowSegindex = 0
    }
    
    
    
    func reload_component()
    {
        
        PickerProducts = UIPickerView(frame: CGRect(x:0.0, y:0.0, width:250, height:150))
        PickerProducts.delegate =  self;
        PickerProducts.dataSource = self;
        //PickerProducts.showsSelectionIndicator = true
        
        
        let mytools = mytool()
        let rs = mytools.read_product_category_name()
        
        carProductCategoryID = rs.pid
        carProductCategory = rs.pname
        
        let rs1 = mytools.read_product_name(categoryid: carProductCategoryID[0])
        
        carProductsID = rs1.pid
        carProducts = rs1.pname
        
        
        
    }
    
    @objc func lbl_changetext(notification:Notification)
    {
        
        let tmpstr:String = notification.userInfo?["name"] as! String

        let tmpvalue:String = notification.userInfo?["value"] as! String

        if tmpvalue == "edit"
        {
            
            
            //self.lblmain_view.frame = CGRect(x: 80, y: 50, width: 180, height: 21)
            
            self.lblmain_view.text = tmpstr
            
            

            
        }
        else if tmpvalue == "rangeshow"
        {
            //self.lblmain_view.frame = CGRect(x: 123, y: 54, width: 74, height: 21)
        
            self.lblmain_view.text = tmpstr
        }
        else
        {

            self.lblmain_view.text = "最近15筆主單資訊"

        
        
        }
        

        
    }
    

    @objc func cancel_Search()
    {
    
        isSearch = false
    
        //取消搜尋
        
        //self.lblmain_view.frame = CGRect(x: 123, y: 54, width: 74, height: 21)

        lblmain_view.text = "最近15筆主單資訊"

        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self,userInfo: ["name": 0])

    
    
    
    
    }
    
}
