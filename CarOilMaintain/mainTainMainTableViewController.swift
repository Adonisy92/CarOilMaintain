//
//  mainTainMainTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/6.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class mainTainMainTableViewController: myBaseTableViewController,UIPopoverPresentationControllerDelegate
{

    var mybutton = UIButton()
    var smgindex:Int = 0
    
    var maintainID = [String]()//維護id
    var maintainkm = [String]()//維護里程
    var maintaindate = [String]()//維護日期
    var maintainmenu = [String]()//維修選單
    var mainornot = [String]() //維護種類
    var firstproductid = [String]() //前15筆產品編號
    var passmaintainID:String = ""//要傳到 detail的 maintainID
    var isSearch:Bool = false //預設不是搜尋
    var isDelete:Bool = false //是否按下刪除
    var isEdit:Bool = false //是否按下修改
    
    //長按設定
    var hudView = UIView()
    var captionLabel = UITextView()
    
    var searchProductID:String = "" //搜尋的 productid
    
    let mytools = mytool()
    
    var range:Int = 0 // 0為前15筆，1為半年內，2為半年到三年，3為三年以上


    @IBOutlet weak var add_bar: UIBarButtonItem!

    @IBOutlet weak var detail_bar: UIBarButtonItem!

    
    @IBAction func show_details(_ sender: Any)
    {
        
        performSegue(withIdentifier: "showmaindetails",
                     sender: self)

        
    }
    
    
    
    @IBAction func modify_click(_ sender: Any)
    {
        
        if self.isEdit
        {
            //按下編輯的情況再按就要取消

            self.isEdit = false
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "最近15筆主單資訊","value":"cancel"])

            
            add_bar.image = UIImage(named: "add7575")
            add_bar.isEnabled = true

            
        }
        else
        {
            
            self.isEdit = true

            
        NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "請選資料列編輯","value":"edit"])
            add_bar.image = nil
            add_bar.isEnabled = false
            

            
        }

        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "刪除"
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        //刪除
        let ms = maintain()
        
        _ = ms.delete_maintain_main(MaintainID: maintainID[indexPath.row])
        
        if isSearch //搜尋後的刪除
        {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.searchProductID,"seg":self.smgindex])
            
            
            
        }

        else //一般的刪除
        {
            reload_db(index_i: self.smgindex,range_i: self.range)
        }
        //isDelete = false
        
        
        tableView.isEditing = false
        tableView.reloadData()
        
    }
    
    
    @IBAction func add_maintain(_ sender: Any)
    {
        isDelete = false
        isSearch = false
        isEdit = false
        tableView.isEditing = false
        self.dismiss(animated: true, completion: nil)
        
        performSegue(withIdentifier: "segue_input_car",
                     sender: self)
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "segue_input_car"
        {
            
            if isEdit //修改
            {
                if let toViewController = segue.destination as? input_main_TableViewController
                {
                    toViewController.addOrModified = "edit"
                    toViewController.input_Maintain_id = passmaintainID
                }
                
                
                
            }
            else //新增
            {
            
                if let toViewController = segue.destination as? input_main_TableViewController
                {
                    toViewController.addOrModified = "add"
                    toViewController.smgindex = smgindex
                }
                
            }
            
            
        }
        
        
        if segue.identifier == "showdetail"
        {

            if let toViewController = segue.destination as? detailMaintainTableViewController
            {
                toViewController.maintainID = passmaintainID
            }

            
        }
        
        
        if segue.identifier == "showmaindetails"
        {
            let vc = segue.destination
            let fullScreenSize = UIScreen.main.bounds.size

            vc.preferredContentSize = CGSize(width: fullScreenSize.width, height: 350)
            let controller = vc.popoverPresentationController
            if controller != nil
            {
                controller?.delegate = self
            
            }
            
            if let toViewController = segue.destination as? main_popviewTableViewController
            {
                
                toViewController.isDelete = isDelete
                toViewController.isEdit = isEdit
                toViewController.isSearch = isSearch
                toViewController.smgindex = self.smgindex
                
            }

            
            
        
        }

        
        
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if maintainID.count == 0
        {
            return 1
        }
        
        return maintainID.count
    }

    
    
   
    override func viewDidAppear(_ animated: Bool)
    {
        
        super.viewDidAppear(true)
        
        
        
        
        
        
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
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
        
        mybutton.setTitle("保修記錄", for: .normal)
        
        mybutton.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        
        
        //free
        mybutton.isEnabled = false
        
        
        self.navigationItem.titleView = mybutton
        
        //檢查有無輸入基本資料
        
        

        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.range_show), name: NSNotification.Name(rawValue: "range_show"), object:nil)

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.reloaddb), name: NSNotification.Name(rawValue: "refresh"), object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.search_resule(notification:)), name: NSNotification.Name(rawValue: "refreshsearch"), object:nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.EndEdit), name: NSNotification.Name(rawValue: "EndEdit"), object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.StartEdit), name: NSNotification.Name(rawValue: "StartEdit"), object:nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.delclick), name: NSNotification.Name(rawValue: "delclick"), object:nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(mainTainMainTableViewController.canceldelclick), name: NSNotification.Name(rawValue: "canceldelclick"), object:nil)

        //長按
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)

        //檢查資料表結構
        
        
        if mytools.check_cateogyr_orders_num() != true
        {
            
            _ = mytools.add_category_ordersnums()

        }
        
        if mytools.check_products_orders_num() != true
        {
            
            //檢查產品是否有 orders_num欄位

            _ = mytools.add_product_ordersnums()
            
            
        }
 

        
        
        
        
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began
        {
            
            //長按開始
            
            let point = sender.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: point)
            
                var screenx: Int
                var screeny: Int
                   
                screenx = Int(UIScreen.main.bounds.width)
                screeny = Int(UIScreen.main.bounds.height)

            
            
            
                   hudView.viewWithTag(1)
                   
                    hudView.frame = CGRect(x: screenx/2 - 90 , y: screeny/3 - 70, width: 200, height: 150)
            
            //將 hubView置中
            hudView.center = tableView.convert(tableView.center, from:tableView.superview)

                    hudView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                    hudView.clipsToBounds = true
                    hudView.layer.cornerRadius = 10.0
                    hudView.tag = 1
                    captionLabel = UITextView(frame: CGRect(x: 15, y: 10, width: 185, height: 120))
                    captionLabel.backgroundColor = UIColor.clear
                    captionLabel.textColor = UIColor.white
                    captionLabel.font = UIFont.boldSystemFont(ofSize: 18)
                    captionLabel.textAlignment = .left
            
        let maintains = maintain()
        let rs = maintains.read_detail_maintain(maintainID: maintainID[indexPath?.row ?? 0])
        

            var product_temp:String = ""
            //抓明細名稱
            var n:Int = 0
            rs.productid.forEach{
                theid in
                
                let mytools = mytool()
                let returnproductname = mytools.read_first_productname(productid: theid)

                product_temp = product_temp + returnproductname + ":"+rs.price[n]+"\n"
                n += 1
                
            }
            
                       captionLabel.text = product_temp
                       captionLabel.isEditable = false
                   
                       hudView.addSubview(captionLabel)

                       view.addSubview(hudView)
            
        }
        else if sender.state == .ended
        {

            //長按結束
            
            let tmpimg: UIView? = (view.viewWithTag(1))
            if tmpimg != nil
            {
                tmpimg?.removeFromSuperview()
            }

        captionLabel.text = ""

            
        }
        
        
        
    }
    
    @objc func range_show(notification:Notification)
    {
        
        self.range = notification.userInfo?["range_i"] as! Int //丟 range資訊進來
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: self,userInfo: ["name": smgindex])

        

        
        
        
    }
    
    @objc func delclick()
    {
        
        //刪除按下
        isDelete = true
        isEdit = false
        
        tableView.isEditing = true
  //      add_bar.image = UIImage(named: "add7575")
  //      add_bar.isEnabled = true
        

        
    }
    
    @objc func canceldelclick()
    {
        //取消刪除按下
        isDelete = false
        isEdit = false
        
        tableView.isEditing = false
//        add_bar.image = UIImage(named: "add7575")
//        add_bar.isEnabled = true

        
    }
    
    
    
    @objc func EndEdit()
    {
        
        self.isEdit = false
        
        
        
    }
    
    @objc func StartEdit()
    {
        
        self.isEdit = true
        
    }
   
    
    @objc func pressButton(button: UIButton)
    {
        
        //self.isSearch = false
        
        isEdit = false
        isDelete = false
        tableView.isEditing = false
        
        self.dismiss(animated: true, completion: nil)
        
        performSegue(withIdentifier: "todefaultcar1",
                     sender: self)
        
        
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! cellmainTableViewCell

        
        if maintainID.count == 0
        {

                if smgindex == 0
                {
                    if self.isSearch
                    {
                        cell.lblDate.text = "無搜尋結果，按我淸除"
                        cell.selectionStyle = .default
                    }
                    else if self.range == 1 //半年內無主單
                    {
                    
                        cell.lblDate.text = "半年內無資料,顯示最近15筆資料"
                        cell.selectionStyle = .default
                        //修改與刪除要關

                    
                    }
                        else if self.range == 2 //半年到三年
                    {
                    
                        //修改與刪除要關


                        cell.lblDate.text = "半年-三年內無資料"
                        cell.selectionStyle = .none

                    
                    
                    
                    }
                    else if self.range == 3
                    {
                    
                        //修改與刪除要關

                        
                        cell.lblDate.text = "三年以上無資料"
                        cell.selectionStyle = .none

                    
                    }
                    else
                    {
                        cell.lblDate.text = "按右上角+新增主單資訊"
                        cell.selectionStyle = .none

                        detail_bar.image = nil
                        detail_bar.isEnabled = false

                    }
                    
                }
                else
                {
                    if self.isSearch
                    {
                        cell.lblDate.text = "無搜尋結果，按我淸除"
                        cell.selectionStyle = .default
                    }
                    else
                    {

                    cell.lblDate.text = "按右上角+新增\(maintainmenu[smgindex-1])資訊"
                    cell.selectionStyle = .none
                    }
                    
                    
                }
            

            
            
            cell.lblkm.text = ""
            cell.lblmaintype.text = ""
            cell.lblproductname.text = ""
            cell.lblDate.frame = CGRect (x: 30, y: 23, width: 250, height: 21)
            

            
            
        }
        else
        {
            cell.lblDate.frame = CGRect (x: 18 , y: 6, width: 163, height: 21)
            cell.lblDate.text = maintaindate[indexPath.row]
            cell.lblkm.text = "\(maintainkm[indexPath.row])公里"
            if mainornot[indexPath.row] == "3"
            {
                cell.lblmaintype.text = maintainmenu[2]

            }
            else
            {

                switch Int(mainornot[indexPath.row])!
                {
                case 0:
                    cell.lblmaintype.text = maintainmenu[1] //保養
                case 1:
                    cell.lblmaintype.text = maintainmenu[0] //維修
                case 3:
                    cell.lblmaintype.text = maintainmenu[2] //停車
                    
                default:
                    break
                }
                if Int(mainornot[indexPath.row])! == 0
                {


                    
                }
                
            
            }
            
            
            cell.lblproductname.text = mytools.read_first_productname(productid: firstproductid[indexPath.row])
            
            cell.selectionStyle = .default

            detail_bar.image = UIImage(named: "showdetail7575")
            detail_bar.isEnabled = true

            
        }
        // Configure the cell...
        
        return cell
    }
    
    
    @objc func search_resule(notification:Notification)
    {
    
        self.isSearch = true //搜尋中
        
        let tmpstr:String = notification.userInfo?["productid"] as! String
        
        smgindex = notification.userInfo?["seg"] as! Int
                
        self.searchProductID = tmpstr
        
        let mytools = mytool()
        let rs = mytools.read_maintain_main(index: smgindex, productid: tmpstr)
        
        maintainID = rs.maintainid
        maintainkm = rs.maintainkm
        maintaindate = rs.maintainDate
        mainornot = rs.maintainornot

        firstproductid.removeAll()

        for _ in maintainID
        {

            firstproductid.append(tmpstr)
        
        }
        

        tableView.reloadData()
        
        //smgindex = 0
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "changeseg"), object: nil)


    
    }
    
    

    @objc func reloaddb(notification:Notification)
    {
        
        self.isSearch = false //搜尋結束
        
        
        let tmpstr:Int = notification.userInfo?["name"] as! Int
        
        switch tmpstr
        {
        case 0:
            
            smgindex = 0
            self.reload_db(index_i: 0,range_i: self.range)
            
            break
            
        case 1:
            smgindex = 1 //保養維修
            self.reload_db(index_i: 1,range_i: self.range)

            break
        case 2:
            smgindex = 2 //配件
            self.reload_db(index_i: 2,range_i: self.range)

            break
        case 3:
            smgindex = 3 //停車
            self.reload_db(index_i: 3,range_i: self.range)

            break
            
        default:
            
            break
        }

        tableView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        
        let mytools = mytool()
        
        let newdefaultcarid = mytools.read_car_default()
        
        let carinfo:[String] = mytools.read_car_info(defaultcarid: newdefaultcarid)
        
        mybutton.setTitle("\(carinfo[1])保修記錄", for: .normal)

        
        
        if !isSearch //沒搜尋
        {
            if !isEdit //沒修改
            {
                if !isDelete //沒刪除
                {

                    self.reload_db(index_i: self.smgindex,range_i: self.range) //預設反正為0
                    maintainmenu = mytools.read_maintain_menu()
                    
                    if maintainID.count == 0 && self.range == 0
                    {
                        add_bar.image = UIImage(named:"add7575")
                        add_bar.isEnabled = true
                        detail_bar.image = nil
                        detail_bar.isEnabled = false
                        
                        
                    }
                    tableView.reloadData()

                    
                }
                else
                {
                //有刪除(恢復，不要刪除)
                    isDelete = false
                    add_bar.image = UIImage(named: "add7575")
                    add_bar.isEnabled = true
                    detail_bar.image = UIImage(named: "showdetail7575")
                    self.tableView.isEditing = false
    
                
                
                }
                
            }
            else
            {
            //按了修改
                self.reload_db(index_i: self.smgindex,range_i: self.range) //預設反正為0
                tableView.reloadData()
                
            
            }
            
            
        }
        else if (isSearch && !isEdit)//有搜尋無修改
        {
        
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.searchProductID,"seg":self.smgindex])

            
            
            //NotificationCenter.default.post(name: Notification.Name(rawValue: "changeseg"), object: nil)

            
        
        }
        else
        {
        
            //print("有搜尋有修改")
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshsearch"), object: self,userInfo: ["productid": self.searchProductID,"seg":self.smgindex])

            
        
        }
    }
    
    
    
    func reload_db(index_i:Int,range_i:Int)
    {

        //哪個 tap 之外還要知道是要多少區間的資料
        let rs = mytools.read_maintain_main(index: index_i, range: range_i)

        maintainID = rs.maintainid
        maintainkm = rs.maintainkm
        maintaindate = rs.maintainDate
        mainornot = rs.maintainornot
        
        //加區間，待改，不能寫死
        firstproductid = mytools.read_first_main_productid(segment: index_i, range_i: range_i, ordercount: maintainID.count)
        
        

        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && maintainID.count > 1
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
            
        else if maintainID.count == 1 || maintainID.count == 0
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
            
        else if indexPath.row == maintainID.count - 1
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
        if isSearch && maintainID.count == 0
        {
            isSearch = false
            reload_db(index_i: 0,range_i: self.range)
            //把 icon換了
            

            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeseg"), object: nil)

            
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changejpg"), object: nil)

            tableView.reloadData()
            return
            
        }
        else if maintainID.count != 0 && !isEdit
        {
            passmaintainID = maintainID[indexPath.row]
            performSegue(withIdentifier: "showdetail",
                     sender: self)
            return
        }
        else if isEdit //編輯
        {
        
            if maintainID.count != 0
            {
                passmaintainID = maintainID[indexPath.row]
                performSegue(withIdentifier: "segue_input_car",
                         sender: self)
            }
            
            return
        
        }
        
        if range == 1 && maintainID.count == 0 && smgindex == 0
        {
            //全部的半年內無資料，切成前15筆
            
            self.range = 0
            
            //換title
            NotificationCenter.default.post(name: Notification.Name(rawValue: "lblchangetext"), object: self,userInfo: ["name": "最近15筆主單資訊","value":"rangeshow"])

            NotificationCenter.default.post(name: Notification.Name(rawValue: "range_show"), object: self,userInfo: ["range_i": self.range])

            
            
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if maintainID.count == 0
        {
            return false
        }
        
        return true
        
    }
    
    
    

}
