//
//  maintain.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/12.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import Foundation
import UIKit

class maintain
{
    
    func del_img_fromDevice(imgfold:String)
    {
        
        //刪檔
        if (imgfold == "")
        {
            
            return
            
        }
        
        var filePath = ""
        // Fine documents directory on device
         let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/"+imgfold)
         
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
            } else {
                print("File does not exist")
            }
         
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }

        
        
        
    }
    
    
    func read_datefrom_maintain(productID:String)->(dateR:Array<String>,priceR:Array<String>)
    {
        
        var date_arr = [String]()// 日期陣列
        var price_arr = [String]()// 價格陣列

        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "select MaintainDate,price from MaintainMain as a inner join MainTainDetails as b on a.MaintainID = b.MaintainID where a.carid = \(defaultcarid) and ProductID = \(productID) order by MainTainDate desc"
        
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
            date_arr.append(String(cString: sqlite3_column_text(statement, 0)))
            price_arr.append(String(Int(sqlite3_column_double(statement, 1)))
)
        

            
            
        }

        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (date_arr,price_arr)
        
    }
    
    
    
    func read_detail_maintain(maintainID:String) -> (detailid:Array<String>,productid:Array<String>,price:Array<String>,memo:Array<String>,detail_imgarr:Array<String>)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var detail_id = [String]()//明細id陣列
        var product_id = [String]()//productid陣列
        var price = [String]() //價格陣列
        var memo = [String]() //備註陣列
        var detail_imgarr = [String]()// 圖片檔名陣列
        
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select MainTainID,ProductID,Price,memo,pic_url from MainTainDetails where carid = \(defaultcarid) and MainTainID = \(maintainID)"
            
        
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
            detail_id.append(String(sqlite3_column_int(statement, 0)))
            product_id.append(String(sqlite3_column_int(statement, 1)))
            price.append(String(Int(sqlite3_column_double(statement, 2))))
            detail_imgarr.append(String(cString: sqlite3_column_text(statement, 4)))
            

            
            if sqlite3_column_text(statement, 3) == nil
            {
                memo.append("")

            }
            else
            {

                memo.append(String(cString: sqlite3_column_text(statement, 3)))
            
            }
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (detail_id,product_id,price,memo,detail_imgarr)

        
    }
    
    
    func read_detail_maintain(maintainID:String,productid:String) -> (price:String,memo:String,image_path:String)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var dbprice:String = ""
        var dbmemo:String = ""
        var dbimagePath:String = "" //圖片路徑
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "select Price,memo,pic_url from MainTainDetails where carid = \(defaultcarid) and MainTainID = \(maintainID) and ProductID = \(productid)"
        
        
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
            dbprice = String(Int(sqlite3_column_double(statement, 0)))
            
            if sqlite3_column_text(statement, 1) == nil
            {
                dbmemo = ""
            }
            else
            {
                dbmemo = String(cString: sqlite3_column_text(statement, 1))
            }
            
            dbimagePath = String(cString: sqlite3_column_text(statement, 2))
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (dbprice,dbmemo,dbimagePath)
        
        
    }
    
    
    //取得最新的 productid
    
    func read_new_productid()->String
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
        

        sql = "select ProductID from Product order by ProductID desc limit 1" //取最新的 product 回傳
        
        statement = nil
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
         sqlite3_step(statement)
        
        let productid_last = String(sqlite3_column_int(statement, 0))
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return productid_last
        
    }
    
    //取得最新的 categoryid
    func read_new_categoryid()->String
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
        

        sql = "select CategoryID from Category order by CategoryID desc limit 1" //取最新的 category 回傳
        
        statement = nil
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
         sqlite3_step(statement)
        
        let categoryid_last = String(sqlite3_column_int(statement, 0))
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return categoryid_last
        
    }
    
    //更新最新的 orders_nums 為最新的 catregoryid
    func update_category_orders_nums(input_categoryid:String)->Bool
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
            sql = "update category set orders_num = \(input_categoryid) where CategoryID = \(input_categoryid)"
        
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
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        

        
        return true
        
    }

    
    //更新最新的 orders_nums 為最新的 productid
    func update_product_orders_nums(input_productid:String)->Bool
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
            sql = "update Product set orders_num = \(input_productid) where ProductID = \(input_productid)"
        
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
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        

        
        return true
        
    }

    
    

    func insert_product_category(categoryName:String) -> String
    {
        //輸入產品分類名，新增，並傳回最新的 id

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "insert into Category(CategoryName) values ('\(categoryName)')"
        
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
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        sql = "select CategoryID from Category order by CategoryID desc limit 1" //取最新的 category 回傳
        
        statement = nil
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
         sqlite3_step(statement)
        
        let categoryid_last = String(sqlite3_column_int(statement, 0))
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return categoryid_last
        
        
    }

    func insert_products(categoryid:String,productname:String) -> String
    {
        //輸入產品分類名，新增，並傳回最新的 id
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //讀取資料庫
        sql = "insert into Product(ProductName,CategoryID) values ('\(productname)',\(categoryid))"
        
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
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sql = "select ProductID from Product order by ProductID desc limit 1" //取最新的 category 回傳
        
        statement = nil
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
        sqlite3_step(statement)
        
        let productid_last = String(sqlite3_column_int(statement, 0))
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return productid_last
        
        
    }

    
    func insert_maintain_details(MaintainID:String,ProductID:String,price:String,memo:String,detail_img:String)->Int32
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "insert into MainTainDetails (carid,MainTainID,ProductID,Price,memo,pic_url) values (\(defaultcarid),\(MaintainID),\(ProductID),\(price),'\(memo)','\(detail_img)')"
        
        
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
        var rc: Int32 = 0 // result code


        rc = sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return rc
        
        
    }
    
    
    func update_maintain_details(MaintainID:String,ProductID:String,price:String,memo:String,oldProductID:String,img_path:String)->Int32
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "update MainTainDetails set ProductID = \(ProductID),Price =\(price),memo = '\(memo)' ,pic_url = '\(img_path)' where MainTainID = \(MaintainID) and ProductID = \(oldProductID) and carid = \(defaultcarid)"
        
        
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
        var rc: Int32 = 0 // result code
        
        
        rc = sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return rc
        
        
    }

    

    func delete_maintain_detail(MaintainID:String,ProductID:String,img_picarr:String)->Int32
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "delete from MainTainDetails where MainTainID = \(MaintainID) and ProductID = \(ProductID) and carid = '\(defaultcarid)'"
        
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
        var rc: Int32 = 0 // result code
        
        
        rc = sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        //刪圖
        
            

            self.del_img_fromDevice(imgfold: img_picarr)
            
        
        return rc
        
        
    }
    
    func read_detail_img_from_car(carid:String)->Array<String>
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var detail_imgarr = [String]()// 圖片檔名陣列
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select pic_url from MainTainDetails where carid = \(carid)"
        
        
        
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
            detail_imgarr.append(String(cString: sqlite3_column_text(statement, 0)))
            

            
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (detail_imgarr)
        
        
        
    }

    func delete_maintain_main(MaintainID:String)->Int32
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var sql2:String = "" //SQL指令
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        
        //讀明細的圖檔刪除
        
        let m1 = self.read_detail_maintain(maintainID: MaintainID)

        m1.detail_imgarr.forEach{
            img_path in

            self.del_img_fromDevice(imgfold:img_path )

            
        }
        
        
        
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "delete from MainTainMain where MainTainID = \(MaintainID) and carid = \(defaultcarid)"
            
            sql2 = "delete from MainTainDetails where MainTainID = \(MaintainID) and carid = \(defaultcarid)"
            
        
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
        var rc: Int32 = 0 // result code
        
        
        rc = sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        rc = sqlite3_exec(db, (sql2 as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return rc
        
        
    }
    
    
    func update_maintain_main(MaintainID:String,Maintainkm:String,Maintaindate:String,maintainornot:String)->Int32
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "update MainTainMain set MainTainKM = \(Maintainkm),MainTainDate = '\(Maintaindate)',MainTainOrNot = \(maintainornot) where MainTainID = \(MaintainID) and carid = \(defaultcarid)"
            
        
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
        var rc: Int32 = 0 // result code
        
        
        rc = sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return rc
        
        
    }
    
    
    

    
}
