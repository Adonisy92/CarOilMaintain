//
//  defaultcarSettingTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/27.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class defaultcarSettingTableViewController: myBaseTableViewController
{

    var carcompany_r = [String]()
    var carid_r = [String]()
    var carnickname_r = [String]()
    var carstyle_r = [String]()
    
    var nowdefaultCar:String = "0" //預設的車輛
    
    var lastIndexPath:IndexPath? = nil
    
    @IBOutlet weak var del_item: UIBarButtonItem!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carcompany_r.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        let myFont = UIFont(name: "Masque", size: CGFloat(8))

        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.blue
        cell.textLabel?.text = carnickname_r[indexPath.row]
        
        cell.detailTextLabel?.textColor = UIColor.red
        cell.detailTextLabel?.font = myFont
        
        if (carid_r[indexPath.row]) == nowdefaultCar
        {
        
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor.blue
            cell.selectionStyle = .none
            lastIndexPath = indexPath

            
        }
        else
        {
        
            cell.accessoryType = .none
        
        }
        
        cell.detailTextLabel?.text = "\(carcompany_r[indexPath.row]) － \(carstyle_r[indexPath.row])"

        

        return cell
    }

 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && carid_r.count > 1
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
            
        else if indexPath.row == 0 && carid_r.count == 1
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
            
        else if indexPath.row == carid_r.count - 1
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


    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let mytools = mytool()
        
        let rs = mytools.ReadCarfromDB()
        
        carnickname_r = rs.carnickname
        carcompany_r = rs.carcompany
        carid_r = rs.carid
        carstyle_r = rs.carstyle
        
        nowdefaultCar = mytools.read_car_default()
        
        if nowdefaultCar == "0"
        {
            del_item.image = nil
        }
        else
        {
        
            del_item.image = UIImage(named:"del7575")
        
        }

        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if indexPath.row == 0
        {
            
            del_item.image = nil
            
            
        }
        else
        {
        
            del_item.image = UIImage(named:"del7575")
        
        }
        
        let mytools = mytool()
        mytools.save_car_default(defaultid: carid_r[indexPath.row])
        
        
        let newCell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        

        if (lastIndexPath != nil)
        {
            
            let oldCell: UITableViewCell? = tableView.cellForRow(at: lastIndexPath!)
            oldCell?.selectionStyle = .default
            oldCell?.accessoryType = .none

            
        }
        


        newCell?.accessoryType = .checkmark
        newCell?.tintColor = UIColor.blue
        newCell?.selectionStyle = .none
        
        tableView.deselectRow(at: lastIndexPath!, animated: true)

        
        lastIndexPath = indexPath
        
        
        
        
    }
    
    @IBAction func delTapped(_ sender: Any)
    {
        
        
        displayAlert("訊息", messagecontent: "刪除車輛會刪除全部相關設定，請確定")
        
      
        
    }
    
    
    @IBAction func click_ok(sender: UIBarButtonItem)
    {
    
        self.navigationController?.popViewController(animated:true)
    
    }
    
    

    func displayAlert(_ title_i:String,messagecontent:String)
    {
        
        //let alert = UIAlertController(title: title_i, message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        let alert = UIAlertController(title:title_i,message: messagecontent,preferredStyle: .alert);
                
        
        
        alert.addAction(UIAlertAction(title: "取消", style:.cancel,handler: nil));
            
        
        alert.addAction(UIAlertAction(title: "確定", style: .default , handler:{ (UIAlertAction)in
            //按下確定
            
       
            let mytools = mytool()
            
            let defaultcarid:String = mytools.read_car_default()
            
            
            if mytools.check_carid_column() != true
            {
                
                _ = mytools.add_repaireTable_column_carid() //加一個欄位
                _ = mytools.insert_car_repaire_column_by_carid() //塞值
                _ = mytools.add_maintain_picurl_defaultcar() //pic欄位
                _ = mytools.add_maintain_picurl_new_car()

                
            }

            
            mytools.del_car(carid: defaultcarid)
            mytools.del_FillOil(carid: defaultcarid)
            mytools.del_mainTain_detail(carid: defaultcarid)
            mytools.del_MainTainMain(carid: defaultcarid)
            mytools.del_carimg(carid: defaultcarid)
            //保修資料
            _ = mytools.del_car_repaire_column_by_carid(defaultid: defaultcarid)
            
            if defaultcarid != "0"
            {
                
                mytools.del_carTotalKM(carid: defaultcarid)
                
            }
            
            self.nowdefaultCar = "0"
            
            mytools.save_car_default(defaultid: self.nowdefaultCar)
            
            let rs = mytools.ReadCarfromDB()
            
            self.carnickname_r = rs.carnickname
            self.carcompany_r = rs.carcompany
            self.carid_r = rs.carid
            self.carstyle_r = rs.carstyle
            
            self.tableView.reloadData()
            self.del_item.image = nil

            
            
            
            
            
        }))
        self.present(alert, animated: true, completion:nil)
        
        
    }

    
    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

        
    }
    
    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

    }
    

}
