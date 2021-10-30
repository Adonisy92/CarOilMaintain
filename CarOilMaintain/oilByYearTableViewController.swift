//
//  oilByYearTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/19.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class oilByYearTableViewController: myBaseTableViewController
{

    var inputtype:Int = 4 //每月油錢

    var oilYear_r = [String]()
    var oilMonth_r = [String]()
    var oilMoney_r = [String]()
    var oilLibre_r = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        NotificationCenter.default.addObserver(self, selector: #selector(oilByYearTableViewController.connect_chart), name: NSNotification.Name(rawValue: "connect_chart"), object:nil)

        

    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        let mytools = mytool()
        
        let defaultcarid = mytools.read_car_default()
        
        let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)

        switch inputtype
        {
        case 4:
            
            navigationItem.title = "\(carinfo[1])年月油錢"
            let st = mystatistic()
            let st1 = st.read_limit10_info_cell4()
            oilYear_r = st1.oilYear
            oilMonth_r = st1.oilMonth
            oilMoney_r = st1.oilMoney
            oilLibre_r = st1.oilLibre

            
            break
        case 5:
            
            navigationItem.title = "\(carinfo[1])每年油錢"
            
            let st = mystatistic()
            let st1 = st.read_limit10_info_cell5()
            oilYear_r = st1.oilYear
            oilMoney_r = st1.oilMoney
            oilLibre_r = st1.oilLibre
            

            
            break
        case 6:
            
            navigationItem.title = "\(carinfo[1])年月公里"
            
            let st = mystatistic()
            let st1 = st.read_limit10_info_cell66()
            oilYear_r = st1.oilYear
            oilMonth_r = st1.oilMonth
            //oilMoney_r = st1.oilMoney
            oilLibre_r = st1.oilLibre //其實是公里
            

            
            break
        default:
            break
        }
        


            
        
        
        
        
        
    }

    @IBAction func click_me(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if oilYear_r.count == 0
        {
         return 1
        }
        return oilYear_r.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        // Configure the cell...
        if oilYear_r.count == 0
        {
            cell.textLabel?.text = "無資訊"
            cell.detailTextLabel?.text = ""
            return cell
        }

        else
        {
            
            switch inputtype
            {
            case 4:
                cell.textLabel?.text = "\(oilYear_r[indexPath.row])年\(oilMonth_r[indexPath.row])月"
                cell.detailTextLabel?.text = "\(oilMoney_r[indexPath.row])元 \(oilLibre_r[indexPath.row])公升"
                
                
                return cell
            case 5:
                
                cell.textLabel?.text = "\(oilYear_r[indexPath.row])年"
                cell.detailTextLabel?.text = "\(oilMoney_r[indexPath.row])元 \(oilLibre_r[indexPath.row])公升"
                
                
                return cell
                
            case 6:
                
                cell.textLabel?.text = "\(oilYear_r[indexPath.row])年\(oilMonth_r[indexPath.row])月"
                cell.detailTextLabel?.text = "\(oilLibre_r[indexPath.row])公里"

                return cell
            default:
                break
            }
            
           


            
            return cell
            
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && oilYear_r.count > 1
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
            
        else if indexPath.row == 0 && (oilYear_r.count == 1 || oilYear_r.count == 0)
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
            
        else if indexPath.row == oilYear_r.count - 1
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

    @objc func connect_chart()
    {
        
        
        
        performSegue(withIdentifier: "showyearchar",
                     sender: self)

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        //傳 maintain_id過去
        if segue.identifier == "showyearchar"
        {
            
            if let toViewController = segue.destination as? chartoilYearViewController
            {
                toViewController.inputtype = self.inputtype
            }
            
        }

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
