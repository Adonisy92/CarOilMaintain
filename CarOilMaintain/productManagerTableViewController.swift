//
//  productManagerTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/21.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class productManagerTableViewController: myBaseTableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate
{

    var categoryContent = [String]()
    var categoryContentid = [String]()
    
    var productContent = [String]()
    var productContentid = [String]()

    
    var click_productname:String = ""
    var click_productid:String = ""
    
    var isdisplay_delete:Int = 0
    
    var now_select_categoryid:String = "0"
    
    
    var tField_insert: UITextField!
    var tField: UITextField!
    
    var del_status:String = "del"
    
    var isdisplay_order:Int = 0
    
    var windows_pick_category:String = ""


    
    
    @IBOutlet weak var mypickview: UIPickerView!
    
    var choose_category:UIPickerView = UIPickerView() //選擇要轉到哪個分類

    
    
    @IBOutlet weak var del_item: UIBarButtonItem!

    @IBOutlet weak var change_order: UIBarButtonItem!

    

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mypickview.dataSource = self
        mypickview.delegate = self
        
        
        
     
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let mytools = mytool()
        let ms = mytools.read_product_category_name()
        categoryContentid = ms.pid
        categoryContent = ms.pname

        now_select_categoryid = categoryContentid[0]
        
        let ms1 = mytools.read_product_name(categoryid: categoryContentid[0])
        
        productContentid = ms1.pid
        productContent = ms1.pname
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        return categoryContentid.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
       
            return 1
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
            
            return categoryContent[row]
            
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
    if pickerView == mypickview
        {
            isdisplay_order = 0
        
            change_order.isEnabled = false
        //del_item.image = UIImage(named: "del7575")
        
        
        
            now_select_categoryid = categoryContentid[row]

        
            let mytools = mytool()
            let ms = mytools.read_product_name(categoryid: categoryContentid[row])
        
            productContent = ms.pname
            productContentid = ms.pid
        
            tableView.reloadData()
        }
        
        //對話方框的
        else
        {
            
            //記錄目前點選的 categoryid
            
            windows_pick_category = categoryContentid[row]
            
            
        }
        
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        
        if (pickerView == mypickview)
        {
            let titleData = categoryContent[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
        }
        else
        {
            

            let titleData = categoryContent[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.red])
        return myTitle

            
            
        }
         
    }
     */
    

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if productContentid.count == 0
        {
            return 0
        }
        return productContentid.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        // Configure the cell...

        cell.textLabel?.text = productContent[indexPath.row]
        
        return cell
    }

    
    func save_data()
    {
        
        isdisplay_order = 0
        del_item.isEnabled = true
        tableView.isEditing = false
        del_status = "del"
        del_item.image = UIImage(named: "del7575")

        self.change_order.isEnabled = false
        //呼叫儲存的 method
        let mytools = mytool()
        
        mytools.change_product_order(productid: productContentid)

        
        
        
    }


    func check_save()
    {
        
        if isdisplay_order == 1
        {
        
        let alert = UIAlertController(title: "", message: "未儲存修改資訊，是否要儲存？", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{(UIAlertAction)in
            
            self.navigationController?.popViewController(animated: true)

            
        }))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            self.save_data()
            
            self.navigationController?.popViewController(animated: true)

            
        }))
        
        
        self.present(alert, animated: true, completion:nil)

            
        }

            
        self.navigationController?.popViewController(animated: true)

            

        
    }
    
    
    
    @IBAction func click_me(_ sender: Any)
    {
        
       
        self.check_save()

        
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && productContentid.count > 1
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
            
        else if indexPath.row == 0 && productContentid.count == 1
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
            
        else if indexPath.row == productContentid.count - 1
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

    
    @IBAction func insertTapped(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "", message: "輸入新的產品名稱", preferredStyle: .alert)
        
        choose_category.frame = CGRect(x: 0, y: 0, width: 270, height: 150)
        

        alert.addTextField(configurationHandler: configurationTextField1)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            
            let mytools = mytool()
            mytools.insert_product(categoryid: self.now_select_categoryid, new_name: self.tField_insert.text!)
            
            //取回最新分類並且把 orders_num值修改
            let maintains = maintain()
            let new_productid = maintains.read_new_productid()
            _ = maintains.update_product_orders_nums(input_productid: new_productid)

            
            
            let ms1 = mytools.read_product_name(categoryid: self.now_select_categoryid)
            
            self.productContentid = ms1.pid
            self.productContent = ms1.pname

            
            
            self.tableView.reloadData()
            
        }))
        
        self.present(alert, animated: true, completion:nil)
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //按下去，秀出 msgbox，顯示分類名稱，可以改名字
        
        
        click_productid = productContentid[indexPath.row]
        click_productname = productContent[indexPath.row]
        
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: "輸入新的產品名稱，可選新分類", preferredStyle: .alert)
        
        choose_category.frame = CGRect(x: 0, y: 0, width: 270, height: 150)
        
        choose_category.dataSource = self
        choose_category.delegate = self
        choose_category.tintColor = .black
        
        
        
        //滾輪指向目前的分類
        
        //取回目前的分類 id
        
        let mytools = mytool()
        let return_categoryid = mytools.read_categoryid_by_productid(productid: click_productid)
        
        self.windows_pick_category = return_categoryid
        
        //找出目前這個分類 id的 index 數字
       
        //guard let rr = categoryContentid.firstIndex(of: String(return_categoryid)) else { return 0 }
        let index1 = categoryContentid.firstIndex(of: return_categoryid)
        var return1:Int = 0
        
            
            return1 = index1 ?? 0
        
        
        

        
        choose_category.selectRow(return1, inComponent: 0, animated: false)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.view.addSubview(self.choose_category)

        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            
            let mytools = mytool()
            
            if (self.windows_pick_category == return_categoryid) //沒改 category
            {
            mytools.update_product_by_id(productid: self.click_productid, new_name: self.tField.text!)

            
            let ms1 = mytools.read_product_name(categoryid: self.now_select_categoryid)
            
            self.productContentid = ms1.pid
            self.productContent = ms1.pname
            
            
            
            self.tableView.reloadData()
            }
            else
            {
                //連分類都改了
                mytools.update_product_name_categoryid(productid: self.click_productid, new_name: self.tField.text!, categoryid: self.windows_pick_category)
                let ms1 = mytools.read_product_name(categoryid: self.now_select_categoryid)
                
                self.productContentid = ms1.pid
                self.productContent = ms1.pname
                
                let index2 = self.categoryContentid.firstIndex(of: self.now_select_categoryid)
                var return2:Int = 0
                
                    
                    return2 = index2 ?? 0


                self.mypickview.selectRow(return2, inComponent: 0, animated: false)
                
                self.tableView.reloadData()

                
            }
            
        }))
        
        self.present(alert, animated: true, completion:nil)
        
        
        
    }

    
    
    
    func configurationTextField1(_ textField: UITextField!)
    {
        tField_insert = textField
        tField_insert.clearButtonMode = .whileEditing
        tField_insert.text = ""
        tField_insert.delegate = self
        
    }
    
    func configurationTextField(_ textField: UITextField!)
    {
        tField = textField
        tField.clearButtonMode = .whileEditing
        
        tField.text = click_productname
        tField.delegate = self
        
        
        
    }
    
    
    @IBAction func save_product(sender: UIBarButtonItem)
    {
        //修改順序
        
        //儲存
        
        self.save_data()
        
        
        
        //顯示儲存完成
        
        let alert = UIAlertController(title: "訊息", message: "產品順序更改完成！", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion:nil)

        tableView.reloadData()
        
        
        //self.navigationController?.popViewController(animated: true)

        
        
        
        
    }
    
    
    @IBAction func del_product(sender: UIBarButtonItem)
    {
        
        if isdisplay_delete == 0
        {
            
            let alert = UIAlertController(title: "訊息", message: "只能刪除沒有加入維護明細的產品！", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)
            
            isdisplay_delete = 1
            
            
        }
        
        if del_status == "del"
        {
            
            tableView.isEditing = true
            del_status = "cancel"
            del_item.image = UIImage(named: "cancel7575")
            
            
        }
        else
        {
            
            tableView.isEditing = false
            del_status = "del"
            del_item.image = UIImage(named: "del7575")
            
            
            
        }
        
    }


    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "刪除"
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        //檢查分類有無產品在裡面

        var productid = [String]()
        
        let mytools = mytool()
        productid = mytools.haveproductid_maintaindetails()
        
        let search_index = productid.firstIndex(of: productContentid[indexPath.row])


        if search_index == nil
        {
            //可以刪除
            mytools.delete_product_by_id(productid: productContentid[indexPath.row])
            
            let ms1 = mytools.read_product_name(categoryid: self.now_select_categoryid)
            
            
            self.productContentid = ms1.pid
            self.productContent = ms1.pname
            
            del_status = "del"
            
            del_item.image = UIImage(named: "del7575")
            
            tableView.reloadData()
            
        }
        else
        {
            //有產品被記錄，秀出警告訊息
            let alert = UIAlertController(title: "訊息", message: "只能刪除沒有加入維護明細的產品！", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)
            
            
        }
        
        
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {

        
        //搬移了
        self.isdisplay_order = 1
        self.change_order.isEnabled = true
       
        //分類id與 分類名稱要跟著搬
        
        var tempArr:[String] = []
        var tempidArr:[String] = []
        
        if(sourceIndexPath.row > destinationIndexPath.row)
         { // 排在後的往前移動
            
            for (index, value) in productContentid.enumerated()
            {
                 if index < destinationIndexPath.row
                   || index > sourceIndexPath.row {
                     tempidArr.append(value)
                 } else if
                   index == destinationIndexPath.row {
                 tempidArr.append(productContentid[sourceIndexPath.row])
                 } else if index <= sourceIndexPath.row {
                     tempidArr.append(productContentid[index - 1])
                 }
             }
            
            
            
            for (index, value) in productContent.enumerated()
            {
                 if index < destinationIndexPath.row
                   || index > sourceIndexPath.row {
                     tempArr.append(value)
                 } else if
                   index == destinationIndexPath.row {
                 tempArr.append(productContent[sourceIndexPath.row])
                 } else if index <= sourceIndexPath.row {
                     tempArr.append(productContent[index - 1])
                 }
             }
         } else if (sourceIndexPath.row <
           destinationIndexPath.row) {
           // 排在前的往後移動
             for (index, value) in productContentid.enumerated()
             {
                 if index < sourceIndexPath.row
                 || index > destinationIndexPath.row {
                     tempidArr.append(value)
                 } else if
                 index < destinationIndexPath.row {
                     tempidArr.append(productContentid[index + 1])
                 } else if
                 index == destinationIndexPath.row {
                 tempidArr.append(productContentid[sourceIndexPath.row])
                 }
             }
             
             
             
             for (index, value) in productContent.enumerated()
             {
                 if index < sourceIndexPath.row
                 || index > destinationIndexPath.row {
                     tempArr.append(value)
                 } else if
                 index < destinationIndexPath.row {
                     tempArr.append(productContent[index + 1])
                 } else if
                 index == destinationIndexPath.row {
                 tempArr.append(productContent[sourceIndexPath.row])
                 }
             }
         } else {
             tempArr = productContent
             tempidArr = productContentid
         }

        productContent = tempArr
        productContentid = tempidArr
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        
        return true
        
    }
    
    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.check_save()


        
    }

    
    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {

        self.check_save()


        
        
    }


}
