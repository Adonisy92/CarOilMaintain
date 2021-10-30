//
//  StatOilTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/11.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class StatOilTableViewController: myBaseTableViewController
{

    var myinputtype:Int = 0
    var oilStatisticrow = [String]()
    @IBOutlet weak var cell0: UILabel!
    @IBOutlet weak var cell1: UILabel!
    @IBOutlet weak var cell2: UILabel!
    @IBOutlet weak var cell3: UILabel!
    
    var showrows:Int = 8 //預設顯示8列


    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(StatOilTableViewController.reload_data), name: NSNotification.Name(rawValue: "reloaddata"), object:nil)



    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showrows
        
    }



    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        
        cell.setupDisclosureIndicator()
        
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
            
        else if indexPath.row == 7 && self.showrows == 8
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
        
        else if indexPath.row == 8 && self.showrows == 9
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
        
        switch indexPath.row
        {
        case 0,1,2,3,7:
            //每公升跑
            myinputtype = indexPath.row
            performSegue(withIdentifier: "showchart",
                         sender: self)

            
        case 4,5,6:
            
            myinputtype = indexPath.row
            performSegue(withIdentifier: "oilbyyear",
                         sender: self)

        case 8:
            
            performSegue(withIdentifier: "comparecar",
                         sender: self)
            
        default:
            break
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        //傳 maintain_id過去
        if segue.identifier == "showchart"
        {
            
            if let toViewController = segue.destination as? ShowChartTableViewController
            {
                    toViewController.inputtype = myinputtype
            }
            
        }
        if segue.identifier == "oilbyyear"
        {

            if let toViewController = segue.destination as? oilByYearTableViewController
            {
                toViewController.inputtype = myinputtype
            }
        
        
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
     
        
        reload_data()
        
    }
    
    @objc func reload_data()
    {
        
        let st = mystatistic()
        
        oilStatisticrow = st.read_statistic_oil()
        
        cell0.text = "\(oilStatisticrow[0])公里"
        cell1.text = "\(oilStatisticrow[1])公升"
        cell2.text = "\(oilStatisticrow[2])元"
        cell3.text = "\(oilStatisticrow[3])元"
        
        
        //先取出 deviceid
         let mytools = mytool()
         let myOilDeviceID = mytools.getOilDeviceID()

         if myOilDeviceID == "0"
         {
             //沒上傳不給看
             self.showrows = 8
         }
         else
         {
             
             self.showrows = 9
             
         }

        
        tableView.reloadData()

        
    }
    

}


//設定往右的那個 icon，這個無法變顏色
extension UITableViewCell {
    func setupDisclosureIndicator() {
        accessoryType = .disclosureIndicator
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "morethan")
        accessoryView = imgView
    }
}

