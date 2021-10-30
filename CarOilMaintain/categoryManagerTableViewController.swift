//
//  categoryManagerTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/5.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class categoryManagerTableViewController: myBaseTableViewController,UITextFieldDelegate
{

    var categoryContent = [String]()
    var categoryContentid = [String]()
    var click_categoryname:String = ""
    var click_categoryid:String = ""
    var isdisplay_delete:Int = 0
    var isdisplay_order:Int = 0 //是否有按下調順序
    
    
    var tField: UITextField!
    var tField_insert:UITextField!
    
    var del_status:String = "del" //預設為刪除
    


    @IBOutlet weak var del_item: UIBarButtonItem!
    
    @IBOutlet weak var change_order: UIBarButtonItem!
    
    @IBAction func can_order(_ sender: Any)
    {
        
        //儲存
            isdisplay_order = 0
            del_item.isEnabled = true
            del_item.image = UIImage(named: "del7575")
            del_status="del"
            tableView.isEditing = false
            

        self.change_order.isEnabled = false
        //呼叫儲存的 method
        let mytools = mytool()
        
        mytools.change_category_order(categoryid: categoryContentid)
        
        
        
        //顯示儲存完成
        
        let alert = UIAlertController(title: "訊息", message: "分類順序更改完成！", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion:nil)


        tableView.reloadData()
//        self.navigationController?.popViewController(animated: true)

        
            
            
            
        
        
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
    }

    func reload_data()
    {
        let mytools = mytool()
        let rs = mytools.read_product_category_name()
        
        categoryContentid = rs.pid
        categoryContent = rs.pname

        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        reload_data()
        
        
    }
    
    
    @IBAction func del_category(sender: UIBarButtonItem)
    {
        
        if isdisplay_delete == 0
        {
         
        let alert = UIAlertController(title: "訊息", message: "注意！只能刪除沒有產品的產品分類！", preferredStyle: .alert)
        
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
            change_order.isEnabled = false
            

        }
        else
        {
        
            tableView.isEditing = false
            del_status = "del"
            del_item.image = UIImage(named: "del7575")
            isdisplay_order = 0


            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "刪除"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
     //檢查分類有無產品在裡面改在刪除時再找
        
        return true
        
        
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryContent.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        cell.textLabel?.text = categoryContent[indexPath.row]
        
        
        return cell
    }
    

  
  
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        

        
        if indexPath.row == 0 && categoryContent.count > 1
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
            
        else if indexPath.row == 0 && categoryContent.count == 1
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
            
        else if indexPath.row == categoryContent.count - 1
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
        //按下去，秀出 msgbox，顯示分類名稱，可以改名字
        
        
        click_categoryid = categoryContentid[indexPath.row]
        click_categoryname = categoryContent[indexPath.row]

        let alert = UIAlertController(title: "", message: "輸入新的分類名稱", preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in

            let mytools = mytool()
            mytools.update_category_by_id(categoryid:self.click_categoryid, new_name: self.tField.text!)
            self.reload_data()
            tableView.reloadData()

        
        
        }))
        
        self.present(alert, animated: true, completion:nil)
        
        
        
    }
    
    func configurationTextField(_ textField: UITextField!)
    {
        tField = textField
        tField.clearButtonMode = .whileEditing
        
            tField.text = click_categoryname
            tField.delegate = self
            
        
        
    }

    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        
        let mytools = mytool()
        let returnvalue = mytools.delete_category_by_id(categoryid:categoryContentid[indexPath.row])

        if (returnvalue == false)
        {
            
            let alert = UIAlertController(title: "訊息", message: "注意！只能刪除沒有產品的產品分類！", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)

                
        
        
            //警告
            

            
            
            return
            
            
            
        }
        
        reload_data()
        
        del_status = "del"
        
        del_item.image = UIImage(named: "del7575")
        
        tableView.reloadData()
 
        
        
    }
    
    
  

    @IBAction func insertTapped(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "", message: "輸入新的分類名稱", preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: configurationTextField1)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            
            let mytools = mytool()
            mytools.insert_category(new_name: self.tField_insert.text!)
            let maintains = maintain()
            
            //取回最新分類並且把 orders_num值修改
            let new_categoryid = maintains.read_new_categoryid()
            _ = maintains.update_category_orders_nums(input_categoryid: new_categoryid)

            self.reload_data()
            self.tableView.reloadData()
            
        }))
        
        self.present(alert, animated: true, completion:nil)
        
        

        
        
        
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
            
            for (index, value) in categoryContentid.enumerated()
            {
                 if index < destinationIndexPath.row
                   || index > sourceIndexPath.row {
                     tempidArr.append(value)
                 } else if
                   index == destinationIndexPath.row {
                 tempidArr.append(categoryContentid[sourceIndexPath.row])
                 } else if index <= sourceIndexPath.row {
                     tempidArr.append(categoryContentid[index - 1])
                 }
             }
            
            
            
            for (index, value) in categoryContent.enumerated()
            {
                 if index < destinationIndexPath.row
                   || index > sourceIndexPath.row {
                     tempArr.append(value)
                 } else if
                   index == destinationIndexPath.row {
                 tempArr.append(categoryContent[sourceIndexPath.row])
                 } else if index <= sourceIndexPath.row {
                     tempArr.append(categoryContent[index - 1])
                 }
             }
         } else if (sourceIndexPath.row <
           destinationIndexPath.row) {
           // 排在前的往後移動
             for (index, value) in categoryContentid.enumerated()
             {
                 if index < sourceIndexPath.row
                 || index > destinationIndexPath.row {
                     tempidArr.append(value)
                 } else if
                 index < destinationIndexPath.row {
                     tempidArr.append(categoryContentid[index + 1])
                 } else if
                 index == destinationIndexPath.row {
                 tempidArr.append(categoryContentid[sourceIndexPath.row])
                 }
             }
             
             
             
             for (index, value) in categoryContent.enumerated()
             {
                 if index < sourceIndexPath.row
                 || index > destinationIndexPath.row {
                     tempArr.append(value)
                 } else if
                 index < destinationIndexPath.row {
                     tempArr.append(categoryContent[index + 1])
                 } else if
                 index == destinationIndexPath.row {
                 tempArr.append(categoryContent[sourceIndexPath.row])
                 }
             }
         } else {
             tempArr = categoryContent
             tempidArr = categoryContentid
         }

         categoryContent = tempArr
        categoryContentid = tempidArr

        
        
      
        
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        
        return true
    }
    


    func configurationTextField1(_ textField: UITextField!)
    {
        tField_insert = textField
        tField_insert.clearButtonMode = .whileEditing
        
        tField_insert.text = ""
        tField_insert.delegate = self
        
        
        
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
        
        mytools.change_category_order(categoryid: categoryContentid)
        
        
        
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


    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.check_save()


        
    }
    
    
    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.check_save()


        
    }
    


}


