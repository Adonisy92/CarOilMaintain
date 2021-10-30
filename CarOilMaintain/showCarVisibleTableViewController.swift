//
//  showCarVisibleTableViewController.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/16.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class showCarVisibleTableViewController: myBaseTableViewController
{

    var carid_r = [String]()//車子陣列
    var carnickname_r = [String]()//車子陣列
    var carcompany_r = [String]()//車子陣列
    var carstyle_r = [String]()//車子陣列
    var carvisible_r = [String]() //是否顯示
    var defaultcarid:String = "0"

    
    @IBAction func click_me(_ sender: Any)
    {
        
        
        //回上一頁
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func reloaddb(notification:Notification)
    {
    
        let mytools = mytool()
        let rs = mytools.ReadCarVisibleinfofromDB()
        carid_r = rs.carid
        carnickname_r = rs.carnickname
        carcompany_r = rs.carcompany
        carstyle_r = rs.carstyle
        carvisible_r = rs.carvisible

        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let mytools = mytool()
        let rs = mytools.ReadCarVisibleinfofromDB()
        carid_r = rs.carid
        carnickname_r = rs.carnickname
        carcompany_r = rs.carcompany
        carstyle_r = rs.carstyle
        carvisible_r = rs.carvisible
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //tableView.contentInset = UIEdgeInsetsMake(35, 0, 0, 0)

        
        let mytools = mytool()
        defaultcarid = mytools.read_car_default()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.reloaddb), name: NSNotification.Name(rawValue: "reloadtable"), object:nil)


    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        if carid_r.count == 0
        {
            return 1
        }
        
        
        return carid_r.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! customVisibleTableViewCell
        
        if carid_r.count != 0
        {
            cell.setcarid(carid: carid_r[indexPath.row])
        
            if defaultcarid == carid_r[indexPath.row]
            {
                cell.sw_visible.isEnabled = false
            }
        
            cell.lblcar_nickname.text = carnickname_r[indexPath.row]
            cell.lblcar_style.text = "\(carcompany_r[indexPath.row])-\(carstyle_r[indexPath.row])"
        
            if carvisible_r[indexPath.row] == "0"
            {

                cell.sw_visible.isOn = true

            
            }
            else
            {

                cell.sw_visible.isOn = false

            }
        
 
        }
        else
        {
        
            cell.lblcar_nickname.text = ""
            cell.lblcar_style.text = "第二台後才能設定顯示與否"
            cell.sw_visible.isHidden = true
        
        
        }
        
        cell.selectionStyle = .none

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
            
        else if indexPath.row == 0 && (carid_r.count == 1 || carid_r.count == 0)
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

    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

        
    }
    
    
    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

        
    }
    

}
