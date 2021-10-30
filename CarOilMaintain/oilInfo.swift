//
//  oilInfo.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/7.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import Foundation

class OilInfo: NSObject
{
    //2.04pro
    var walkKM: String = ""     //行走里程
    var fillLitre: String = ""     //加油公升
    var fillMoney: String = ""     //加油金額
    var fillDate: String = ""     //加油日期
    var oilPrice: String = "" //油價
    var oilType: String = "0"     //油種 （92，95，98）//1.05
    var fillOil: String = "0"     //是否加滿 //1.05 0加滿，1未滿
    var payType: String = "0" //信用或現金 0是現金，1是信用
    var nowKM: String = "" //現在行走里程
    var lastKm:String = "" //上次行走里程
    
    func reload_info()
    {
        
        //上次的油耗資訊
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
        sql = "select oilPrice,filloil,payType,oilType from FillOil where carid = \(defaultcarid) order by fillDate desc limit 1"
        
        
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
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            //print("讀取資料庫失敗！ Road")
            return
            //exit(1)
        }
        //逐筆讀取資料列
        
        if sqlite3_step(statement) == SQLITE_ROW
        {
            oilPrice = String(sqlite3_column_double(statement, 0)) //油的單價
            fillOil = String(sqlite3_column_int(statement, 1)) // 加滿與否
            payType = String(sqlite3_column_int(statement, 2)) // 付款方式
            oilType = String(sqlite3_column_int(statement, 3)) // 油種
            
        }
        else //無資料設定預設
        {
            
            oilPrice = "28" //油的單價
            fillOil = "0" // 加滿與否
            payType = "0" // 付款方式
            oilType = "1" // 油種
            
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        //加油取今天
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.string(from: Date())
        
        
        walkKM = ""
        fillLitre = ""
        fillMoney = ""
        fillDate = dateObj
        nowKM = ""
        
        
        lastKm = self.readLastKMinfoFromDB()
        

        
    }
    
    
    
    func oilcountType() -> String
    {
        
        return ""
    }
    
    //2.0.4pro
    func insertOilType()
    {
        
    }
    
    //2.04pro
    func readLastKMinfoFromDB() -> String
    {
        
        //上次的油耗資訊
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
        sql = "select lastKM from car where carid = \(defaultcarid)"
            
        
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
            
                self.lastKm  = String(sqlite3_column_double(statement, 0)) //lastkm
            let tmp_lastkm = CFloat(self.lastKm)
            let tmplastkm = String(format: "%.1f", tmp_lastkm!)

            lastKm = tmplastkm
            
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        return lastKm
    }
    
    func check_fill_alldata() -> Bool
    {
        if walkKM == "" || walkKM == "0.0" || walkKM == "0" || oilPrice == "" || oilPrice == "0.0" || fillLitre == "" || fillLitre == "0.00" || fillMoney == "" || fillMoney == "0"
        {
            
            return false
            
        }
        
        return true
        
    }
    
    
    
    func insert_oil(fillDate_i:String,oilPrice_i:String,FillMoney_i:String,FillLitre_i:String,workKM_i:String,filloil_i:String,payType_i:String,oilType_i:String)
    {
        //新增加油資訊
        //先取得 defaultcarid
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

        sql = "insert into FillOil(carid,FillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType) values (\(defaultcarid),'\(fillDate_i)',\(oilPrice_i),\(FillMoney_i),\(FillLitre_i),\(workKM_i),\(filloil_i),\(payType_i),\(oilType_i))"
        
        
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
            
            //print("無法開啟資料庫！")
            return
            //exit(1)
            
        }
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)

        sqlite3_finalize(statement)
        sqlite3_close(db)

        //修改總里程
        update_lastkm(defaultcarid: defaultcarid, walkkm: workKM_i)

    }

    
    func update_oil(fillDate_i:String,oilPrice_i:String,FillMoney_i:String,FillLitre_i:String,workKM_i:String,filloil_i:String,payType_i:String,oilType_i:String,filloilID:String)
    {
        //新增加油資訊
        //先取得 defaultcarid
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
            sql = "update FillOil set fillDate = '\(fillDate_i)',oilPrice = \(oilPrice_i),FillMoney = \(FillMoney_i),FillLitre = \(FillLitre_i),workKM = \(workKM_i),filloil = \(filloil_i),payType = \(payType_i),oilType = \(oilType_i) where fillOilID = \(filloilID) and carid = \(defaultcarid)"
            
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
            
            //print("無法開啟資料庫！")
            return
            //exit(1)
            
        }
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
    }

    
    
    func update_lastkm(defaultcarid:String,walkkm:String)
    {
        
        //將walk加入到 lastkm中
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
        src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
        dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
        sql = "update car set lastkm = lastkm + \(walkKM) where carid = \(defaultcarid)"
        
        
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
            
            //print("無法開啟資料庫！")
            return
            //exit(1)
            
        }
        
        
        
        
        statement = nil
        
        sqlite3_exec(db, (sql as NSString).utf8String, nil, nil, nil)
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        
        
    }
    
    
    //讀取加油資訊，取15筆
    func return_oildetail(type:String) -> (filloilID_a:Array<String>,filloilDate_a:Array<String>,oilPrice_a:Array<String>,fillMoney_a:Array<String>,fillLitre_a:Array<String>,workKm_a:Array<String>,filloil_a:Array<String>,payType_a:Array<String>,oilType_a:Array<String>)
    {

        var filloilID_r = [String]()
        var filloilDate_r = [String]()
        var oilPrice_r = [String]()
        var fillMoney_r = [String]()
        var fillLitre_r = [String]()
        var workKm_r = [String]()
        var filloil_r = [String]()
        var payType_r = [String]()
        var oilType_r = [String]()

        
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
            
        switch type
        {
            case "0":
            sql = "select fillOilID,fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType from filloil where carid = \(defaultcarid) order by fillDate desc limit 15"

            case "1":
            
                sql = "select fillOilID,fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType from(select *,julianday(date('now')) as nowdate ,julianday(fillDate) as filloildate from FillOil ) as a where a.nowdate - a.filloildate < 180 and carid = \(defaultcarid) order by fillDate desc"

                
            case "2":
                
                sql = "select fillOilID,fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType from(select *,julianday(date('now')) as nowdate ,julianday(fillDate) as filloildate from FillOil ) as a where a.nowdate - a.filloildate between 180 and 1095 and carid = \(defaultcarid) order by fillDate desc"

                
            case "3":
                
                sql = "select fillOilID,fillDate,oilPrice,FillMoney,FillLitre,workKM,filloil,payType,oilType from(select *,julianday(date('now')) as nowdate ,julianday(fillDate) as filloildate from FillOil ) as a where a.nowdate - a.filloildate >=1095 and carid = \(defaultcarid) order by fillDate desc"

                
            default:
                break
            }
            
        
        
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
            
            print("無法開啟資料庫！")
            //exit(1)
            
        }
        
        
        
        
        statement = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
            
            print("讀取資料庫失敗！ Road")
            //exit(1)
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            filloilID_r.append(String(sqlite3_column_int(statement, 0)))
            filloilDate_r.append(String(cString: sqlite3_column_text(statement, 1)))
            oilPrice_r.append(String(sqlite3_column_double(statement, 2)))
            fillMoney_r.append(String(sqlite3_column_int(statement, 3)))
            fillLitre_r.append(String(sqlite3_column_double(statement, 4)))
            workKm_r.append(String(sqlite3_column_double(statement, 5)))

            filloil_r.append(String(sqlite3_column_int(statement, 6)))
            payType_r.append(String(sqlite3_column_int(statement, 7)))
            oilType_r.append(String(sqlite3_column_int(statement, 8)))

            
        }
        
        //print(oilType_r)
        sqlite3_finalize(statement)
        sqlite3_close(db)

        return (filloilID_r,filloilDate_r,oilPrice_r,fillMoney_r,fillLitre_r,workKm_r,filloil_r,payType_r,oilType_r)
        
        
        
    }
    
    func del_oil_detail(oilid:String)
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
        sql = "delete from FillOil where fillOilID = \(oilid) and carid = \(defaultcarid)"
        
        
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

        //總里程修改？(不用）
        
        return
        
        
        
    }
    
    
  
}

