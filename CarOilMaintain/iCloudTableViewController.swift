//
//  iCloudTableViewController.swift
//  CarOilMaintain
//
//  Created by 楊先民 on 2017/8/15.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class iCloudTableViewController: myBaseTableViewController
{
    
    var iCloudFiles = [String]()
    
    @IBOutlet weak var btn_backup: UIButton!
    
    @IBOutlet weak var Btn_restore: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let image = UIImage(named: "backup.png")?.withRenderingMode(.alwaysTemplate)
        
        let image1 = UIImage(named: "restore.png")?.withRenderingMode(.alwaysTemplate)
        
        btn_backup.setImage(image, for: .normal)
        btn_backup.tintColor = UIColor.white

        Btn_restore.setImage(image1, for: .normal)
        Btn_restore.tintColor = UIColor.white
        
        let cloud1 = CloudDataManager()
        
        if !cloud1.isCloudEnabled()
        {
            
            let alert = UIAlertController(title: "訊息", message: "請先設定 iCloud Drive", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: { (UIAlertAction)in
                
                self.navigationController?.popViewController(animated: true)

                
                
            }
            )
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)
            
            

            
            return

            
        }
     
        
        
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return iCloudFiles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)

        cell.textLabel?.text = iCloudFiles[indexPath.row]
        // Configure the cell...

        return cell
    }
    

   

    
    
    
    @IBAction func back(_ sender: UIBarButtonItem)
    {
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0 && iCloudFiles.count > 1
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
            
        else if indexPath.row == 0 && iCloudFiles.count == 1
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
            
        else if indexPath.row == iCloudFiles.count - 1
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

    
    
    @IBAction func backup(_ sender: UIButton)
    {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "資料庫備份到 iCloud", preferredStyle: .alert)
        
        let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
            
            let cloud1 = CloudDataManager()
            cloud1.copyFileToCloud()
            
            let alert = UIAlertController(title: "訊息", message: "資料備份完成", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)
            
            
            
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        
        actionSheetController.addAction(nextAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
        

        
        
        
        
    }
    
    
    @IBAction func restore(_ sender: UIButton)
    {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "訊息", message: "資料庫從 iCloud回復到手機", preferredStyle: .alert)
        
        let nextAction: UIAlertAction = UIAlertAction(title: "確定", style: .default) { action -> Void in
            
            let cloud1 = CloudDataManager()
            cloud1.copyFileToLocal()
            
            let mytools = mytool()
            
            mytools.save_car_default(defaultid: "0")
            
            
            let alert = UIAlertController(title: "訊息", message: "資料回復完成", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion:nil)

            
            
            
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        
        actionSheetController.addAction(nextAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)

        
    }

    
    @IBAction func right(_ sender: UISwipeGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    @IBAction func left(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
}
