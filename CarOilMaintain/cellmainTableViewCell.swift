//
//  cellmainTableViewCell.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class cellmainTableViewCell: UITableViewCell
{

    
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblkm: UILabel!
    
    @IBOutlet weak var lblmaintype: UILabel!
    
    @IBOutlet weak var lblproductname: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    

}
