//
//  db_reading.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/6/20.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import Foundation
import UIKit

class mytool
{
    
    
    
    func read_oil_upload_default() -> String
    {
        //載入是否有開 油耗上傳

        let defaults = UserDefaults.standard

        if let oil_upload = defaults.string(forKey: "oil_uploaddefault")
        {
            return oil_upload
        }
        
        //找不到,塞 0然後回傳
        
        save_oil_upload(defaultid: "0")
        
        return "0"
        
    }
    
    func save_oil_upload(defaultid:String)
    {
        
        //存入
        let defaults = UserDefaults.standard
        
        defaults.set(defaultid, forKey: "oil_uploaddefault")
        defaults.synchronize()
     
        return
    }
    
    
    
    
    
    func change_product_order(productid:Array<String>)
    {
     //改分類順序
        var n:Int = 0
        productid.forEach{
         
            c_id in
            
            var db:OpaquePointer? = nil //資料庫
            var statement:OpaquePointer?=nil //資料記錄
            var sql:String = "" //SQL指令
            
            let fm:FileManager = FileManager()
            
            var src:String = ""
            var dst:String = ""
            

                
                src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
                
                dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
            
            if !fm.fileExists(atPath: dst) {
                do {
                    try
                        fm.copyItem(atPath: src, toPath: dst)
                } catch _ {
                }
            }
            
            
            if sqlite3_open(dst, &db) != SQLITE_OK
            {
                
                print("無法開啟資料庫！")
                return
            }
            
            
            //修改資料庫
            sql = "update Product set orders_num =\(n) where ProductID=\(c_id)"
            
            
            statement = nil
            
            sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

            
            sqlite3_finalize(statement)
            sqlite3_close(db)

            
            
            
            
            n+=1
            
        }
        
        
        
        
        
    }
    
    func change_category_order(categoryid:Array<String>)
    {
     //改分類順序
        var n:Int = 0
        categoryid.forEach{
         
            c_id in
            
            var db:OpaquePointer? = nil //資料庫
            var statement:OpaquePointer?=nil //資料記錄
            var sql:String = "" //SQL指令
            
            let fm:FileManager = FileManager()
            
            var src:String = ""
            var dst:String = ""
            

                
                src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
                
                dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
            
            if !fm.fileExists(atPath: dst) {
                do {
                    try
                        fm.copyItem(atPath: src, toPath: dst)
                } catch _ {
                }
            }
            
            
            if sqlite3_open(dst, &db) != SQLITE_OK
            {
                
                print("無法開啟資料庫！")
                return
            }
            
            
            //修改資料庫
            sql = "update Category set orders_num =\(n) where CategoryID=\(c_id)"
            
            
            statement = nil
            
            sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

            
            sqlite3_finalize(statement)
            sqlite3_close(db)

            
            
            
            
            n+=1
            
        }
        
        
        
        
        
    }
    
    func create_detail_folder() //建立一個目錄
    {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("Detail_image")
        if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }

    }
    
    
    func update_maintain_menu(repaireinfo:Array<String>,repaireid:Array<String>)
    {
        //待改
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()

        //沒有 carid欄位，要加，並且塞值
        if check_carid_column() != true
        {
            
            _ = add_repaireTable_column_carid() //加一個欄位
            _ = insert_car_repaire_column_by_carid() //塞值
            _ = add_maintain_picurl_defaultcar() //pic欄位
            _ = add_maintain_picurl_new_car()
            
        }
        
        

        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var sql2:String = "" //SQL指令
        var sql3:String = "" //SQL指令
        
        var sql4:String = "" //SQL指令
       
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        sql = "update RepaireTable set repairename = '\(repaireinfo[0])' where id = \(repaireid[0]) and carid =\(defaultcarid);"
        sql2 = "update RepaireTable set repairename = '\(repaireinfo[1])' where id = \(repaireid[1]) and carid =\(defaultcarid);"
        sql3 = "update RepaireTable set repairename = '\(repaireinfo[2])' where id = \(repaireid[2]) and carid =\(defaultcarid);"
        
        sql4 = sql+sql2+sql3
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            
            return
            
        }
        
        
        
        
        statement = nil
        
        sqlite3_exec(db, (sql4 as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
        
    }

    
    
    func read_maintain_id() ->(Array<String>)
     {
     //取得這輛車的3個 id資訊
     
     var db:OpaquePointer? = nil //資料庫
     var statement:OpaquePointer?=nil //資料記錄
     var sql:String = "" //SQL指令
     var repaireInfo = [String]()//陣列
     
     
     let fm:FileManager = FileManager()
     
     let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
     let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
     
     
     //要抓 defaultcarid
     //待做
     let mytools = mytool()
     let defaultcarid = mytools.read_car_default()

     //沒有 carid欄位，要加，並且塞值
     if check_carid_column() != true
     {
         
         _ = add_repaireTable_column_carid() //加一個欄位
         _ = insert_car_repaire_column_by_carid() //塞值
         _ = add_maintain_picurl_defaultcar() //pic欄位
         _ = add_maintain_picurl_new_car()

         
     }
    
     
     
     sql = "select id from RepaireTable where carid =\(defaultcarid)"
     
     
     if !fm.fileExists(atPath: dst) {
         do {
             try
                 fm.copyItem(atPath: src, toPath: dst)
         } catch _ {
         }
     }
     
     
     if sqlite3_open(dst, &db) != SQLITE_OK
     {
         
         repaireInfo.append("1")
         repaireInfo.append("2")
         repaireInfo.append("3")
         return repaireInfo
         
     }
     
     
     
     
     statement = nil
     if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
     {
         
         repaireInfo.append("1")
         repaireInfo.append("2")
         repaireInfo.append("3")
         return repaireInfo
         
     }
     //逐筆讀取資料列
     
     while sqlite3_step(statement) == SQLITE_ROW
     {
         
         repaireInfo.append(String(sqlite3_column_int(statement, 0)))

     }
     sqlite3_finalize(statement)
     sqlite3_close(db)
     
     return (repaireInfo)
     
     
     
     }
  
    
    
    func check_carid_column() ->Bool
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        var returnvalue:Bool = false
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        //讀取資料庫

        sql = "SELECT EXISTS (SELECT * FROM sqlite_master WHERE tbl_name = 'RepaireTable' AND sql LIKE '%carid%');"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return false
        }
       
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let returnnum:Int = (Int(sqlite3_column_int(statement, 0))) //數字1代表有這個欄位 0代表沒有
            if returnnum == 1
            {
            
                returnvalue = true
            
            }
            else
            {
            
                returnvalue = false
            
            }
        }
        else
        {
        
        
            returnvalue = false
        
        
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue


    }

    
    func check_cateogyr_orders_num() ->Bool
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        var returnvalue:Bool = false
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        //讀取資料庫

        sql = "SELECT EXISTS (SELECT * FROM sqlite_master WHERE tbl_name = 'Category' AND sql LIKE '%orders_num%');"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return false
        }
       
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let returnnum:Int = (Int(sqlite3_column_int(statement, 0))) //數字1代表有這個欄位 0代表沒有
            if returnnum == 1
            {
            
                returnvalue = true
            
            }
            else
            {
            
                returnvalue = false
            
            }
        }
        else
        {
        
        
            returnvalue = false
        
        
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue


    }
    
    
    
    func check_products_orders_num() ->Bool
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        var returnvalue:Bool = false
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        //讀取資料庫

        sql = "SELECT EXISTS (SELECT * FROM sqlite_master WHERE tbl_name = 'Product' AND sql LIKE '%orders_num%');"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return false
        }
       
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let returnnum:Int = (Int(sqlite3_column_int(statement, 0))) //數字1代表有這個欄位 0代表沒有
            if returnnum == 1
            {
            
                returnvalue = true
            
            }
            else
            {
            
                returnvalue = false
            
            }
        }
        else
        {
        
        
            returnvalue = false
        
        
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue


    }
    
    
    
    
    func read_car_nickname() -> (String) //讀第一台車子的 nickname回來
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return "發生問題"
            
        }
        
        
        //讀取資料庫
        //1.3
        sql = "select carNickName from car"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return ("發生問題")
        }
        //逐筆讀取資料列
        
        var carNickName:String = ""
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            if sqlite3_column_text(statement, 0) != nil
            {

                carNickName = String(cString: sqlite3_column_text(statement, 0)) //新用法
                
                
            }

            else
            {
            
            
                carNickName = "未命名"
            
            
            }
        }
        else
        {
        
            carNickName = "錯誤發生"
        
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (carNickName)
        
    }

    func update_car_nickname_type(i_carid:Int,i_carNickName:String,i_cartype:Int)
    {

        //修改資料庫
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        

        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        
        //修改資料庫
        sql = "update car set carNickName ='\(i_carNickName)',cartype=\(i_cartype) where carid=\(i_carid)"
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        
    }
    
    func read_car_info(defaultcarid:String) -> (Array<String>) //讀第一台車子的所有基本資料回來
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var carInfo = [String]()//車子陣列

        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "select carid,carNickName,carCompany,carStyle,carBirthday,carColor,carimg,uploadOilDeviceID,carcc,subcarStyle,oilplace,cartype from car where carid = \(defaultcarid)"

        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            carInfo.append("0")
            carInfo.append("請重建資料")
            carInfo.append("請重建")
            carInfo.append("資料庫")
            carInfo.append("1900-09-10")
            carInfo.append("無顏色")
            carInfo.append("")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            
            return carInfo
            
        }
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
            
            self.alterTableDeviceid()
            
            carInfo.append("0")
            carInfo.append("請重建資料")
            carInfo.append("請重建")
            carInfo.append("資料庫")
            carInfo.append("1900-09-10")
            carInfo.append("無顏色")
            carInfo.append("")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            return carInfo
        }
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            carInfo.append(String(sqlite3_column_int(statement, 0))) //carid
            
            if sqlite3_column_text(statement, 1) != nil
            {
                carInfo.append(String(cString: sqlite3_column_text(statement, 1))) //nicekname

            }
            else
            {
                carInfo.append("無暱稱") //nicekname
            
            }

            if sqlite3_column_text(statement, 2) != nil
            {

                carInfo.append(String(cString: sqlite3_column_text(statement, 2))) //carCompany
                
            }
            else
            {
            
                carInfo.append("無車廠")
            
            
            }
            
            if sqlite3_column_text(statement, 3) != nil
            {
                
                carInfo.append(String(cString: sqlite3_column_text(statement, 3))) //carStyle

                
            }
            else
            {
            
                carInfo.append("無型號")
            
            }
            
            if sqlite3_column_text(statement, 4) != nil
            {
                
                carInfo.append(String(cString: sqlite3_column_text(statement, 4))) //birthday
                
                
            }
            else
            {
                carInfo.append("1900-09-10") //birthday
                
            
            }
            
            
            if sqlite3_column_text(statement, 5) != nil
            {
                
                carInfo.append(String(cString: sqlite3_column_text(statement, 5))) //carColor

                
            }
            else
            {
            
                carInfo.append("無顏色")
            
            }
           
            if sqlite3_column_text(statement, 6) != nil
            {
                
                carInfo.append(String(cString: sqlite3_column_text(statement, 6))) //carimg

                
            }
            else
            {
                carInfo.append("")
            
            }
            
            carInfo.append(String(sqlite3_column_int(statement, 7))) //uploadOilDeviceID
            carInfo.append(String(sqlite3_column_int(statement, 8))) //carcc
            
            if sqlite3_column_text(statement, 9) != nil
            {
                carInfo.append(String(cString: sqlite3_column_text(statement, 9))) //subcarStyle
            }
            else
            {
            
                carInfo.append("")
                
            }
            
            carInfo.append(String(sqlite3_column_int(statement, 10))) //oilplace
            carInfo.append(String(sqlite3_column_int(statement, 11))) //cartype
            
        }
        
        if carInfo.count == 0
        {
//            沒抓到資料
            
            carInfo.append("0")
            carInfo.append("請重建資料")
            carInfo.append("請重建")
            carInfo.append("資料庫")
            carInfo.append("1900-09-10")
            carInfo.append("無顏色")
            carInfo.append("")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")
            carInfo.append("0")

            
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (carInfo)
        
    }

    
    
    //顯示錯誤訊息
    func displayAlert(_ title_i:String,message_i:String)-> UIAlertController
    {
        
        let alert = UIAlertController(title: title_i, message: message_i, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "確定", style: .default, handler: nil)

        
        alert.addAction(okButton)
        
        
        
        return alert
        
    }
    
    func update_car_color(i_carid:Int,i_carColor:String)
    {
        
        //修改車的顏色
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
            
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
        }
        
        
        //修改資料庫
        sql = "update car set carColor = '\(i_carColor)' where carid=\(i_carid)"
        
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
    }

    func update_car_company(i_carid:Int,i_carCompany:String,i_carStyle:String)
    {
        
        //修改車的車廠
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()

        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        
        //修改資料庫
        sql = "update car set carCompany = '\(i_carCompany)',carStyle = '\(i_carStyle)' where carid=\(i_carid)"
        
                
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
    }

    
    func update_car_birthday(i_carid:Int,i_carBirthday:String)
    {
        
        //修改車的生日
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
            
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        
        //修改資料庫
        sql = "update car set carBirthday = '\(i_carBirthday)' where carid=\(i_carid)"
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
    }

    
    func read_car_company_info() -> (carCompany_r:Array<String>,carId_r:Array<String>) //讀車廠資訊
    {
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        var carCompanyInfo = [String]()//車廠名稱
        var companyIDr = [String]() //車廠 id
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "carSetting", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Library/carSetting.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            carCompanyInfo.append("有問題")
            companyIDr.append("有問題")
            return (carCompanyInfo,companyIDr)
            
        }
        
        
        //讀取資料庫
        //1.3
        
        let mytools = mytool()
        
        let defaultcarid:String = mytools.read_car_default()
        
        let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
        
        if carinfo[11] == "3"
        {
            
            sql = "select Companyid,carCompany from carCompany_moto order by carCompanyEng"

            
        }
        else
        {
            
            sql = "select Companyid,carCompany from carCompany order by carCompanyEng"

            
        }
        
        
        statement = nil
        
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            carCompanyInfo.append("有問題")
            companyIDr.append("有問題")
            return (carCompanyInfo,companyIDr)
            
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            companyIDr.append(String(sqlite3_column_int(statement, 0))) //Companyid
            carCompanyInfo.append(String(cString: sqlite3_column_text(statement, 1))) //carCompany
            
            

        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (carCompanyInfo,companyIDr)
        
    }

    func read_car_company_style_info(i_companyid:Int) -> (Array<String>) //讀車廠style資訊
    {
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var carCompanystyleInfo = [String]()//車廠style名稱
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "carSetting", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Library/carSetting.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            carCompanystyleInfo.append("有問題")
            return (carCompanystyleInfo)
            
        }
        
        
        //讀取資料庫
        //1.3
        
        let mytools = mytool()
        
        let defaultcarid:String = mytools.read_car_default()
        
        let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
        
        if carinfo[11] == "3"
        {
            
            sql = "select styleName from carStyle_moto where Companyid =\(i_companyid) order by styleNameEng"

            
        }
        else
        {
            sql = "select styleName from carStyle where Companyid =\(i_companyid) order by styleNameEng"
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            carCompanystyleInfo.append("有問題")
            return (carCompanystyleInfo)
        }
        
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            carCompanystyleInfo.append(String(cString: sqlite3_column_text(statement, 0))) //carCompanystyle
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (carCompanystyleInfo)
        
    }

    func read_car_default() -> String
    {
        //載入預設的 carid

        let defaults = UserDefaults.standard

        if let defaultcarid = defaults.string(forKey: "defaultcarid")
        {
            return defaultcarid
        }

        save_car_default(defaultid: "0")
        
        return "0"
    }
    
    func save_car_default(defaultid:String)
    {
        
        //存入 carid
        let defaults = UserDefaults.standard
        
        defaults.set(defaultid, forKey: "defaultcarid")
        defaults.synchronize()
     
        return
    }
    
    
 
    
    
    func insert_newcar()
    {
        
        //修改資料庫
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        //修改資料庫
        sql = "insert into car(carNickName,carCompany,carStyle,carBirthday,carColor,carimg,subcarStyle) values ('未命名', '未命名', '無', date('now'), '黑', '','')"
        
        //print(sql)
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }
    
    func return_new_carid() -> String //回傳最新的 carid
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令

        var r_carid:String = "0"
        
        let fm:FileManager = FileManager()
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return "0"
            
        }
        
        
        //讀取資料庫
        //1.3
        sql = "select carid from car order by carid desc limit 1"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return "0"
        }
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            r_carid = (String(sqlite3_column_int(statement, 0))) //carid
        }
        else
        {
        
            r_carid = "0"
        
        
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (r_carid)
        
    }
    
    
    func insert_cartotalKM(defaultid:String)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        
        
        sql = "insert into carTotalKM(carid,lastkm,nowkm) values (\(defaultid),0,0)"
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
    }

    
    
    func ReadCarfromDB() -> (carid:Array<String>,carnickname:Array<String>,carcompany:Array<String>,carstyle:Array<String>) //讀所有車的資訊
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        var carid_r = [String]()//車子陣列
        var carnickname_r = [String]()//車子陣列
        var carcompany_r = [String]()//車子陣列
        var carstyle_r = [String]()//車子陣列
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var src1:String = ""
        var dst:String = ""
        var dst1:String = ""

        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
            sql = "select carid,carNickName,carCompany,carStyle from car"
            
        
            src1 = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
            dst1 = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        if !fm.fileExists(atPath: dst1) {
            do {
                try
                    fm.copyItem(atPath: src1, toPath: dst1)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            carid_r.append("有問題")
            carnickname_r.append("有問題")
            carcompany_r.append("有問題")
            carstyle_r.append("有問題")
            
            return (carid_r,carnickname_r,carcompany_r,carstyle_r)
            //exit(1)
            
        }
        
        
        statement = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            carid_r.append("有問題")
            carnickname_r.append("有問題")
            carcompany_r.append("有問題")
            carstyle_r.append("有問題")
            
            return (carid_r,carnickname_r,carcompany_r,carstyle_r)
            
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            carid_r.append(String(sqlite3_column_int(statement, 0))) //carid
            
            if sqlite3_column_text(statement, 1) != nil
            {
                
                carnickname_r.append(String(cString: sqlite3_column_text(statement, 1))) //nicekname

                
            }
            else
            {
            
            
                carnickname_r.append("無䁥稱") //nicekname

                
            
            }
            
            if sqlite3_column_text(statement, 2) != nil
            {

                carcompany_r.append(String(cString: sqlite3_column_text(statement, 2))) //carCompany
                
            }
            else
            {
            
                carcompany_r.append("無車廠") //carCompany

            
            }

            if sqlite3_column_text(statement, 3) != nil
            {
                carstyle_r.append(String(cString: sqlite3_column_text(statement, 3))) //carStyle
                
            }
            else
            {
            
                carstyle_r.append("無車型") //carStyle

            
            }
            
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        //第二個資料表
        
        if sqlite3_open(dst1, &db) != SQLITE_OK
        {
            
            carid_r.append("有問題car1")
            carnickname_r.append("有問題car1")
            carcompany_r.append("有問題car1")
            carstyle_r.append("有問題car1")
            
            return (carid_r,carnickname_r,carcompany_r,carstyle_r)
            
        }
        
        sql = "select carid,carNickName,carCompany,carStyle from car where oilplace = 0"

        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            carid_r.append("有問題car1")
            carnickname_r.append("有問題car1")
            carcompany_r.append("有問題car1")
            carstyle_r.append("有問題car1")
            
            return (carid_r,carnickname_r,carcompany_r,carstyle_r)
            
        }

        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            
            carid_r.append(String(sqlite3_column_int(statement, 0))) //carid
            
            if sqlite3_column_text(statement, 1) != nil
            {
                
                carnickname_r.append(String(cString: sqlite3_column_text(statement, 1))) //nicekname
                
                
            }
            else
            {
                
                
                carnickname_r.append("無䁥稱") //nicekname
                
                
                
            }
            
            if sqlite3_column_text(statement, 2) != nil
            {
                
                carcompany_r.append(String(cString: sqlite3_column_text(statement, 2))) //carCompany
                
            }
            else
            {
                
                carcompany_r.append("無車廠") //carCompany
                
                
            }
            
            if sqlite3_column_text(statement, 3) != nil
            {
                carstyle_r.append(String(cString: sqlite3_column_text(statement, 3))) //carStyle
                
            }
            else
            {
                
                carstyle_r.append("無車型") //carStyle
                
                
            }

            
            
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
       
        return (carid_r,carnickname_r,carcompany_r,carstyle_r)

    
    }
    
    func del_car(carid:String)
    {
        
        //刪除車子
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
            
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
            
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        
        //修改資料庫
        sql = "delete from car where carid ='\(carid)'"

        //print(sql)
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        
        return
    }
    
    func del_FillOil(carid:String)
    {
        

        //修改資料庫
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        
        sql = "delete from FillOil where carid = '\(carid)'"
        
        //print(sql)
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return
    }
    
    func del_mainTain_detail(carid:String)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        //先讀車圖的檔案資料,然後刪除

        /*
        maintains.del_img_fromDevice(imgfold: old_detail_imgwithFolder)
*/

        let maintains = maintain()
        
        let detail_imgarr = maintains.read_detail_img_from_car(carid: carid)
        
        detail_imgarr.forEach
        {
                img_path in

            maintains.del_img_fromDevice(imgfold:img_path )

                
        }

            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        
        sql = "delete from MainTainDetails where carid = '\(carid)'"
        
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
    }
    
    
    func del_MainTainMain(carid:String)
    {

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        
        sql = "delete from MainTainMain where carid = '\(carid)'"
        
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }
    
    
    func del_carTotalKM(carid:String)
    {

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
        }
        
        
        //修改資料庫
        sql = "delete from carTotalKM where carid ='\(carid)'"
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        

        return
        
        
    }
    
    
    func del_carimg(carid:String)
    {
    
        let mytools = mytool()
        let defaultcarid:String = mytools.read_car_default()
        
        var mycarimage:String = ""
        
        if defaultcarid != "0"
        {
            mycarimage = "MyCarImage\(defaultcarid).jpg"
        }
        else
        {
        
            return
        
        }
        
        var filePath = ""
        
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0
        {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + mycarimage)
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
     
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            }
            
        }
        catch let error as NSError
        {
            print("An error took place: \(error)")
        }
        
        return
    }
    
    
    func checkIndexRebuildOilInfo()
    {
        
        
        
        return
    }
    
    

    func checkcarupdateDeviceid() -> Bool
    {
        
        //檢查是否有 updateDeviceid
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        var returnvalue:Bool = false
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        //讀取資料庫
        
        sql = "select count(*) from sqlite_master where type='table' and name='car' and sql like '%uploadOilDeviceID%'"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return false
        }
        
        //逐筆讀取資料列
        if sqlite3_step(statement) == SQLITE_ROW
        {
            
            let returnnum:Int = (Int(sqlite3_column_int(statement, 0))) //數量
            if returnnum == 1
            {
                
                returnvalue = true
                
            }
            else
            {
                
                returnvalue = false
                
            }

            
        }
        else
        {
        
            returnvalue = false
        
        }
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue
        
        
        
    }
    
    
    func alterTableDeviceid()
    {
        
        //alter table car add column uploadOilDeviceID integer default 0
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        
        //建立維修資料表
        
        sql = "alter table car add column uploadOilDeviceID integer default 0"
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return
        
        
        
    }
    
    
    func check_repairtable() -> Bool
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        var returnvalue:Bool = false
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        //讀取資料庫

        sql = "select count(*) from sqlite_master where type='table' and name='RepaireTable'"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return false
        }
       
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let returnnum:Int = (Int(sqlite3_column_int(statement, 0))) //數量
            if returnnum == 1
            {
            
                returnvalue = true
            
            }
            else
            {
            
                returnvalue = false
            
            }
        }
        else
        {
        
        
            returnvalue = false
        
        
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue
        
    }
    
    
    func create_RepaireTabletable()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        
        //建立維修資料表
        
        sql = "create table RepaireTable (id integer primary key autoincrement,repairename text)"
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return
    }
    
    func check_RepaireTable_count() -> Bool
    {
        //檢查是否有三筆資料
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        var returnvalue:Bool = false
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        //讀取資料庫
        
        sql = "select count(*) from RepaireTable"
        
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return false
        }
        
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let returnnum:Int = (Int(sqlite3_column_int(statement, 0))) //數量
            if returnnum >= 3 //要有三筆
            {
            
                returnvalue = true
            
            }
            else
            {
            
                returnvalue = false
            
            }
        }
        else
        {
        
            returnvalue = false
        
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue
        
    }
    
    
    func insert_RepaireTable()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        
        
        sql = "insert into RepaireTable(repairename) values ('保養');insert into RepaireTable(repairename) values ('維修');insert into RepaireTable(repairename) values ('配件')"
        
        
        statement = nil
        
        sqlite3_exec(db, sql.utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
    }
    
    
    
    func check_oilTypetable() ->Bool
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        var returnvalue:Bool = false
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        //讀取資料庫
        
        sql = "select count(*) from sqlite_master where type='table' and name='oilTypeTable'"
        
        
        statement = nil
        
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return false
        }
        
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            let returnnum:Int = (Int(sqlite3_column_int(statement, 0))) //數量
            if returnnum == 1
            {
            
                returnvalue = true
            
            }
            else
            {
                returnvalue = false
            
            }
        }
        else
        {
        
            returnvalue = false
        
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue
        
    }
    
    
    func create_oilTypeTable()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        
        //建立oilType資料表
        
        sql = "create table oilTypeTable (id integer primary key autoincrement,oiltype text)"
        
        
        statement = nil
       
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return
        
    }
    
    func insert_oilTypeTable()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令

        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        
        //建立oilType資料表
        
        sql = "insert into oilTypeTable(oiltype) values ('92');insert into oilTypeTable(oiltype) values ('95');insert into oilTypeTable(oiltype) values ('98');insert into oilTypeTable(oiltype) values ('柴油')"
        
        
        statement = nil
        
        sqlite3_exec(db, sql.utf8String, nil, nil, nil)
        
      
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
    }
    
    
    
    func insert_oil_option() -> Int //新增油耗選項
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        var src:String = ""
        
        var dst:String = ""
        
        let mytools = mytool()
        let defaulcarid = mytools.read_car_default()
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
            sql = "insert into parkinfo(carid,parkmoney,parkplace) values (\(defaulcarid),0,0);delete from parkinfo where carid is null"

        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 0
            
        }
        
        
        //讀取資料庫
        //1.3
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return 0
        }
        //逐筆讀取資料列
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return 0
        

    }


    
    
    func return_oil_option() -> Int //回傳油耗選項
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        var src:String = ""
        
        var dst:String = ""
        
        let mytools = mytool()
        let defaulcarid = mytools.read_car_default()
        
        var oilOption:Int = 0
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
            sql = "select parkmoney,parkplace from parkinfo where carid = \(defaulcarid)"

        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 0
            
        }
        
        
        //讀取資料庫
        //1.3
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return 0
        }
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            oilOption = (Int(sqlite3_column_int(statement, 0))) //oiloption
        }
        else
        {

            //沒資料 新增一筆
            
            _ = self.insert_oil_option()
            
            return 0
        }
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return oilOption

    }
    
    func del_exist_oilinfocar1()
    {
        
        //刪除 Documents裡的 carsetting檔案
        
        let fm:FileManager = FileManager()
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        if  fm.fileExists(atPath: dst)
        {
            
            do {
                try fm.removeItem(atPath: dst)
                
                
            } catch let error as NSError
            {
                
                print(error)
                
            }
            
        }
        
        return
        
        
    }


    
    
    func update_oil_option(oilOption_i:Int)//設定油耗選項
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        
        var dst:String = ""
        
        let mytools = mytool()
        let defaulcarid = mytools.read_car_default()
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
            sql = "update parkinfo set parkmoney = \(oilOption_i) where carid = \(defaulcarid)"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        
        //讀取資料庫
        //1.3
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
        
    }

    func update_oil_type(oilinfo:Array<String>)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        sql = "update oilTypeTable set oiltype = '\(oilinfo[0])' where id = 1;update oilTypeTable set oiltype = '\(oilinfo[1])' where id = 2;update oilTypeTable set oiltype = '\(oilinfo[2])' where id = 3;update oilTypeTable set oiltype = '\(oilinfo[3])' where id = 4"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
          
            return
            
        }
        
        
        
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return

    }
    
    func read_oil_type() -> (Array<String>) //讀油種資訊
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var oilInfo = [String]()//油陣列
        
        
        let fm:FileManager = FileManager()
        
         let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
         let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            //1.3
            sql = "select oiltype from oilTypeTable"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            oilInfo.append("有錯誤")
            return oilInfo
            //exit(1)
            
        }
        
        
        
        
        statement = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            oilInfo.append("有錯誤")
            return oilInfo
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            oilInfo.append(String(cString: sqlite3_column_text(statement, 0))) //oiltype
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (oilInfo)
        
    }
    
    
    
    func del_car_repaire_column_by_carid(defaultid:String)->Bool
    {
        //刪除保修資料
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"


        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
            
            //資料庫
            statement = nil
            
            sql = "delete from RepaireTable where carid = \(defaultid)"
            

            if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
            {
                

                
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                
                
            }

            
            
            
            
        
        
        
        
        
        return true
        
        
    }
    
    
    
    
    func insert_car_repaire_column_by_carid_newcar(defaultid:String)->Bool
    {
        //新增車時要加保修資料
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"


        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
            
            //資料庫
            statement = nil
            
            sql = "insert into RepaireTable (repairename,carid) values ('自定1',\(defaultid)), ('自定2',\(defaultid)), ('自定3',\(defaultid))"
            

            if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
            {
                

                
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                
                
            }

            
            
            
            
        
        
        
        
        
        return true
        
        
    }
    
    
    
    func insert_car_repaire_column_by_carid()->Bool
    {
        //將剩下的車子都各有三個選單
        
        //取得所有車輛資訊
        let mytools = mytool()
        let rs = mytools.ReadCarVisibleinfofromDB()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"


        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        
        rs.carid.forEach
        {returnid in
            
            //資料庫
            statement = nil
            
            sql = "insert into RepaireTable (repairename,carid) values ('保養維修',\(returnid)), ('配件雜項',\(returnid)), ('停車',\(returnid))"
            

            if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
            {
                

                
            }
            
            if sqlite3_step(statement) != SQLITE_DONE
            {
                
                
            }

            
            
            
            
        }

        
 

            

        //SQLITE_DONE
        
        
        
        
        
        return true
        
        
    }
    
    
    
    
    
    
    func add_category_ordersnums()->Bool
    {
        //替分類加一個欄位
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table Category add column orders_num integer default 0;update Category set orders_num = Category.CategoryID;"

        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return true
        
        
        
    }

    
    
    func add_product_ordersnums()->Bool
    {
        //替產品加一個欄位
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table Product add column orders_num integer default 0;update Product set orders_num = Product.ProductID;"

        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return true
        
        
        
    }
    
    
    func add_maintain_picurl_defaultcar() -> Bool
    {
     
        //替 maintaindetail增加一個 pic_url的欄位
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table MainTainDetails add column pic_url text default ''"

        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            

            return false
            
        }
        
        if sqlite3_step(statement) != SQLITE_DONE
        {
            
            return false
            
        }

            

        //SQLITE_DONE
        
        
        return true
        
    }
    
    
    func add_maintain_picurl_new_car() -> Bool
    {
     
        //替 maintaindetail增加一個 pic_url的欄位
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table MainTainDetails add column pic_url text default ''"

        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            

            return false
            
        }
        
        if sqlite3_step(statement) != SQLITE_DONE
        {
            
            return false
            
        }

            

        //SQLITE_DONE
        
        
        return true
        
    }

    

    func add_repaireTable_column_carid() -> Bool
    {
     
        //替 RepaireTable增加一個 carid的欄位
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table RepaireTable add column carid integer default 0"

        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            

            return false
            
        }
        
        if sqlite3_step(statement) != SQLITE_DONE
        {
            
            return false
            
        }

            

        //SQLITE_DONE
        
        
        return true
        
    }
    

    
    
    
    
    func read_maintain_menu() -> (Array<String>) //自訂選單項目
    {
     
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var repaireInfo = [String]()//油陣列
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        //要抓 defaultcarid
        //待做
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()

        //沒有 carid欄位，要加，並且塞值
        if check_carid_column() != true
        {
            
            _ = add_repaireTable_column_carid() //加一個欄位
            _ = insert_car_repaire_column_by_carid() //塞值
            _ = add_maintain_picurl_defaultcar() //pic欄位
            _ = add_maintain_picurl_new_car()

            
        }
       
        
        
        sql = "select repairename from RepaireTable where carid =\(defaultcarid)"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            repaireInfo.append("保養")
            repaireInfo.append("維修")
            repaireInfo.append("配件")
            return repaireInfo
            
        }
        
        
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            repaireInfo.append("保養")
            repaireInfo.append("維修")
            repaireInfo.append("配件")
            return repaireInfo
            
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            repaireInfo.append(String(cString: sqlite3_column_text(statement, 0))) //repaire type
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (repaireInfo)
        
    }
    

    
    func carsetting_update_date() ->String
    {

        //carsetting 最新的 update 日期
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:NSString = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "carSetting", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Library/carSetting.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return "2000-09-10"
            
        }
        
        
        //讀取資料庫
        
        sql = "select updatedate from carStyle order by updatedate desc limit 1"
        
        statement = nil
        if sqlite3_prepare_v2(db, sql.utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            return ("2000-09-10")
        }
        //逐筆讀取資料列
        
        var updateDate:String = ""
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            updateDate = String(cString: sqlite3_column_text(statement, 0)) //新用法
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (updateDate)
        
    }
    
    func read_categoryid_by_productid(productid:String)->String
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        var returnvalue:String = ""

        sql = "select CategoryID from Product where ProductID = \(productid)"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
                return "0"
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return "0"
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue =  String(sqlite3_column_int(statement, 0))

        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue
        
    }
    
    
    func read_product_category_name() -> (pid:Array<String>,pname:Array<String>)
    {
        //取得產品分類陣列
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var product_category_Infoid = [String]()//產品分類id陣列
        var product_category_Infoname = [String]()//產品分類名稱陣列
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select CategoryID,CategoryName from Category order by orders_num"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            product_category_Infoid.append("有錯誤")
            product_category_Infoname.append("有錯誤")
            return (product_category_Infoid,product_category_Infoname)
            
        }
        
        
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            product_category_Infoid.append("有錯誤")
            product_category_Infoname.append("有錯誤")
            return (product_category_Infoid,product_category_Infoname)

        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            product_category_Infoid.append(String(sqlite3_column_int(statement, 0)))
            product_category_Infoname.append(String(cString: sqlite3_column_text(statement, 1)))
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (product_category_Infoid,product_category_Infoname)

        
    }
    
    
    func read_product_name(categoryid:String) -> (pid:Array<String>,pname:Array<String>)
    {
        //取得產品陣列
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var product_id = [String]()//產品分類id陣列
        var product_name = [String]()//產品分類名稱陣列
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select ProductID,ProductName from product where CategoryID = \(categoryid) order by orders_num"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            product_id.append("有問題")
            product_name.append("有問題")
            return(product_id,product_name)
            //print("無法開啟資料庫！")
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            product_id.append("有問題")
            product_name.append("有問題")
            return(product_id,product_name)

            
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            product_id.append(String(sqlite3_column_int(statement, 0)))
            product_name.append(String(cString: sqlite3_column_text(statement, 1)))
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (product_id,product_name)
        
        
    }

    func read_product_name() -> (pid:Array<String>,pname:Array<String>)
    {
        //取得產品陣列
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var product_id = [String]()//產品分類id陣列
        var product_name = [String]()//產品分類名稱陣列
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select ProductID,ProductName from product order by orders_num"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            product_id.append("有問題")
            product_name.append("有問題")
            return(product_id,product_name)
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            product_id.append("有問題")
            product_name.append("有問題")
            return(product_id,product_name)

            
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            product_id.append(String(sqlite3_column_int(statement, 0)))
            product_name.append(String(cString: sqlite3_column_text(statement, 1)))
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (product_id,product_name)
        
        
    }

    
    //改到這裡
    
    
    func haveproductid_categoryid() -> (Array<String>)
    {
        //將產品的 分類 id 傳回來
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var p_category_id = [String]()//產品分類id陣列
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select CategoryID from Product group by CategoryID"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        

        sqlite3_open(dst, &db)
        
        statement = nil
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            p_category_id.append(String(sqlite3_column_int(statement, 0)))
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (p_category_id)

        
        
        
    }

    func haveproductid_maintaindetails() -> (Array<String>)
    {
        //將產品的 分類 id 傳回來
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var p_product_id = [String]()//產品id陣列
        
        
        let fm:FileManager = FileManager()
        
        var src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        var dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select productid from maintaindetails group by productid"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        sqlite3_open(dst, &db)
        
        
        
        
        statement = nil
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            p_product_id.append(String(sqlite3_column_int(statement, 0)))
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //讀取資料庫
        //1.3
        
        sqlite3_open(dst, &db)
        statement = nil
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            p_product_id.append(String(sqlite3_column_int(statement, 0)))
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (p_product_id)
        
        
        
        
    }

    
    
    
    func update_category_by_id(categoryid:String,new_name:String)
    {
        
        //修改產品分類名稱
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        
        
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        
        //修改資料庫
        sql = "update Category set CategoryName = '\(new_name)' where CategoryID = \(categoryid)"

        
        
        statement = nil

        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }

    
    func update_product_name_categoryid(productid:String,new_name:String,categoryid:String)
    {
        
        //修改產品分類名稱和分類 id
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        
        //修改資料庫
        sql = "update Product set ProductName = '\(new_name)',CategoryID = \(categoryid) where ProductID = \(productid)"
        
        
        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }
    
    
    func update_product_by_id(productid:String,new_name:String)
    {
        
        //修改產品分類名稱
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        
        //修改資料庫
        sql = "update Product set ProductName = '\(new_name)' where ProductID = \(productid)"
        
        
        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }

    
    
    func insert_category(new_name:String)
    {
        
        //新增產品分類名稱
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        sql = "insert into Category(CategoryName) values ('\(new_name)')"
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }

    func insert_product(categoryid:String,new_name:String)
    {
        
        //新增產品名稱
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        sql = "insert into Product(ProductName,CategoryID) values ('\(new_name)','\(categoryid)')"
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }

    
    func delete_category_by_id(categoryid:String)->Bool
    {
        
        //刪除產品分類名稱(進行檢查）
        
        //先檢查有沒有查品
        
        var categoryid_array = [String]()

        categoryid_array = self.haveproductid_categoryid()

        

        let index = categoryid_array.firstIndex{$0 == categoryid}

        
        //print(index)
        
        
        //找不到就可以刪
        if index != nil
        {
        
            return false
        
        }

        
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return false
        }
        
        
        //修改資料庫
        sql = "delete from Category where CategoryID = \(categoryid)"
                
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return true
    }

    
    func delete_product_by_id(productid:String)
    {
        
        //刪除產品分類名稱
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        sqlite3_open(dst, &db)
        
        
        //修改資料庫
        sql = "delete from Product where ProductID = \(productid)"
        
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
    }

    
    func check_have_oil() -> Int
    {
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()

        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        var rowcount:Int = 0
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "select count(*) from FillOil where carid = \(defaultcarid)"
            
            
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            return 0
            //exit(1)
            
        }
        
        
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            return 0
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
           rowcount = Int(sqlite3_column_int(statement, 0))
        
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return rowcount
        
    }
    
    
    func update_total_lastkm(lastkm:String)
    {
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "update car set lastkm = \(lastkm) where carid = \(defaultcarid)"
            
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            return
            //exit(1)
            
        }
        
        
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return
        
    }
    
    
    

    func read_total_lastkm()->String
    {
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var lastkm = ""
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select lastkm from car where carid = \(defaultcarid)"
            
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            return "0"
            //exit(1)
            
        }
        
        statement = nil

        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            return "0"
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            lastkm = String(sqlite3_column_double(statement, 0))
        }

        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return lastkm
        
    }
    
    
    
    //搜尋，利用id和 index
    func read_maintain_main(index:Int,productid:String) -> (maintainid:Array<String> , maintainkm:Array<String> , maintainDate:Array<String>,maintainornot:Array<String>)
    {
        //0為全部，1是保養，2是維修，3是停車
        let mytools = mytool()
        let defaultcarid:String = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var maintainID = [String]()//維護id
        var maintainkm = [String]()//維護里程
        var maintaindate = [String]()//維護日期
        var mainornot = [String]() //種類
        
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            switch index
            {
            case 0:
                sql = "select M.MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain as M inner join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and productid = \(productid) order by MainTainDate desc"
            case 1:
                
                sql = "select M.MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain as M inner join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and productid = \(productid) and MainTainOrNot = 1 order by MainTainDate desc"
                
            case 2:
                
                sql = "select M.MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain as M inner join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and productid = \(productid) and MainTainOrNot = 0 order by MainTainDate desc"
                
                
            case 3:
                
                sql = "select M.MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain as M inner join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and productid = \(productid) and MainTainOrNot = 3 order by MainTainDate desc"
                
            default:
                break
            }
            
            
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            //exit(1)
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            maintainID.append(String(sqlite3_column_int(statement, 0)))
            maintainkm.append(String(sqlite3_column_double(statement, 1)))
            maintaindate.append(String(cString: sqlite3_column_text(statement, 2))) //日期
            mainornot.append(String(sqlite3_column_int(statement, 3)))
            
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return(maintainID,maintainkm,maintaindate,mainornot)
        
        
    }

    
    

    func read_maintain_main(index:Int,range:Int) -> (maintainid:Array<String> , maintainkm:Array<String> , maintainDate:Array<String>,maintainornot:Array<String>)
    {
        //0為全部，1是保養，2是維修，3是停車
        //尚需有第二個參數，代表半年內，半年到三年內，以及三年以上
        
        let mytools = mytool()
        let defaultcarid:String = mytools.read_car_default()

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var maintainID = [String]()//維護id
        var maintainkm = [String]()//維護里程
        var maintaindate = [String]()//維護日期
        var mainornot = [String]() //種類
        
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            switch index
            {
            case 0:
                
                switch range
                {
                case 0: //前15筆
                    sql = "select MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain where carid = \(defaultcarid) order by MainTainDate desc,MainTainID desc limit 15 offset 0"
                    
                case 1: //半年內
                    
                    sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where carid = \(defaultcarid)) as a where a.nowdate - a.MainTainDate_n < 180 order by MainTainDate desc,MainTainID desc"

                    break
                    
                case 2://半年以上，三年內
                    
                    sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where carid = \(defaultcarid)) as a where a.nowdate - a.MainTainDate_n between 180 and 1095 order by MainTainDate desc,MainTainID desc"

                    
                    break
                    
                case 3://三年以上
                    
                    sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where carid = \(defaultcarid)) as a where a.nowdate - a.MainTainDate_n > 1095 order by MainTainDate desc,MainTainID desc"

                    
                    break
                default:
                    break
                }

                
            case 1:

                switch range
                    {
                    case 0: //前15筆
                        sql = "select MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain where MainTainOrNot = 1 and carid = \(defaultcarid) order by MainTainDate desc,MainTainID desc limit 15 offset 0"
                        
                    case 1: //半年內
                        
                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 1 and carid =\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n < 180 order by MainTainDate desc,MainTainID desc"

                        
                        
                        break
                        
                    case 2://半年以上，三年內

                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 1 and carid =\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n between 180 and 1095 order by MainTainDate desc,MainTainID desc"

                        
                        break
                        
                    case 3://三年以上
                        
                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 1 and carid =\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n > 1095 order by MainTainDate desc,MainTainID desc"

                        
                        break
                    default:
                        break
                    }
                
            case 2:
                    switch range
                    {
                    case 0: //前15筆
                        
                        sql = "select MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain where MainTainOrNot = 0 and carid = \(defaultcarid) order by MainTainDate desc,MainTainID desc limit 15 offset 0"
                        
                    case 1: //半年內
                        
                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 0 and carid=\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n < 180 order by MainTainDate desc,MainTainID desc"

                        
                        break
                        
                    case 2://半年以上，三年內

                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 0 and carid=\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n between 180 and 1095 order by MainTainDate desc,MainTainID desc"

                        
                        break
                        
                    case 3://三年以上
                        
                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 0 and carid=\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n > 1095 order by MainTainDate desc,MainTainID desc"

                        
                        break
                    default:
                        break
                    }

                
                
                
            case 3:
                    switch range
                    {
                    case 0: //前15筆
                        
                        sql = "select MainTainID,MainTainKM,MainTainDate,MainTainOrNot from MainTainMain where MainTainOrNot = 3 and carid = \(defaultcarid) order by MainTainDate desc,MainTainID desc limit 15 offset 0"
                        
                    case 1: //半年內
                        
                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 3 and carid=\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n < 180 order by MainTainDate desc,MainTainID desc"

                        
                        break
                        
                    case 2://半年以上，三年內
                        
                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 3 and carid=\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n between 180 and 1095 order by MainTainDate desc,MainTainID desc"

                        
                        break
                        
                    case 3://三年以上
                        
                        sql = "select * from(select MainTainID,MainTainKM,MainTainDate,MainTainOrNot,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain where MainTainOrNot = 3 and carid=\(defaultcarid)) as a where a.nowdate - a.MainTainDate_n > 1095 order by MainTainDate desc,MainTainID desc"

                        
                        
                        break
                    default:
                        break
                    }

                
                
            default:
                break
            }
           
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            //exit(1)
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            maintainID.append(String(sqlite3_column_int(statement, 0)))
            maintainkm.append(String(format: "%.f" ,sqlite3_column_double(statement, 1)))
            maintaindate.append(String(cString: sqlite3_column_text(statement, 2))) //日期
            mainornot.append(String(sqlite3_column_int(statement, 3)))
            

        }
        sqlite3_finalize(statement)
        sqlite3_close(db)

        return(maintainID,maintainkm,maintaindate,mainornot)
        
        
    }
    
    
    func read_maintain_main(maintain_id:String) -> (totalkm:String,inputdate:String,segindex:String)
    {
        //0為全部，1是保養，2是維修，3是停車
        let mytools = mytool()
        let defaultcarid:String = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var totalkm_r:String = ""
        var inputdate_r:String = ""
        var segindex:String = "0"
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            
                sql = "select MainTainKM,MainTainDate,MainTainOrNot from MainTainMain where carid = \(defaultcarid) and MainTainID = \(maintain_id)"
            
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            //exit(1)
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            totalkm_r = String(format: "%.f" ,sqlite3_column_double(statement, 0))
            inputdate_r = String(cString: sqlite3_column_text(statement, 1))
            segindex = String(sqlite3_column_int(statement, 2))
            
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return(totalkm_r,inputdate_r,segindex)
        
        
    }

    
    
    func insert_maintain_main(maintainkm:String,maintainDate:String,maintainornot:String)
    {
        
        let mytools = mytool()
        let defaultcarid:String = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        sql = "insert into MainTainMain(carid,MainTainKM,MainTainDate,MainTainOrNot) values(\(defaultcarid),\(maintainkm),'\(maintainDate)',\(maintainornot))"
            
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            //exit(1)
            
        }
        
        statement = nil
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
        
        
        
        
    }
    
    
    func read_first_productname(productid:String)->String
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var productname:String = "" //產品名稱
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            return "error"
            //exit(1)
            
        }
        
        
        //讀取資料庫
        //1.3
        sql = "select ProductName from Product where ProductID = \(productid)"
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            return ("error")
            //exit(1)
        }
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            productname = String(cString: sqlite3_column_text(statement, 0)) //新用法
            
        }
        else
        {
        
            productname = "無明細"
            
        }
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (productname)

        
        
    }
    
    func read_first_main_productid(segment:Int,range_i:Int,ordercount:Int)->Array<String>
    {
        
        
        
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var productid = [String]()//產品id陣列
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            //1.3
            
            switch segment
            {
            case 0://全部
                
                switch range_i
                {
                case 0://前15筆
                    
                    sql = "select M.MainTainID,D.ProductID,MainTainDate  from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID limit 15 offset 0"

                    
                    break
                case 1: //半年內
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n < 180"

                    
                    break
                    
                case 2://半年到三年
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n between 180 and 1095"

                    
                    break
                    
                case 3://三年以上
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n > 1095"

                    
                    break
                    
                default:
                    break
                }

                
            case 1://保養
                
                switch range_i
                {
                case 0://前15筆
                    
                    sql = "select M.MainTainID,D.ProductID,MainTainDate  from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 1 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID limit 15 offset 0"

                    
                    break
                case 1: //半年內
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 1 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n < 180"

                    break
                    
                case 2://半年到三年
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 1 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n between 180 and 1095"

                    
                    break
                    
                case 3://三年以上
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 1 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n > 1095"

                    
                    break
                    
                default:
                    break
                }

                
            case 2://配件
                
                switch range_i
                {
                case 0://前15筆
                    
                    sql = "select M.MainTainID,D.ProductID,MainTainDate  from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 0 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID limit 15 offset 0"

                    
                    break
                case 1: //半年內
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 0 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n < 180"

                    
                    break
                    
                case 2://半年到三年
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 0 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n between 180 and 1095"

                    
                    break
                    
                case 3://三年以上
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 0 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n > 1095"

                    
                    break
                    
                default:
                    break
                }

                
                
            case 3://停車
                
                
                switch range_i
                {
                case 0://前15筆
                    
                    sql = "select M.MainTainID,D.ProductID,MainTainDate  from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 3 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID limit 15 offset 0"

                    
                    break
                case 1: //半年內
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 3 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n < 180"

                    
                    break
                    
                case 2://半年到三年
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 3 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n between 180 and 1095"

                    
                    break
                    
                case 3://三年以上
                    
                    sql = "select * from (select M.MainTainID,D.ProductID,MainTainDate,julianday(date('now')) as nowdate ,julianday(MainTainDate) as MainTainDate_n from MainTainMain as M left outer join MainTainDetails as D on M.MainTainID = D.MainTainID where M.carid = \(defaultcarid) and MainTainOrNot = 3 group by M.MainTainID order by MainTainDate desc,M.MainTainID desc,ProductID) as a where a.nowdate - a.MainTainDate_n > 1095"

                    
                    break
                    
                default:
                    break
                }

                
            default:
                break
            }
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //print("無法開啟資料庫！")
            
        }
        
        
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            productid.append(String(sqlite3_column_int(statement, 1)))
            //productid
            
        }
        
        let arraycount = productid.count
        
        for _ in 0...(ordercount-arraycount)
        {
        
            productid.append("0")
            
        }
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (productid)
        
        
        
    }

    
    
    func ReadCarVisibleinfofromDB() -> (carid:Array<String>,carnickname:Array<String>,carcompany:Array<String>,carstyle:Array<String>,carvisible:Array<String>)
        //讀所有車的資訊,包含會不會顯示
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var carid_r = [String]()//車子陣列
        var carnickname_r = [String]()//車子陣列
        var carcompany_r = [String]()//車子陣列
        var carstyle_r = [String]()//車子陣列
        var carvisible_r = [String]() //是否顯示
        
        let fm:FileManager = FileManager()
        
        var src1:String = ""
        var dst1:String = ""
        
        sql = "select carid,carNickName,carCompany,carStyle,oilplace from car"
       
        src1 = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst1 = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst1) {
            do {
                try
                    fm.copyItem(atPath: src1, toPath: dst1)
            } catch _ {
            }
        }

        
        
        if sqlite3_open(dst1, &db) != SQLITE_OK
        {
            
            //exit(1)
            
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
        }
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            carid_r.append(String(sqlite3_column_int(statement, 0))) //carid
            
            if sqlite3_column_text(statement, 1) != nil
            {

                carnickname_r.append(String(cString: sqlite3_column_text(statement, 1))) //nicekname
                
                
            }
            else
            {
           
                carnickname_r.append("無暱稱")
                
            }
            
            if sqlite3_column_text(statement, 2) != nil
            {
                carcompany_r.append(String(cString: sqlite3_column_text(statement, 2))) //carCompany
                
            }
            else
            {
            
                carcompany_r.append("無車廠")
                
            }
            
            if sqlite3_column_text(statement, 3) != nil
            {
 
                carstyle_r.append(String(cString: sqlite3_column_text(statement, 3))) //carStyle
                
            }
            else
            {
            
                carstyle_r.append("無車型")
            
            
            }
            
            carvisible_r.append(String(sqlite3_column_int(statement, 4)))
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (carid_r,carnickname_r,carcompany_r,carstyle_r,carvisible_r)
        
        
    }

    func update_visible_status(carid:String,status:String)
    {
        
        //修改資料庫
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""

        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
            
            dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        
        //修改資料庫
        sql = "update car set oilplace = \(status) where carid = \(carid)"
        
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        
    }
    
    func select_category_name(productid:String) -> (categoryname:String,categoryid:String)
    {
        //利用productid取回 categoryname
       

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var categoryname_r:String = ""
        var categoryid_r:String = ""
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        sql = "select CategoryName,C.CategoryID from Category as C inner join Product as p on p.CategoryID = C.CategoryID where productid = \(productid)"

        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            //exit(1)
            
        }
            
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            print("error")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            
            categoryname_r = String(cString: sqlite3_column_text(statement, 0))
            categoryid_r = String(sqlite3_column_int(statement, 1))
        
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (categoryname_r,categoryid_r)

        
        
    }
    
    func updateOilDeviceID(deviceID:String)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        
        var dst:String = ""
        
        let mytools = mytool()
        let defaulcarid = mytools.read_car_default()
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        sql = "update car set uploadOilDeviceID = \(deviceID) where carid = \(defaulcarid)"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        sqlite3_open(dst, &db)
        
        
        statement = nil
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

 
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return
        
    }
    
    func getOilDeviceID() -> String
    {
        
        //select uploadOilDeviceID from car
        
            var db:OpaquePointer? = nil //資料庫
            var statement:OpaquePointer?=nil //資料記錄
            var sql:String = "" //SQL指令
            
            let fm:FileManager = FileManager()
            
            var src:String = ""
            
            var dst:String = ""
            
            let mytools = mytool()
            let defaulcarid = mytools.read_car_default()
            
            var deviceid:Int = 0
            
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
 
            sql = "select uploadOilDeviceID from car where carid = \(defaulcarid)"
                
            
            if !fm.fileExists(atPath: dst) {
                do {
                    try
                        fm.copyItem(atPath: src, toPath: dst)
                } catch _ {
                }
            }
            
            
            sqlite3_open(dst, &db)
            
            
            statement = nil
            sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
            if sqlite3_step(statement) == SQLITE_ROW
            {
                deviceid = (Int(sqlite3_column_int(statement, 0))) //deviceid
            }
        
            sqlite3_finalize(statement)
            sqlite3_close(db)
            
        
        return "\(deviceid)"
    
    }
    
    
    
    func read_update_oil_info()->(totalkm:String,totallibre:String)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var totalkm_r:String = ""
        var totallibre_r:String = ""
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        
        var dst:String = ""
        
        let mytools = mytool()
        let defaulcarid = mytools.read_car_default()
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "select sum(workKM),sum(fillLitre) from FillOil where filloil = 0 and carid = \(defaulcarid)"
            
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }


        
        sqlite3_open(dst, &db)
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
        }
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            totalkm_r = String(sqlite3_column_int(statement, 0)) //km
            totallibre_r = String(sqlite3_column_int(statement, 1))
            
        }
        else
        
        {
            totalkm_r = "1"
            totallibre_r = "1"
        }
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (totalkm_r,totallibre_r)
        
        
        
    }

    func update_onecarid()
    {
//        將第一台的id改成0
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            print("無法開啟資料庫！")
            return
        }
        
        
        //修改資料庫
        sql = "update car set carid = 0"
        
        statement = nil
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        
        
    }
    

    
    
    func del_exist_carsetting()
    {
        
        //刪除 Documents裡的 carsetting檔案
        
        let fm:FileManager = FileManager()
        
        let dst:String = NSHomeDirectory()+"/Documents/carSetting.sqlite"
        if  fm.fileExists(atPath: dst)
        {
            
            do {
                try fm.removeItem(atPath: dst)
                
                
            } catch let error as NSError
            {
                
                print(error)
                
            }
            
        }
        
        return
        
        
    }
    
    func read_oil_by_fillid(fillid:String) -> Array<String>
    {

    var db:OpaquePointer? = nil //資料庫
    var statement:OpaquePointer?=nil //資料記錄
    var sql:String = "" //SQL指令
    var oilInfo = [String]()//oil陣列
    
    
    let fm:FileManager = FileManager()
    
    var src:String = ""
    var dst:String = ""
    let ms = mytool()
    let defaultcarid = ms.read_car_default()
     
    src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
    dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
    //讀取資料庫
    sql = "select fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType from FillOil where fillOilID = \(fillid) and carid = \(defaultcarid)"
    
    if !fm.fileExists(atPath: dst) {
    do {
    try
    fm.copyItem(atPath: src, toPath: dst)
    } catch _ {
    }
    }
    
    
    if sqlite3_open(dst, &db) != SQLITE_OK
    {
    
    //print("無法開啟資料庫！")
    oilInfo.append("1900-09-10")
    oilInfo.append("28")
    oilInfo.append("1000")
    oilInfo.append("35")
        
    oilInfo.append("1000")
    oilInfo.append("0")
    oilInfo.append("0")
    oilInfo.append("0")
    
    return oilInfo
    //exit(1)
    
    }
    
    
    statement = nil
    if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
    {
    
        
  
        oilInfo.append("1900-09-10")
        oilInfo.append("28")
        oilInfo.append("1000")
        oilInfo.append("35")

        oilInfo.append("1000")
        oilInfo.append("0")
        oilInfo.append("0")
        oilInfo.append("0")
        return oilInfo
        
    //exit(1)
    }
    //逐筆讀取資料列
    
    while sqlite3_step(statement) == SQLITE_ROW
    {
        

        
        oilInfo.append(String(cString: sqlite3_column_text(statement, 0))) //日期
        oilInfo.append(String(sqlite3_column_double(statement, 1))) //公升油價
        oilInfo.append(String(sqlite3_column_int(statement, 2))) //加油金額
        oilInfo.append(String(sqlite3_column_double(statement, 3))) //加油公升
        oilInfo.append(String(sqlite3_column_double(statement, 4))) //行走距離
        oilInfo.append(String(sqlite3_column_int(statement, 5))) //是否加滿
        oilInfo.append(String(sqlite3_column_int(statement, 6))) //付款類型
        oilInfo.append(String(sqlite3_column_int(statement, 7))) //油種

    
    }
    
    if oilInfo.count == 0
    {
    //            沒抓到資料
    
        oilInfo.append("1900-09-10")
        oilInfo.append("28")
        oilInfo.append("1000")
        oilInfo.append("35")

        oilInfo.append("1000")
        oilInfo.append("0")
        oilInfo.append("0")
        oilInfo.append("0")
    
    }
    
    sqlite3_finalize(statement)
    sqlite3_close(db)
    
    
    return (oilInfo)

    }
    
    func read_car_id() -> Array<String>
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var carid = [String]() //傳回去的陣列
        
        let fm:FileManager = FileManager()
        
        let src:String = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        
        let dst:String = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return carid
        }
        
        
        //修改資料庫
        sql = "select carid from car"
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return carid
        }
        //逐筆讀取資料列
        
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
                carid.append(String(sqlite3_column_int(statement, 0)))
            
                
                
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)


        return carid
        
    }

    func check_fill_oil() -> Int
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var returnvalue:Int = 0
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
            src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
            //讀取資料庫
            //1.3
            sql = "select count(filloil) from filloil where filloil > 1 or filloil <0"
            
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 1
            
        }
        
        statement = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 1
        }
        //逐筆讀取資料列
        
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue = Int(sqlite3_column_int(statement, 0))
            
        }
        else
        {
        
            returnvalue = 1
        
        
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)


        
        return returnvalue
        
    }
    
    
    func update_error_fill_oil()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //讀取資料庫
        //1.3
        sql = "update filloil set filloil = 0 where filloil > 1 or filloil <0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        statement = nil

        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
        
    }

    func check_fill_oil_default() -> Int
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var returnvalue:Int = 0
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select count(filloil) from filloil where filloil > 1 or filloil < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 1
            
        }
        
        statement = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 1
        }
        //逐筆讀取資料列
        
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue = Int(sqlite3_column_int(statement, 0))
            
        }
        else
        {
            
            returnvalue = 1
            
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return returnvalue
        
    }
    
    
    func update_error_fill_oil_default()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "update filloil set filloil = 0 where filloil > 1 or filloil < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
        
    }

    
    func check_oil_type() -> Int
    {
    
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var returnvalue:Int = 0
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //讀取資料庫
        //1.3
        sql = "select count(oiltype) from filloil where oiltype > 3"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 1
            
        }
        
        statement = nil

        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 1
        }
        //逐筆讀取資料列
        
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue = Int(sqlite3_column_int(statement, 0))
            
        }
        else
        {
            
            returnvalue = 1
            
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return returnvalue

    }
    
    
    func update_error_oil_type()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //讀取資料庫
        //1.3
        sql = "update Filloil set oiltype = 1 where oiltype > 3 or oiltype < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
        
    }

    
    func check_oil_type_default() -> Int
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var returnvalue:Int = 0
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select count(oiltype) from filloil where oiltype > 3 or oiltype < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 1
            
        }
        
        statement = nil
        
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 1
        }
        //逐筆讀取資料列
        
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue = Int(sqlite3_column_int(statement, 0))
            
        }
        else
        {
            
            returnvalue = 1
            
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return returnvalue
        
    }
    
    
    func update_error_oil_type_default()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "update Filloil set oiltype = 1 where oiltype > 3 or oiltype < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
        
    }

    
    func check_pay_type() -> Int
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var returnvalue:Int = 0
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //讀取資料庫
        //1.3
        sql = "select count(payType) from filloil where payType > 1 or payType < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 1
            
        }
        
        statement = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 1
        }
        //逐筆讀取資料列
        
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue = Int(sqlite3_column_int(statement, 0))
            
        }
        else
        {
            
            returnvalue = 1
            
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return returnvalue
        
    }
    
    
    func update_error_pay_type()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //讀取資料庫
        //1.3
        sql = "update filloil set payType = 0 where payType > 1 or payType < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
        
    }

    func check_pay_type_default() -> Int
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var returnvalue:Int = 0
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "select count(payType) from filloil where payType > 1 or payType < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return 1
            
        }
        
        statement = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 1
        }
        //逐筆讀取資料列
        
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue = Int(sqlite3_column_int(statement, 0))
            
        }
        else
        {
            
            returnvalue = 1
            
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return returnvalue
        
    }
    
    func update_all_nullvalue()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "update car set carimg = '' where carimg is null;update car set oilplace = 0 where oilplace is null;update car set subCarStyle = '' where subCarStyle is null;update parkinfo set parkbegindate = 0 where parkbegindate is null;update parkinfo set parkenddate = 0 where parkenddate is null;update parkinfo set parkplace = 0 where parkplace is null;"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
        
    }
    
    
    func update_error_pay_type_default()
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        //1.3
        sql = "update filloil set payType = 0 where payType > 1 or payType < 0"
        
        
        
        if !fm.fileExists(atPath: dst) {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return
            
        }
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        
        return
        
    }


}
