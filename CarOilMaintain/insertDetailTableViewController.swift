//
//  insertDetailTableViewController.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/13.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class insertDetailTableViewController: myBaseTableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    var maintainid:String = ""
    var getmethod:String = "add" //預設是新增
    var productid:String = "" //輸入的產品編號
    var oldproductid:String = "1" //傳入的產品編號

    var productprice:String = "" //輸入的產品價格
    //var productmemo:String = "" //備註事項（最後要存的）
    var productCategoryID:String = "" //分類編號

    var defaultcarid:String = ""
    var tFieldPrice = UITextField() //價格
    var tFieldCategory = UITextField() //分類名稱
    var tFieldProductName = UITextField() //產品名稱
    var check_categoryName:String = ""
    var check_productName:String = ""
    
    //產品
    
    var PickerProducts:UIPickerView = UIPickerView()

    var carProductCategory = [String]()
    var carProductCategoryID = [String]()
    var carProducts = [String]()
    var carProductsID = [String]()
    
    @IBOutlet weak var save_item: UIBarButtonItem!
    
    
    @IBOutlet weak var cancel_img: UIButton!
    
    
    //滾輪
    
    var pic_choose:UIPickerView = UIPickerView()

    
    var defaultphoto:Int = 0// 預設是拍照

    let chooseitem = ["拍照","圖片庫"]
    
    var savechange:Int = 0 //預設沒拍照片
    
    var detail_img:String = "" //圖檔名稱

    var detail_imgwithFolder:String = "" //圖檔路徑
    
    var old_detail_imgwithFolder:String = "" //舊圖檔路徑


    var paths = [String]()
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask


    
    
    @IBOutlet weak var goods_pic: UIImageView!
    
    
    @IBOutlet weak var lbl_productName: UILabel!

    @IBOutlet weak var lbl_productPrice: UILabel!
    @IBOutlet weak var lbl_productMemo: UITextView!
    
    
    @IBAction func show_pic(_ sender: Any)
    {
        
        

        //產品
        let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "請選擇上傳照片方式", preferredStyle: .alert)
        
        
        pic_choose = UIPickerView(frame: CGRect(x:0.0, y:0.0, width:250, height:150))
        pic_choose.delegate =  self;
        pic_choose.dataSource = self;
    

        alert.view.addSubview(self.pic_choose)

        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            //按下確定
           

            let imagePicker = UIImagePickerController()
            
            
            switch self.defaultphoto
            {
            case 0:
                imagePicker.sourceType = .camera
                
            case 1:
                
                imagePicker.sourceType = .photoLibrary
                
                
            default:
                imagePicker.sourceType = .photoLibrary
                
            }
            
            imagePicker.delegate = self
        
            imagePicker.allowsEditing = false
            
            
            
            self.present(imagePicker, animated: true, completion: nil)
            
            self.defaultphoto = 0
            
        }))
        
        //pic_choose.isHidden = true

        
        self.present(alert, animated: true, completion:nil)

        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        
 

        goods_pic.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue) ] as? UIImage

        //把照片秀出來

        self.savechange = 1 //改了，代表有圖，存的時後要順便存圖和位置
        
        self.cancel_img.isHidden = false

        let uuid = UUID().uuidString //圖檔用 uuid產生
        
        self.detail_img = "deail" + uuid + ".jpg"
        
        let mytools = mytool()
        mytools.create_detail_folder()

        self.detail_imgwithFolder = "Detail_image/" + self.detail_img

        //self.save_detail_img(imgfold: self.detail_img)
        
        
        
        picker.dismiss(animated: true, completion: nil)

        
    }
    


    func save_detail_img(imgfold:String) //儲存圖檔
    {
        
        
        if (imgfold == "")
        {
            
            return
            
        }
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent(imgfold)
        //把圖片存在APP裡
        let data = self.goods_pic.image!.jpegData(compressionQuality: 0.1)
        try! data?.write(to: url!)
        //self.dismiss(animated:true, completion: nil)

        
        
    }


    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let mytools = mytool()
        defaultcarid = mytools.read_car_default()
        
        if getmethod != "add"
        {
            let ms = mytools.select_category_name(productid: oldproductid)
            tFieldCategory.text = ms.categoryname
            check_categoryName = ms.categoryname //先載入
        }
            
        if getmethod == "add"
        {
            self.navigationItem.title = "新增維修明細"
            self.save_item.isEnabled = false
            self.cancel_img.isHidden = true
        }
        else //修改
        {
        
            self.navigationItem.title = "修改維修明細"
            self.save_item.isEnabled = true
            let ms = maintain()
            let rs = ms.read_detail_maintain(maintainID: maintainid, productid: oldproductid)

            lbl_productPrice.text = "\(rs.price)元"
            productprice = rs.price
            lbl_productMemo.text = rs.memo
            self.detail_imgwithFolder = rs.image_path
            self.old_detail_imgwithFolder = rs.image_path
            
            if self.old_detail_imgwithFolder.count > 0
            {
                
                self.cancel_img.isHidden = false
                
            }
            else
            {
                
                self.cancel_img.isHidden = true
                
            }

            
            lbl_productName.text = mytools.read_first_productname(productid: oldproductid)
            check_productName = lbl_productName.text! //產品載入
            
            
            paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first
            {
                
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(self.detail_imgwithFolder)
                
                let image    = UIImage(contentsOfFile: imageURL.path)


                goods_pic.image = image
            }
                
            
            
        }
        
        lbl_productMemo.tintColor = UIColor.black //游標變成黑色
        


        
    }
    
    


    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        
        //有多少項
        
        if (pickerView == PickerProducts)
        {
            return 2
        }
        else
        {
            return 1
            }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {

        if (pickerView == PickerProducts)
            
        {
        
        if component == 0
        {
            
            return carProductCategoryID.count
            
        }
        
        
        return carProducts.count

            
        }
        else
        {
            
            return chooseitem.count
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if (pickerView == PickerProducts)
        {
        
        if component == 0
        {
            return carProductCategory[row]
        }
        
        return carProducts[row]
        }
        else
        {
            
            
            return chooseitem[row]
            
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if (pickerView == PickerProducts)
        {
            if component == 0
            {
        
                self.tFieldCategory.text = carProductCategory[row]
                check_categoryName = carProductCategory[row]
                //產品內容改變
                let mytools = mytool()
            
                let rs = mytools.read_product_name(categoryid: carProductCategoryID[row])
            
                carProducts = rs.pname
                carProductsID = rs.pid
            
                if carProducts.count != 0
                {
                    self.tFieldProductName.text = carProducts[0]
                    check_productName = carProducts[0]
                }
                else
                {
            
                    self.tFieldProductName.text = "無產品名稱"
                    check_productName = "無產品名稱"
            
                }
                PickerProducts.reloadComponent(1)
                PickerProducts.selectRow(0, inComponent: 1, animated: true)

                return
            
        
            }
        
            else
            {
        
            
                self.tFieldProductName.text = carProducts[row]
                check_productName = carProducts[row]

        
        
            }
        }
        else
        {
            
            defaultphoto = row

        }
        
        
        
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        

        if indexPath.row == 0
        {
            //產品
            let alert = UIAlertController(title:"\n\n\n\n\n\n", message: "選擇品項或自行輸入", preferredStyle: .alert)
            
            reload_component()

            alert.view.addSubview(self.PickerProducts)

            
            alert.addTextField(configurationHandler: self.configurationTextFieldCategory(_:))
            alert.addTextField(configurationHandler: self.configurationTextFieldProducts(_:))
            
            
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //按下確定
               
                self.check_categoryName = self.tFieldCategory.text!
                self.lbl_productName.text = self.tFieldProductName.text
                self.check_productName = self.tFieldProductName.text!
                self.reload_status()

                
                
            }))
            
            self.present(alert, animated: true, completion:nil)
            
            
            
            return

            

        }


        if indexPath.row == 1
        {
            //價格
            let alert = UIAlertController(title:"", message: "輸入價格", preferredStyle: .alert)
            alert.addTextField(configurationHandler: self.configurationTextFieldPrice(_:))
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
                //按下確定
                
                //檢查
                var tmp_price = CFloat(self.tFieldPrice.text!)
                
                if tmp_price == nil
                {
                    
                    tmp_price = 0
                    
                }
                
                let tmpprice = String(format: "%.f", tmp_price!)
                
                self.productprice = tmpprice
                self.lbl_productPrice.text = "\(self.productprice)元"
                //self.isModified = true
                
                self.reload_status()
                
            }))
            
            self.present(alert, animated: true, completion:nil)
            
            
            return
        }
        
        
    }
    
    func configurationTextFieldPrice(_ textField: UITextField!)
    {

        tFieldPrice = textField
        tFieldPrice.clearButtonMode = .whileEditing
        tFieldPrice.keyboardType = .numberPad
        tFieldPrice.text = productprice
        tFieldPrice.delegate = self
        
        
    }

    func configurationTextFieldCategory(_ textField: UITextField!)
    {
        
        tFieldCategory = textField
        tFieldCategory.clearButtonMode = .whileEditing
        tFieldCategory.keyboardType = .default
        //如果是修改，要找到原來的分類id
        if getmethod == "add"
        {
            tFieldCategory.text = carProductCategory[0]
            //check_categoryName = carProductCategory[0]
            self.productCategoryID = carProductCategoryID[0]
            

        }
        else
        {

            //利用productid找分類名稱
            
            let mytools = mytool()
            let ms = mytools.select_category_name(productid: oldproductid)
            
            tFieldCategory.text = ms.categoryname
            check_categoryName = ms.categoryname
            productCategoryID = ms.categoryid
            
        }
        
        tFieldCategory.delegate = self
        
        
        
    }

    
    func configurationTextFieldProducts(_ textField: UITextField!)
    {
        
        tFieldProductName = textField
        tFieldProductName.clearButtonMode = .whileEditing
        tFieldProductName.keyboardType = .default
        //如果是修改
        if getmethod == "add"
        {
            tFieldProductName.text = carProducts[0]
            //check_productName = carProducts[0]

        }
        else
        {
        
            let mytools = mytool()
            tFieldProductName.text = mytools.read_first_productname(productid: oldproductid)

            check_productName = mytools.read_first_productname(productid: oldproductid)
            
            
        
        }
        tFieldProductName.delegate = self
        
        self.productid = carProductsID[0]
        
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let mytools = mytool()
        let newcarid = mytools.read_car_default()
        
        if newcarid != defaultcarid
        {
            self.navigationController?.popViewController(animated: true)
            
            return
            
        }

        
    }

    func reload_status()
    {
    
        if productid == "" || productprice == ""
        {
            
            save_item.isEnabled = false
            
        }
        else
        {
        
            save_item.isEnabled = true
        
        }
    
    }
    
    @IBAction func save_detail(_ sender: UIBarButtonItem)
    {
        
////////是否有新產品或分類開始 /////////////////////////////////////////

        
        var newCategoryid:String = ""
        //新增
        //將新分類與新品項加入
        
        //加入明細表單
        if  getmethod == "add"
        {
            
            let category_index = self.carProductCategory.firstIndex(of: self.tFieldCategory.text!)
            
            
            
            if category_index == nil
            {
                let m = maintain()
                //新增分類並將產品分類id傳回
                newCategoryid = m.insert_product_category(categoryName: self.tFieldCategory.text!)
                //產品也要新增
                self.productid = m.insert_products(categoryid: newCategoryid, productname: tFieldProductName.text!)
                
                //更新 orders_num
                _ = m.update_product_orders_nums(input_productid: self.productid)

                
                //取回最新分類並且把 orders_num值修改
                let new_categoryid = m.read_new_categoryid()
                _ = m.update_category_orders_nums(input_categoryid: new_categoryid)

                
                
            }
            else
            {
                
                //原來的分類 id
                newCategoryid = carProductCategoryID[category_index!]

                let product_index = self.carProducts.firstIndex(of: self.lbl_productName.text!)
                
                
                if product_index == nil
                {
                    //傳分類 id與產品名稱進去，回傳productid
                    let m = maintain()
                    //self.productid = m.insert_products(categoryid: newCategoryid, productname: check_productName)
                    
                    self.productid = m.insert_products(categoryid: newCategoryid, productname: lbl_productName.text!)
                    
                    //更新 orders_num
                    _ = m.update_product_orders_nums(input_productid: self.productid)

                    
                    
                    
                }
                else
                {
                    
                    self.productid = carProductsID[product_index!]
                    
                }
                
                
            }

            
            
        }
        else //修改
        {
            reload_db()
            
            let category_index = self.carProductCategory.firstIndex(of: check_categoryName)
            
            if category_index == nil
            {
                let m = maintain()
                //新增分類並將產品分類id傳回
                newCategoryid = m.insert_product_category(categoryName: check_categoryName)
                //產品也要新增
                self.productid = m.insert_products(categoryid: newCategoryid, productname: check_productName)
                
                //取回最新分類並且把 orders_num值修改
                let new_categoryid = m.read_new_categoryid()
                _ = m.update_category_orders_nums(input_categoryid: new_categoryid)

                
                
            }
            else
            {
                
                //原來的分類 id
                newCategoryid = carProductCategoryID[category_index!]
                
                let product_index = self.carProducts.firstIndex(of: check_productName)
                
                
                if product_index == nil
                {
                    //傳分類 id與產品名稱進去，回傳productid
                    let m = maintain()
                    //self.productid = m.insert_products(categoryid: newCategoryid, productname: check_productName)
                    
                    self.productid = m.insert_products(categoryid: newCategoryid, productname: check_productName)
                    
                    
                }
                else
                {
                    
                    self.productid = carProductsID[product_index!]
                    
                }
                
                
            }

        
        
        
        
        }
        
/////////////////是否是新產品或分類結束／／／／／／／／／／／／／／／／／／／／／
        

        if getmethod == "add"
        {
        


            //加入 detail
            
            let m = maintain()
            let rv = m.insert_maintain_details(MaintainID: maintainid, ProductID: self.productid, price: self.productprice, memo: lbl_productMemo.text,detail_img: detail_imgwithFolder)
            
            if rv == 19
            {
                let alert = UIAlertController(title: "訊息", message: "同筆明細出現相同產品，明細未新增！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default , handler: nil))
                
                self.present(alert, animated: true, completion: nil)


            }
            else
            {
            
                self.save_detail_img(imgfold: detail_imgwithFolder)
                self.navigationController?.popViewController(animated: true)
            }
            
            
            
            
        
        }
        else
        {
            //修改
            
            //加入 detail
            
            let m = maintain()
            let rv = m.update_maintain_details(MaintainID: maintainid, ProductID: productid, price: productprice, memo: lbl_productMemo.text!, oldProductID: oldproductid,img_path: detail_imgwithFolder)
            
            
            if rv == 19
            {
                let alert = UIAlertController(title: "訊息", message: "同筆明細出現相同產品，明細未修改！", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default , handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
            else
            {
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "cancelmodify"), object: nil)

                //刪舊檔
                
                let maintains = maintain()
                maintains.del_img_fromDevice(imgfold: old_detail_imgwithFolder)
                
                //存新檔
                
                self.save_detail_img(imgfold: detail_imgwithFolder)
                
                //把新圖放上去
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "change_detail_image"), object: self,userInfo: ["detail": lbl_productMemo.text!,"detailimage":detail_imgwithFolder])

                
                
                self.navigationController?.popViewController(animated: true)
            }
            
        
        
        }
        
        
        
        
        
        
        
        
    }
    
     
    
    @IBAction func back_conn(_ sender: UIBarButtonItem)
    {
        

        self.navigationController?.popViewController(animated: true)

        
        
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
    
    func reload_db()
    {
        
        let mytools = mytool()
        let rs = mytools.read_product_category_name()
        
        carProductCategoryID = rs.pid
        carProductCategory = rs.pname
        
        let rs1 = mytools.read_product_name()
        
        carProductsID = rs1.pid
        carProducts = rs1.pname
        
    }
    
    
    @IBAction func del_img_click(_ sender: Any)
    {
        
        self.detail_imgwithFolder = ""
        goods_pic.image = nil
        self.cancel_img.isHidden = true
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
