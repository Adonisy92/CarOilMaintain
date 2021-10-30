//
//  detailMaintainTableViewController.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class detailMaintainTableViewController:myBaseTableViewController,UIPopoverPresentationControllerDelegate
{

    var maintainID:String = "0"
    var detailid = [String]()
    var productid = [String]()
    var price = [String]()
    var memo = [String]()
    
    var detail_imgreturn = [String]() //回傳圖陣列
    
    var totalMoney:Int = 0
    var isSelectMode = 1 //瀏覽模式
   // var hudView = UIView()
    //var captionLabel = UITextView()
    var isClicked:Bool = false //預設沒有看 memo
    var defaultcarid:String = ""
    var isDelete:Bool = false //預設沒按刪除
    var isModify:Bool = false //預設沒按修改
    var passproductid:String = "0" //傳去修改的 productid
    
    
    //長按設定
    var hudView = UIView()
    var captionLabel = UITextView()

    
    @IBOutlet weak var detail_item: UIBarButtonItem!

    
    
    let mytools = mytool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        defaultcarid = mytools.read_car_default()
        
        NotificationCenter.default.addObserver(self, selector: #selector(detailMaintainTableViewController.del_me), name: NSNotification.Name(rawValue: "deleteDetail"), object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(detailMaintainTableViewController.modify_me), name: NSNotification.Name(rawValue: "modifyDetail"), object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(detailMaintainTableViewController.cancelmodify), name: NSNotification.Name(rawValue: "cancelmodify"), object:nil)

        
        //長按
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)


        

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

            
            
            
            
            
            let nowProductid = productid[indexPath?.row ?? 0]
            let maintains = maintain()
            let rs = maintains.read_datefrom_maintain(productID: nowProductid)
            
            let rowcount = rs.dateR.count

            var screenHeight:Int = 0
            //長度會變長
            
            screenHeight = rowcount * 25
            if screenHeight <= 75
            {
                
                screenHeight = 120
                
            }
            if (screenHeight > 350)
            {
                screenHeight = 350
            }
            
            hudView.frame = CGRect(x: screenx/2 - 90 , y: screeny/3 - 70, width: 240, height: screenHeight)
            //將 hubView置中

            hudView.center = tableView.convert(tableView.center, from:tableView.superview)
            hudView.viewWithTag(1)
            
            hudView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            hudView.clipsToBounds = true
            hudView.layer.cornerRadius = 10.0
            hudView.tag = 1


            captionLabel = UITextView(frame: CGRect(x: 5, y: 5, width: 230, height: screenHeight-10))
            captionLabel.backgroundColor = UIColor.clear
            captionLabel.textColor = UIColor.white
            captionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            captionLabel.textAlignment = .left


            var product_temp:String = ""
            if rs.dateR.count == 1
            {
                
                product_temp = "這個項目只有在這個主單有"
                
            }
            else
            {

            //var n:Int = 1 //要扣掉自已
            product_temp = "這個產品在下列日期也有記錄\n"
            //抓明細名稱
                product_temp = product_temp + rs.dateR[0] + ":"
                product_temp = product_temp + rs.priceR[0]
                product_temp = product_temp + "元(本次記錄)\n"


                for n in 1...rs.dateR.count-1
                {

                    product_temp = product_temp + rs.dateR[n] + ":"
                    product_temp = product_temp + rs.priceR[n]
                    product_temp = product_temp + "元\n"

                    

                }
                
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
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {

        let mytools = mytool()
        let newcarid = mytools.read_car_default()
        
        if newcarid != defaultcarid
        {
            self.navigationController?.popViewController(animated: true)
            
            return
            
        }
            
        else
        {
            if !isModify //沒修改
            {
                if !isDelete //沒刪除
                {
                let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
                self.navigationItem.title = "\(carinfo[1])明細"
                
                //請選擇資料列編輯要拿掉
                NotificationCenter.default.post(name: Notification.Name(rawValue: "lblmainStatusoff"), object: nil)
                
                

                
        
                
                self.reload_data()
                self.tableView.reloadData()
                    
                }
                else
                {
                //沒修改有刪除
                    //恢復成沒有刪除
                    //delete出現
                    //modify出現
                    //modify變成沒有
                    isDelete = false
                    isModify = false
                    
                    let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
                    self.navigationItem.title = "\(carinfo[1])明細"
                    
                    //請選擇資料列編輯要拿掉
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "lblmainStatusoff"), object: nil)

                    //修改功能回來
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "mod_status"), object: self,userInfo: ["name": 1])

                    
                    
                    //刪除功能回來
                    
                    //tableview
                    
                    tableView.isEditing = false

                    
                    
                    
                
                }
                
            }
            else
            {
            
                self.tableView.reloadData()
                
            }
        }
        
        
        
        
    }

    
    func reload_data()
    {
        
        let m = maintain()
        let m1 = m.read_detail_maintain(maintainID: maintainID)

        detailid = m1.detailid
        price = m1.price
        productid = m1.productid
        memo = m1.memo
        detail_imgreturn = m1.detail_imgarr
        
        totalMoney = count_money(price_i: price)
        
        if detailid.count == 0
        {
            
            detail_item.isEnabled = false
            detail_item.image = nil
        }
        else
        
        {
        
            detail_item.isEnabled = true
            detail_item.image = UIImage(named: "showdetail7575")

        
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if detailid.count == 0
        {
            return 1
        }
        else
        {
            return detailid.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        
        if detailid.count == 0
        {
            cell.textLabel?.text = "按右上角＋新增明細"
            cell.selectionStyle = .none
            cell.textLabel?.textColor = UIColor.blue
            cell.detailTextLabel?.text = ""
            


            
            return cell
        }
        
        if indexPath.row < detailid.count
        {
            
            if (memo[indexPath.row] == "" && detail_imgreturn[indexPath.row] == "")
            {

                cell.textLabel?.text = mytools.read_first_productname(productid: productid[indexPath.row])
                cell.selectionStyle = .none
                cell.imageView?.image = UIImage(named: "")



            }
            
            else if (detail_imgreturn[indexPath.row] == "")
            {
                cell.textLabel?.text = "\(mytools.read_first_productname(productid: productid[indexPath.row]))✪"
                cell.selectionStyle = .default
                cell.imageView?.image = UIImage(named: "")



            }
            else if (memo[indexPath.row] == "")
            {

                cell.textLabel?.text = "\(mytools.read_first_productname(productid: productid[indexPath.row]))"
                //(照)
                cell.imageView?.image = UIImage(named: "came_photo")
                cell.selectionStyle = .default

                
            }
            else
            {
                
                cell.textLabel?.text = "\(mytools.read_first_productname(productid: productid[indexPath.row]))✪"
                //照
                cell.imageView?.image = UIImage(named: "came_photo")

                cell.selectionStyle = .default

                
            }
                
            cell.detailTextLabel?.text = "\(price[indexPath.row])元"
            cell.textLabel?.textColor = UIColor.black

            if isModify
            {
                cell.selectionStyle = .default
            }


            
        }
        else
        {
        
            cell.textLabel?.text = "總計"
            cell.detailTextLabel?.text = "\(totalMoney)元"
            cell.selectionStyle = .none
            cell.textLabel?.textColor = UIColor.black
            cell.imageView?.image = UIImage(named: "")


        
        }
        
        
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && detailid.count > 1
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
        else if indexPath.row == 0 && detailid.count == 0
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
            
        else if indexPath.row == 0 && detailid.count == 1
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
            
        else if indexPath.row == detailid.count
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

    func count_money(price_i:Array<String>) -> Int
    {
        //回傳總金額
        var tmp_money:Float = 0.0
        for i in price_i
        {
            
            tmp_money += Float(i)!

        
        }
        
        return Int(tmp_money)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if indexPath.row == detailid.count //按到總計
        {
            if isClicked
            {
                isClicked = false
                //actionEnd()
            }
            return
        }
        
        if isSelectMode == 1 && !isClicked && (memo[indexPath.row] != "" || detail_imgreturn[indexPath.row] != "") && !isModify //瀏覽模式且沒看過 memo，且有memo，且沒有修改
        {
        
            //顯示memo
            isClicked = true
            showDetail(indexPath.row)
        
        
        }
        else if isSelectMode == 1 && isClicked //看了 memo
        {
        
            isClicked = false
            //actionEnd() //移掉 memo
        
        
        }
        else if isModify
        {
        
            passproductid = productid[indexPath.row]
            performSegue(withIdentifier: "insertDetailMaintain",
                         sender: self)
        
        
        }
        else
        {
        
            return
        
        }
        

            /*
        else if isSelectMode == 1 && memo[indexPath.row] == ""
        {
            
            if isModify
            {
                //修改
                
                performSegue(withIdentifier: "insertDetailMaintain",
                             sender: self)
            }
        
            else
            {
                return
            }
        }
        */
       
        
        
        
        
        
    }
 
    func showDetail(_ indexrow: Int)
    {
        
        /*
        var screenx: Int
        var screeny: Int
        
        screenx = Int(UIScreen.main.bounds.width)
        screeny = Int(UIScreen.main.bounds.height)
        
        hudView.viewWithTag(1)
        
         hudView.frame = CGRect(x: screenx/2 - 90 , y: screeny/3 - 70, width: 200, height: 100)
        
            hudView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            hudView.clipsToBounds = true
            hudView.layer.cornerRadius = 10.0
            hudView.tag = 1
            captionLabel = UITextView(frame: CGRect(x: 15, y: 10, width: 185, height: 80))
            captionLabel.backgroundColor = UIColor.clear
            captionLabel.textColor = UIColor.white
            captionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            captionLabel.textAlignment = .left
            captionLabel.text = memo[indexrow]
            captionLabel.isEditable = false
        
            hudView.addSubview(captionLabel)

            view.addSubview(hudView)
            */
            
            //detail 和圖都有
            //傳明細和圖給下個 container view

            NotificationCenter.default.post(name: Notification.Name(rawValue: "change_detail_image"), object: self,userInfo: ["detail": memo[indexrow],"detailimage":detail_imgreturn[indexrow]])

            
            
    
        

    }
    
    /*
    func actionEnd()
    {
        //2.0.3pro
            let tmpimg: UIView? = (view.viewWithTag(1))
            if tmpimg != nil
            {
                tmpimg?.removeFromSuperview()
            }

        captionLabel.text = ""
        
    }
*/
    
    @IBAction func add_maintaindetail(_ sender: UIBarButtonItem)
    {
    
    
        isDelete = false
        isModify = false
        tableView.isEditing = false
        
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "insertDetailMaintain",
                     sender: self)

    
    }
    
    @IBAction func show_detail(_ sender: UIBarButtonItem)
    {
        
        
        performSegue(withIdentifier: "showdetailpopup",
                     sender: self)
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        //傳 maintain_id過去
        if segue.identifier == "insertDetailMaintain"
        {
            
            if let toViewController = segue.destination as? insertDetailTableViewController
            {
                if isModify
                {

                    toViewController.maintainid = self.maintainID
                    toViewController.productid = self.passproductid
                    toViewController.oldproductid = self.passproductid
                    toViewController.getmethod = "modify"

                
                }
                else
                {
                
                    toViewController.maintainid = self.maintainID
                    toViewController.getmethod = "add"

                
                
                }

            }
            
                
        }
        
        
        if segue.identifier == "showdetailpopup"
        {
            let vc = segue.destination
            let fullScreenSize = UIScreen.main.bounds.size
            

            vc.preferredContentSize = CGSize(width: fullScreenSize.width, height: 150)
            let controller = vc.popoverPresentationController
            if controller != nil
            {
                controller?.delegate = self
                
            }
            
            if let toViewController = segue.destination as? detail_popviewTableViewController
            {
            
                toViewController.is_modified = isModify
                toViewController.is_deleted = isDelete
            
            }
            
        
        }

        
        
    }
    
    @IBAction func click_me(_ sender: Any)
    {

        self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @objc func del_me()
    {
    
        if isDelete //原本按了 delete，要取消
        {
            tableView.isEditing = false
            isDelete = false
            
            
            
        }
        else //原本沒按 delete ，要開始
        {
            tableView.isEditing = true
            //換成 cancel圖
            
            isDelete = true

            
        }
    
    }

    @objc func modify_me()
    {
        
        // 修改
        isModify = true
        tableView.reloadData()
        
        

    }
    
    @objc func cancelmodify()
    {
        
        isModify = false
        tableView.reloadData()

    
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "刪除"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        //總計不要顯示 delete
        
        if indexPath.row == detailid.count
        {

            return false
            
        }
        
        return true
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        //刪除
        let ms = maintain()
        
        _ = ms.delete_maintain_detail(MaintainID: maintainID, ProductID: productid[indexPath.row],img_picarr: self.detail_imgreturn[indexPath.row]) //丟明細圖片陣列進去
        
        reload_data()
        
        //秀圖
        NotificationCenter.default.post(name: Notification.Name(rawValue: "change_detail_image"), object: self,userInfo: ["detail": "","detailimage":""])

        
        isDelete = false
        
        tableView.isEditing = false
        tableView.reloadData()
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }

    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: true)

        
        
    }


    
}
