//
//  oilDetailTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/10.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class oilDetailTableViewController: myBaseTableViewController,UIPopoverPresentationControllerDelegate
{
    
    var filloilID_r = [String]()
    var filloilDate_r = [String]()
    var oilPrice_r = [String]()
    var fillMoney_r = [String]()
    var fillLitre_r = [String]()
    var workKm_r = [String]()
    var filloil_r = [String]()
    var payType_r = [String]()
    var oilType_r = [String]()
    var custom_oiltype = [String]() //自訂油種
    var defaultcarid:String = "0"
    var delstatus:String = "del" //目前狀態
    
    var show_detail_type:String = "0" //代表前15筆
    
    var isEditoil:Bool = false
    
    var now_selectfilloilid:String = "" //點選到的列
    
    @IBOutlet weak var del_item: UIBarButtonItem!


    //var mybtn = UIBarButtonItem()

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
 
        let mytools = mytool()
        defaultcarid = mytools.read_car_default()
        
        NotificationCenter.default.addObserver(self, selector: #selector(oilDetailTableViewController.show_oil_month(notification:)), name: NSNotification.Name(rawValue: "show_oil_month"), object:nil)

        
        
    }
    
    
    @objc func show_oil_month(notification:Notification)
    {
        
        let tmpstr:Int = notification.userInfo?["name"] as! Int
        
        switch tmpstr
        {
        case 0:

            isEditoil = true
            
            tableView.reloadData()
            
            

            break
            
            
        case 1:
            
            show_detail_type = "1"
            reload_oildata()
            tableView.reloadData()
            
            break
            
        case 2:
            
            show_detail_type = "2"
            reload_oildata()
            tableView.reloadData()

            break
            
        case 3:
            
            show_detail_type = "3"
            reload_oildata()
            tableView.reloadData()

            break
            
        default:
            break
        }
        
    }

    

    override func viewWillAppear(_ animated: Bool)
    {
        //抓油耗
        let mytools = mytool()
        let newcarid = mytools.read_car_default()
        
        if newcarid != defaultcarid
        {
            self.navigationController?.popViewController(animated: true)

            return
            
        }
        
        else
        {
        
            //title改一下
            let mycarnicename = mytools.read_car_info(defaultcarid: defaultcarid)
            
            navigationItem.title = "\(mycarnicename[1])油耗明細"
            
            reload_oildata()
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if filloil_r.count == 0
        {

            return 1
        }
        
        return filloilID_r.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! oilDetailTableViewCell

        // Configure the cell...
        
        if filloil_r.count == 0
        {
            cell.lblwalkkm.text = "無油耗資訊"
            cell.lblTotalMoney.text = ""
            cell.lblCredit.text = ""
            cell.lbloilType.text = ""
            cell.lbloilprice.text = ""
            cell.lblkmlibra.text = ""
            cell.lblfillornot.text = ""
            cell.selectionStyle = .none
            
            cell.lblwalkkm.frame = CGRect(x: 100, y: 30, width: 200, height: 19)
            
            return cell
        }

        cell.selectionStyle = .none

        cell.lblwalkkm.frame = CGRect(x: 123, y: 7, width: 188, height: 19)

        
        cell.lblTotalMoney.text = "\(fillMoney_r[indexPath.row])元"
        let nowwork_km = workKm_r[indexPath.row]
        let flonowwork_km:Float = Float(nowwork_km) ?? 0
        let string_flonow = String(format:"%.2f",flonowwork_km)
        cell.lblwalkkm.text = "\(string_flonow)公里(\(filloilDate_r[indexPath.row]))"

        
        cell.lbloilprice.text = "油價:\(oilPrice_r[indexPath.row])元"
        
        
        
        
        cell.lbloilType.text = custom_oiltype[Int(oilType_r[indexPath.row])!]
        
        
        //walkkm/加油公升
        
        let kmlitre = Float(workKm_r[indexPath.row])! / Float (fillLitre_r[indexPath.row])!
        
        
        cell.lblkmlibra.text = "\(String(format: "%.2f", kmlitre))公里/公升"
        
        
        if filloil_r[indexPath.row] == "0"
        {
            cell.lblfillornot.text = "加滿"
            
        }
        else
        {
            
            cell.lblfillornot.text = "未滿"
        }
        
        
        if payType_r[indexPath.row] == "0"
        {
            cell.lblCredit.text = "現金"

        }
        else
        {

            cell.lblCredit.text = "信用卡"

        
        }
        
        if isEditoil //修改的話，要能點
        {
            cell.selectionStyle = .default
        }
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && filloilID_r.count > 1
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
            
        else if indexPath.row == 0 && (filloilID_r.count == 1 || filloilID_r.count == 0)
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
            
        else if indexPath.row == filloilID_r.count - 1
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



    
    @IBAction func del_oildetail(sender: UIBarButtonItem)
    {
        
        self.dismiss(animated: true, completion: nil)

        if delstatus == "del"
        {
            
            tableView.isEditing = true
            delstatus = "cancel"
            
           // del_item.setBackgroundImage(nil, for: UIControlState.normal, style: UIControlState.normal, barMetrics: UIBarMetrics.default)
            
            del_item.image = UIImage(named:"cancel7575")
            
            
        }
        else
        {
            
            tableView.isEditing = false
            delstatus = "del"

            del_item.image = UIImage(named:"del7575")

            
        }
        
        
        
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "刪除"
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        //真的刪除
        
        
        delstatus = "del"
        
        let myoilinfo = OilInfo()
        myoilinfo.del_oil_detail(oilid: filloilID_r[indexPath.row])
        
        reload_oildata()

        tableView.reloadData()

        if filloilID_r.count == 0
        {
            self.dismiss(animated: true, completion: nil)

            navigationController?.popViewController(animated: true)

        }
        
        //edit status改變
        
        tableView.isEditing = false
        del_item.image = UIImage(named: "del7575")
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {

        if filloilID_r.count == 0
        {
            return false
        }
        return true
        
    }
    
    func reload_oildata()
    {
        
        //抓油耗
        
        let myoilinfo = OilInfo()
        let myoil = myoilinfo.return_oildetail(type: show_detail_type)
        
        
        filloilID_r = myoil.filloilID_a
        filloilDate_r = myoil.filloilDate_a
        oilPrice_r = myoil.oilPrice_a
        fillMoney_r = myoil.fillMoney_a
        fillLitre_r = myoil.fillLitre_a
        workKm_r = myoil.workKm_a
        filloil_r = myoil.filloil_a
        payType_r = myoil.payType_a
        oilType_r = myoil.oilType_a
        
        let mytools = mytool()
        custom_oiltype = mytools.read_oil_type()
        
        if filloilID_r.count == 0
        {
            del_item.isEnabled = false
        }
        else
        {
        
            del_item.isEnabled = true
        
        }
        
        
    }
    

    @IBAction func click_me(_ sender: Any)
    {
        
        
        
        self.dismiss(animated: true, completion: nil)

        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @IBAction func show_details(_ sender: UIBarButtonItem)
    {
        
        performSegue(withIdentifier: "showmonthoil",
                     sender: self)

        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "showmonthoil"
        {
            let vc = segue.destination
            let fullScreenSize = UIScreen.main.bounds.size
            
            
            vc.preferredContentSize = CGSize(width: fullScreenSize.width, height: 250)
            let controller = vc.popoverPresentationController
            if controller != nil
            {
                controller?.delegate = self
                
            }
            
            
            
        }
        
        if segue.identifier == "modifyoil"
        {
            
            
            if let toViewController = segue.destination as? oilMainTableViewController
            {
                
                toViewController.isEditoil = true
                //fillid 記得
                toViewController.filloilID = now_selectfilloilid
                
                
            }
            
            
            
            
            
            
            
        }
        


    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        //呼叫 oilMainTableViewController
        //傳filloilid過去
        //傳show_detail_type過去
        
        if filloilID_r.count != 0 && isEditoil
        {

            now_selectfilloilid = filloilID_r[indexPath.row]
            
            performSegue(withIdentifier: "modifyoil",
                         sender: self)
            

            
        }
        
        
        
        
    }
    
    
    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    

}

