//
//  upgrade_db.swift
//  CarOilMaintain
//
//  Created by 楊先民 on 2021/10/16.
//  Copyright © 2021 YOUNG SEN-MING. All rights reserved.
//

import Foundation
import UIKit

class upgrade_DB
{
    
    func check_FillOil_carid() ->Bool
    {
        
        //檢查 FillOil有沒有 carid 這個欄位
        
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

        sql = "SELECT EXISTS (SELECT * FROM sqlite_master WHERE tbl_name = 'FillOil' AND sql LIKE '%carid%');"
        
        
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
    
    

    
    
    func add_car_pk()->Bool
    {
        
        //加 pk，設定自動編號 （重建時設定pk，並且自動編號，匯入舊資料）

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "CREATE TABLE car_new (carid integer NOT NULL primary key AUTOINCREMENT,carNickName text,carCompany text,carStyle text,carBirthday text,carColor text,carimg text,uploadOilDeviceID integer,carcc integer,subcarStyle text,lastkm real,nowkm real,oilplace integer,cartype integer);INSERT INTO car_new(carid,carNickName,carCompany,carStyle,carBirthday,carColor,carimg,uploadOilDeviceID,carcc,subcarStyle,lastkm,nowkm ,oilplace,cartype) select carid,carNickName,carCompany,carStyle,carBirthday,carColor,carimg,uploadOilDeviceID,carcc,subcarStyle,lastkm,nowkm ,oilplace,cartype from car;drop table car;ALTER TABLE car_new RENAME TO car;"

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
    
    
    
    
    func add_FillOil_carid()->Bool
    {
        //替FillOil加一個欄位
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table FillOil add column carid integer default 0;"

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
    
    
    func add_parkinfo_carid()->Bool
    {
        //替parkinfo加一個欄位
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table parkinfo add column carid integer default 0;update parkinfo set parkmoney = parkno;"

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
    
    
    func return_max_filloilID()->Int
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var returnvalue:Int = 0
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        sql = "select max(filloilid) from filloil"
        
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
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 0
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue =  Int(sqlite3_column_int(statement, 0))

        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue
        
    }
    
    
    
    func add_FillOil1_x_value(x:Int)
    {
        
        //將 OilinfoCar1 的 FillOil fillOilID欄位加上 X

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //加一個欄位
        //3.2.1
        sql = "create table FillOil_new(carid integer,fillOilID integer,fillDate text,oilPrice real,FillMoney integer,FillLitre real,workKM real,filloil int,payType int,oilType int);insert into FillOil_new(carid,fillOilID,fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType) select carid,fillOilID+\(x),fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType from FillOil;"

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
            
            return
            
        }
        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return

        
        
        
    }
    
    
    func return_max_maintainID()->Int
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var returnvalue:Int = 0
        
        
        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        sql = "select max(MainTainID) from MainTainMain"
        
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
            
                return 0
        }
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            return 0
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            returnvalue =  Int(sqlite3_column_int(statement, 0))

        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return returnvalue
        
    }

    
    func add_Maintain_y_value(y:Int)
    {
        
        //將 OilinfoCar1 的 MainTainMain 和 MainTainDetails MainTainID欄位加上 X

        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
        //加一個欄位
        //3.2.1
        sql = "create table MainTainMain_new(carid integer,MainTainID integer,MainTainKM real,MainTainDate text,MainTainOrNot integer);insert into MainTainMain_new(carid,MainTainID,MainTainKM,MainTainDate,MainTainOrNot) select carid, MainTainID+\(y),MainTainKM,MainTainDate,MainTainOrNot from MainTainMain;create table MainTainDetails_new(carid integer,MainTainID integer,ProductID integer,Price real,memo text,pic_url text);insert into MainTainDetails_new(carid,MaintainID,ProductID,Price,memo,pic_url) select carid,MaintainID+\(y),ProductID,Price,memo,pic_url from MainTainDetails"

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
            
            return
            
        }
        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return
        
        
        
        
    }
    
    
    
    func add_maintain_carid()->Bool
    {
        //替maintain 和 detail 加一個欄位
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        //加一個欄位
        //3.2.1
        sql = "alter table MainTainMain add column carid integer default 0;alter table MainTainDetails add column carid integer default 0"

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

    
    
    
    func copy_OilInfo1_to_OilInfo_car()->Bool
    {
        //將 OilInfoCar1的 car資料 copy 到 OilInfo 中
        
        var db:OpaquePointer? = nil //第一個資料庫
        var db2:OpaquePointer? = nil //第二個資料庫

        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        let src1 = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        let dst1 = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"


        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        if !fm.fileExists(atPath: dst1)
        {
            do {
                try
                    fm.copyItem(atPath: src1, toPath: dst1)
            } catch _ {
            }
        }

        
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        if sqlite3_open(dst1, &db2) != SQLITE_OK
        {
            
            return false
            
        }

        
        
        sql = "ATTACH DATABASE \"\(dst1)\" AS oilInfo1DB;insert into car(carid,carNickName,carCompany,carStyle,carBirthday,carColor,carimg,uploadOilDeviceID,carcc,subcarStyle,oilplace,cartype) select carid,carNickname,carCompany,carStyle,carBirthday,carColor,carimg,uploadOilDeviceID,carcc,subcarStyle,oilplace,cartype from oilInfo1DB.car;"

        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return true
        
        
        
    }
    
    
    
    func copy_FillOil1_to_FillOil_car()->Bool
    {
        //將 OilInfoCar1的 FillOil資料 copy 到 OilInfo 中
        
        var db:OpaquePointer? = nil //第一個資料庫
        var db2:OpaquePointer? = nil //第二個資料庫

        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        let src1 = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        let dst1 = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"


        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        if !fm.fileExists(atPath: dst1)
        {
            do {
                try
                    fm.copyItem(atPath: src1, toPath: dst1)
            } catch _ {
            }
        }

        
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        if sqlite3_open(dst1, &db2) != SQLITE_OK
        {
            
            return false
            
        }

        
        
        sql = "ATTACH DATABASE \"\(dst1)\" AS oilInfo1DB;insert into FillOil(carid,fillOilID,fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType) select carid,fillOilID,fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType from oilInfo1DB.FillOil_new;"

        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return true
        
        
        
    }
    
    
    
    
    
    func copy_OilInfo1_to_OilInfo_maintain()->Bool
    {
        //將 OilInfoCar1的 maintain資料 copy 到 OilInfo 中
        
        var db:OpaquePointer? = nil //第一個資料庫
        var db2:OpaquePointer? = nil //第二個資料庫

        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        let src1 = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        let dst1 = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"


        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        if !fm.fileExists(atPath: dst1)
        {
            do {
                try
                    fm.copyItem(atPath: src1, toPath: dst1)
            } catch _ {
            }
        }

        
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        if sqlite3_open(dst1, &db2) != SQLITE_OK
        {
            
            return false
            
        }

        
        
        sql = "ATTACH DATABASE \"\(dst1)\" AS oilInfo1DB;insert into MainTainMain(carid,MainTainID,MainTainKM,MainTainDate,MainTainOrNot) select carid,MainTainID,MainTainKM,MainTainDate,MainTainOrNot from oilInfo1DB.MainTainMain_new;insert into MainTainDetails(carid,MainTainID,ProductID,Price,memo,pic_url) select carid,MainTainID,ProductID,Price,memo,pic_url from oilInfo1DB.MainTainDetails_new;"

        
        statement = nil
        
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return true
        
        
        
    }
    
    
    func update_oilinfo_lastkm(carid:Array<String>,lastkm:Array<String>,nowkm:Array<String>)
    {

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
            
            return
            
        }
        
        statement = nil
        
        if carid.count > 0

        {
            for i in 0...carid.count-1
            {
            

                sql = "update  car set lastkm = \(lastkm[i]),nowkm = \(nowkm[i]) where carid = \(carid[i])"

            
                sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

                
            }
        }
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return
        
        
        
    }
    
    
    
    func return_nowkm_array()->(carid:Array<String>,lastkm:Array<String>,nowkm:Array<String>)
    {
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var carid = [String]()//carid陣列
        var lastkm = [String]()//lastkm陣列
        var nowkm = [String]() //nowkm
        
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"
            sql = "select carid,lastkm,nowkm from carTotalKM"
        
        
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
            carid.append(String(sqlite3_column_int(statement, 0)))
            lastkm.append(String(sqlite3_column_double(statement, 1)))
            nowkm.append(String(Int(sqlite3_column_double(statement, 2))))
            

            
            
        }
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return (carid,lastkm,nowkm)

        
        
        
        
    }
    
    
    
    func copy_OilInfo1_to_OilInfo_parkinfo()->Bool
    {
        //將 OilInfoCar1的 parkinfo資料 copy 到 OilInfo 中
        
        var db:OpaquePointer? = nil //第一個資料庫
        var db2:OpaquePointer? = nil //第二個資料庫

        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令

        let fm:FileManager = FileManager()
        
        let src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        let dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"

        let src1 = Bundle.main.path(forResource: "OilInfoCar1", ofType: "sqlite")!
        let dst1 = NSHomeDirectory()+"/Documents/OilInfoCar1.sqlite"


        if !fm.fileExists(atPath: dst)
        {
            do {
                try
                    fm.copyItem(atPath: src, toPath: dst)
            } catch _ {
            }
        }

        if !fm.fileExists(atPath: dst1)
        {
            do {
                try
                    fm.copyItem(atPath: src1, toPath: dst1)
            } catch _ {
            }
        }

        
        
        
        if sqlite3_open(dst, &db) != SQLITE_OK
        {
            
            return false
            
        }
        
        if sqlite3_open(dst1, &db2) != SQLITE_OK
        {
            
            return false
            
        }

        
        
        sql = "ATTACH DATABASE \"\(dst1)\" AS oilInfo1DB;insert into parkinfo(carid,parkmoney) select parkplace,parkmoney from oilInfo1DB.parkinfo;"

        //sql = "ATTACH DATABASE \"\(dst1)\" AS oilInfo1DB;update parkinfo set parkno = 0;insert into parkinfo(carid,parkno) select 1,2;"

        
        statement = nil
        
        
    _ = sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        return true
        
        
        
    }
    
    
    func check_error()
    {
        //錯誤檢查都放這裡
        
        let ms = mytool()
        
        
        //刪除在 documents中的 carsetting 檔
        ms.del_exist_carsetting()
        //check oil type 與 fill oil 是否為 9
        
        //oil_type出現異常 大於3 或 小於0的情況
        
        if ms.check_oil_type_default() > 0
        {
            ms.update_error_oil_type_default()
        }
        
        
        if ms.check_fill_oil_default() > 0
        {
            ms.update_error_fill_oil_default()
        }
        
        
        
        
        if ms.check_pay_type_default() > 0
        {
            ms.update_error_pay_type_default()
        }
        
        //更新所有是 null 的資料
        
        ms.update_all_nullvalue()

        
        

    }


    
}
