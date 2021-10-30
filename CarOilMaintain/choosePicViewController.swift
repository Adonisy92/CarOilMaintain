//
//  choosePicViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/30.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class choosePicViewController: myBaseViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    @IBOutlet weak var picChoosePhoto: UIPickerView!
    
    
    @IBOutlet weak var back_item: UIBarButtonItem!

    
    @IBOutlet weak var carimg: UIImageView!
    
    
    var defaultphoto:Int = 0// 預設是拍照

    let chooseitem = ["拍照","圖片庫","膠捲"]
    
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
    var paths  = [String]()
    
    
    var takeimage = UIImage()
    
  
    //var mybtn = UIBarButtonItem()
    
    var defaultcarid:String = "0"
    
    var savechange:Int = 0 //預設沒選照片
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let mytools = mytool()
        
        defaultcarid = mytools.read_car_default()
        
        picChoosePhoto.dataSource = self
        picChoosePhoto.delegate = self
        
        
        paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
       

        if let dirPath          = paths.first
        {
            
            //let screenSize: CGRect = UIScreen.main.bounds
            //print(screenSize.width)
            //print(screenSize.height)
            
            var mycarname:String = ""
            
            if defaultcarid == "0"
            {
                mycarname = "MyCarImage.jpg"
            }
            else
            {
            
                mycarname = "MyCarImage\(defaultcarid).jpg"
            }
            
            
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(mycarname)
            
            
            let fileManager = FileManager.default
            
            var image = UIImage(named: "noimage.png")
            
            // Check if file exists
            if fileManager.fileExists(atPath: imageURL.path)
            {

                //如果檔案有存在的話
                image    = UIImage(contentsOfFile: imageURL.path)!
            }
            // Do whatever you want with the image
            
            /*
            if let x = image?.size.width,
                let y = image?.size.height
            {
                
                if x > y //橫的
                {
                    
                    carimg.frame = CGRect(x: 10, y: 110, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)
                    
                }
                else if x == y //正方
                {
                    carimg.frame = CGRect(x: 20, y: 110, width: screenSize.width - 50, height: screenSize.width - 50 )
                    
                }
                else //直的
                {
                    carimg.frame = CGRect(x: 50, y: 110, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)
                    
                }
                
            }
             */
            
            carimg.contentMode = .scaleAspectFit
            carimg.image = image
            
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return chooseitem.count
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return chooseitem[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
     
        defaultphoto = row
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = chooseitem[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }

    
    
    @IBAction func choose_pic(sender: UIBarButtonItem)
    {
        

        
            let imagePicker = UIImagePickerController()
            
            
            switch defaultphoto
            {
            case 0:
                imagePicker.sourceType = .camera
                
            case 1:
                
                imagePicker.sourceType = .photoLibrary
                
            case 2:
                
                imagePicker.sourceType = .savedPhotosAlbum
                
            default:
                imagePicker.sourceType = .photoLibrary
                
            }
            
            imagePicker.delegate = self
        
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)


     

        
        
        
    }
    
    @IBAction func cancel_ok(sender: UIBarButtonItem)
    {
        
        //display alert
        
        if savechange == 0
        {
            self.navigationController?.popViewController(animated: true)

        }
        
        else
        {
            displayAlert(title_i: "訊息", messagecontent: "儲存圖片？")
        }

        
        
    }
    
    func displayAlert(title_i:String,messagecontent:String)
    {
        
        //let alert = UIAlertController(title: title_i, message: "\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        let alert = UIAlertController(title:title_i, message: messagecontent, preferredStyle: UIAlertController.Style.alert)
        
        
        
        
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{ (UIAlertAction)in
         
            self.navigationController?.popViewController(animated: true)

            
        }
            ))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{ (UIAlertAction)in
            //按下確定
            //存圖
            
            //取得路徑
            let fileManager = FileManager.default
            let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let docUrl = docUrls.first
            //檔名
            
            var mycarname:String = ""
            
            if self.defaultcarid == "0"
            {
                mycarname = "MyCarImage.jpg"
            }
            else
            {
                
                mycarname = "MyCarImage\(self.defaultcarid).jpg"
            }
            

            
            
            let url = docUrl?.appendingPathComponent(mycarname)
            //把圖片存在APP裡
            let data = self.carimg.image!.jpegData(compressionQuality: 0.9)
            try! data?.write(to: url!)
            //self.dismiss(animated:true, completion: nil)
            self.navigationController?.popViewController(animated: true)

            
            
        }))
        self.present(alert, animated: true, completion:nil)
        
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        self.savechange = 1 //改了
        
        //self.navigationItem.leftBarButtonItem?.title = "儲存"
        back_item.image = UIImage(named: "save7575")
        
        //let screenSize: CGRect = UIScreen.main.bounds


        carimg.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue) ] as? UIImage
        //bug

        
        picker.dismiss(animated: true, completion: nil)

        
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
