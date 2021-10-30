//
//  stats.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/18.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import Foundation
import UIKit

class mystatistic
{
    
    func read_totalkm_statistic()->(totalkm:String,totalLibre:String,totalMoney:String)
    {
        
        //傳回行里程，公升汽油，加油總金額
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var totalkm_r:String = "0"
        var totalLibre_r:String = "0"
        var totalMoney_r:String = "0"
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select sum(workKM),sum(FillLitre),sum(FillMoney) from FillOil where carid = \(defaultcarid)"
        
        
        
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
        
        statement = nil
        
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil) != SQLITE_OK
        {
         
        }
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            totalkm_r = String(format:"%.f",sqlite3_column_double(statement, 0))

            totalLibre_r = String(format:"%.f",sqlite3_column_double(statement, 1))

            
            let tmpstr = Double(sqlite3_column_int(statement, 2))
            
            
            
             totalMoney_r = formatCurrency(value: tmpstr)
            

            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (totalkm_r,totalLibre_r,totalMoney_r)
        
    }

    func read_maintain_menu_statistic()->(maintain_A:String,maintain_B:String,maintain_C:String)
    {
        
        //傳回各分類花的金額
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        var sql2:String = ""
        var sql3:String = ""
        var maintain_A_r:String = "0"
        var maintain_B_r:String = "0"
        var maintain_C_r:String = "0"
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            //1.3
            sql = "select sum(Price),MainTainOrNot from maintainMain as a inner join maintainDetails as b on a.MainTainID = b.MaintainID where MainTainOrnot = 1 and a.carid = \(defaultcarid) group by MainTainOrNot"
            
            sql2 = "select sum(Price),MainTainOrNot from maintainMain as a inner join maintainDetails as b on a.MainTainID = b.MaintainID where MainTainOrnot = 0 and a.carid = \(defaultcarid) group by MainTainOrNot"

            
            sql3 = "select sum(Price),MainTainOrNot from maintainMain as a inner join maintainDetails as b on a.MainTainID = b.MaintainID where MainTainOrnot = 3 and a.carid = \(defaultcarid) group by MainTainOrNot"

 
        
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
        
        statement = nil
        
        sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &statement, nil)
        
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            maintain_A_r = formatCurrency(value: sqlite3_column_double(statement, 0))
            
        }

        statement = nil
        
        sqlite3_prepare_v2(db, (sql2 as NSString).utf8String, -1, &statement, nil)
        
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            maintain_B_r = formatCurrency(value: sqlite3_column_double(statement, 0))
            
        }

        
        statement = nil
        sqlite3_prepare_v2(db, (sql3 as NSString).utf8String, -1, &statement, nil)
        
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            maintain_C_r = formatCurrency(value: sqlite3_column_double(statement, 0))
            
        }

        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (maintain_A_r,maintain_B_r,maintain_C_r)
        
    }

    
    func read_total_money()->Double
    {
        
        //傳回全部花費金額
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令 filloil
        var sql2:String = "" //MainTainDetails
        var oilPrice:String = "0" //油錢
        var maintainPrice:String = "0" //維護錢
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select sum(FillMoney) from FillOil where carid = \(defaultcarid)"
            sql2 = "select sum(price) from MainTainDetails where carid = \(defaultcarid)"
        
        
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
            
            oilPrice = String(sqlite3_column_int(statement, 0))
            
        }
        
        statement = nil
        
        sqlite3_prepare_v2(db, (sql2 as NSString).utf8String, -1, &statement, nil)
        
        
        //逐筆讀取資料列
        
        while sqlite3_step(statement) == SQLITE_ROW
        {
            
            maintainPrice = String(sqlite3_column_double(statement, 0))
            
        }
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)

        let tmpmoney:Double = Double(maintainPrice)! + Double(oilPrice)!
        
        //totalMoney = formatCurrency(value: tmpmoney)

        
        return (tmpmoney)
        
    }

    
    
    
    func formatCurrency(value: Double) -> String
    {
        //傳回貨幣格式，千位一逗號
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
    
    
    func read_statistic_date() -> Array<String>
    {
        //讀油耗的日期
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilstatisticDate = [String]()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select fillDate from FillOil where carid = \(defaultcarid) order by fillDate"
        
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
            
            oilstatisticDate.append(String(cString: sqlite3_column_text(statement, 0)))
            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilstatisticDate)

        
        
        
        
    }
    
    
    func read_statistic_oil() -> Array<String>
    {
        //讀每公升、百公里的數據
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilstatisticData = [String]()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select cast(sum(workKM) as real)/cast(sum(FillLitre) as real) from FillOil  where carid= \(defaultcarid) union all select cast(sum(FillLitre) as real)/sum(workKM)*100 from FillOil where carid= \(defaultcarid) union all select cast(sum(FillMoney) as real)/cast(sum(workKM) as real) from FillOil where carid= \(defaultcarid) union all select avg(cast(FillMoney as real)) from FillOil where carid= \(defaultcarid)"
            
        
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
            
            oilstatisticData.append(String(format:"%.2f",sqlite3_column_double(statement, 0)))
            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilstatisticData)
        
        
        
        
        
    }

    
    func read_limit10_info_cell0() -> Array<String>
    {
        
        //讀每公升跑幾公里
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilstatisticData = [String]()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select cast(sum(workKM) as real)/cast(sum(FillLitre) as real) from(select * from FillOil where carid = \(defaultcarid) order by fillDate desc limit 1) as t union all select cast(sum(workKM) as real)/cast(sum(FillLitre) as real) from(select * from FillOil where carid = \(defaultcarid) order by fillDate desc limit 5) as t union all select cast(sum(workKM) as real)/cast(sum(FillLitre) as real) from(select * from FillOil where carid = \(defaultcarid) order by fillDate desc limit 10) as t union all select cast(sum(workKM) as real)/cast(sum(FillLitre) as real) from FillOil where carid = \(defaultcarid)"
            
        
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
            
            oilstatisticData.append(String(format:"%.2f",sqlite3_column_double(statement, 0)))
            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilstatisticData)
        

        
        
    }

    
    
    
    func read_limit10_chart_cell0() -> (x:Array<String>,y:Array<Int>)
    {
        
        //讀每公升跑幾公里
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select cast(workKM as real)/cast(FillLitre as real),fillDate from filloil where carid = \(defaultcarid) order by fillDate desc limit 50"
            
        
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
            
            x.append(String(cString: sqlite3_column_text(statement, 1)))
            
            let tmp = Int(sqlite3_column_double(statement,0))
            
            y.append(tmp)
            
            
            
        }
        
       x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }

    
    func read_limit10_info_cell1() -> Array<String>
    {
        
        //百公里耗
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilstatisticData = [String]()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select cast(sum(FillLitre) as real)/sum(workKM)*100 from(select * from FillOil where carid = \(defaultcarid) order by fillDate desc limit 1) as t union all select cast(sum(FillLitre) as real)/sum(workKM)*100 from(select * from FillOil where carid =\(defaultcarid) order by fillDate desc limit 5) as t union all select cast(sum(FillLitre) as real)/sum(workKM)*100 from (select * from FillOil where carid =\(defaultcarid) order by fillDate desc limit 10) as t union all select cast(sum(FillLitre) as real)/sum(workKM)*100 from FillOil where carid =\(defaultcarid)"
            
        
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
            
            oilstatisticData.append(String(format:"%.2f",sqlite3_column_double(statement, 0)))
            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilstatisticData)
        
        
        
        
    }

    
    func read_limit10_chart_cell1() -> (x:Array<String>,y:Array<Int>)
    {
        
        //百公里耗圖表
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            //1.3
            sql = "select (cast(FillLitre as real)/workKM) *100,fillDate from filloil where carid = \(defaultcarid) order by fillDate desc limit 50"
        
        
        
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
            
            x.append(String(cString: sqlite3_column_text(statement, 1)))
            
            let tmp = Int(sqlite3_column_double(statement,0))
            
            y.append(tmp)
            
            
            
        }
        
        x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }
    
    func read_limit10_info_cell2() -> Array<String>
    {
        
        //一公里花多少錢
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilstatisticData = [String]()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select cast(sum(FillMoney) as real)/cast(sum(workKM) as real) from (select * from FillOil where carid = \(defaultcarid) order by fillDate desc limit 1) as t union all select cast(sum(FillMoney) as real)/cast(sum(workKM) as real) from(select * from FillOil where carid = \(defaultcarid) order by fillDate desc limit 5) as t union all select cast(sum(FillMoney) as real)/cast(sum(workKM) as real) from (select * from FillOil where carid = \(defaultcarid) order by fillDate desc limit 10) as t union all select cast(sum(FillMoney) as real)/cast(sum(workKM) as real) from FillOil where carid = \(defaultcarid)"
            
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
            
            oilstatisticData.append(String(format:"%.2f",sqlite3_column_double(statement, 0)))
            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilstatisticData)
        
        
        
        
    }
    
    func read_limit10_chart_cell2() -> (x:Array<String>,y:Array<Int>)
    {
        
        //百公里耗圖表
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select cast(FillMoney as real)/cast(workKM as real),fillDate from filloil where carid = \(defaultcarid) order by fillDate desc limit 50"
            
        
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
            
            x.append(String(cString: sqlite3_column_text(statement, 1)))
            
            let tmp = Int(sqlite3_column_double(statement,0))
            
            y.append(tmp)
            
            
            
        }
        
        x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }


    func read_limit10_info_cell3() -> Array<String>
    {
        
        //平均加油花費
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilstatisticData = [String]()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select avg(cast(FillMoney as real)) from(select * from FillOil where carid=\(defaultcarid) order by fillDate desc limit 1) as t union all select avg(cast(FillMoney as real)) from(select * from FillOil where carid=\(defaultcarid) order by fillDate desc limit 5) as t union all select avg(cast(FillMoney as real)) from (select * from FillOil where carid=\(defaultcarid) order by fillDate desc limit 10) as t union all select avg(cast(FillMoney as real)) from FillOil where carid=\(defaultcarid)"
            
        
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
            
            oilstatisticData.append(String(format:"%.2f",sqlite3_column_double(statement, 0)))
            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilstatisticData)
        
        
        
        
    }
    
    func read_limit10_chart_cell3() -> (x:Array<String>,y:Array<Int>)
    {
        
        //百公里耗圖表
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select FillMoney,filldate from FillOil where carid= \(defaultcarid) order by fillDate desc limit 50"
            
        
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
            
            x.append(String(cString: sqlite3_column_text(statement, 1)))
            
            let tmp = Int(sqlite3_column_double(statement,0))
            
            y.append(tmp)
            
            
            
        }
        
        x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }

    func read_limit10_info_cell6() -> Array<String>
    {
        
        //平均加油花費
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilstatisticData = [String]()
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "select avg(cast(oilPrice as real)) from(select * from FillOil where carid=\(defaultcarid) order by fillDate desc limit 1) as t union all select avg(cast(oilPrice as real)) from(select * from FillOil where carid=\(defaultcarid) order by fillDate desc limit 5) as t union all select avg(cast(oilPrice as real)) from (select * from FillOil where carid=\(defaultcarid) order by fillDate desc limit 10) as t union all select avg(cast(oilPrice as real)) from FillOil where carid=\(defaultcarid)"
            
        
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
            
            oilstatisticData.append(String(format:"%.2f",sqlite3_column_double(statement, 0)))
            
            
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilstatisticData)
        
        
        
        
    }
    
    func read_limit10_chart_cell6() -> (x:Array<String>,y:Array<Int>)
    {
        
        //百公里耗圖表
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            sql = "select oilPrice,filldate from FillOil where carid=\(defaultcarid) order by fillDate desc limit 50"
        
        
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
            
            x.append(String(cString: sqlite3_column_text(statement, 1)))
            
            let tmp = Int(sqlite3_column_double(statement,0))
            
            y.append(tmp)
            
            
            
        }
        
        x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }
    
    func read_limit10_chart_cell4() -> (x:Array<String>,y:Array<Int>)
    {
        
        //年月油耗
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "SELECT strftime('%Y',fillDate) as Year , strftime('%m',fillDate) as Month,sum (FillMoney),sum(Filllitre) from FillOil where carid = \(defaultcarid) group by Year,Month order by year desc ,month desc"
            
        
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
            
            x.append("\(String(sqlite3_column_int(statement, 0)))年\(String(sqlite3_column_int(statement, 1)))月")
            
            y.append(Int(sqlite3_column_int(statement,2)))
            
            
            
        }
        
        x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }

    
    func read_limit10_chart_cell5() -> (x:Array<String>,y:Array<Int>)
    {
        
        //年油耗
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "SELECT strftime('%Y',fillDate) as Year ,sum (FillMoney),sum(Filllitre) from FillOil where carid = \(defaultcarid) group by Year order by year desc"
            
        
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
            
            x.append("\(String(sqlite3_column_int(statement, 0)))年")
            
            y.append(Int(sqlite3_column_int(statement,1)))
            
            
            
        }
        
        x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }
    
    
    func read_limit10_chart_cell66() -> (x:Array<String>,y:Array<Int>)
    {
        
        //年月公里
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        let fm:FileManager = FileManager()
        
        var x = [String]()
        var y = [Int]()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            
            sql = "SELECT strftime('%Y',fillDate) as Year , strftime('%m',fillDate) as Month,sum(workKM) from FillOil where carid = \(defaultcarid) group by Year,Month order by year desc ,month desc"
        
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
            
            x.append("\(String(sqlite3_column_int(statement, 0)))年\(String(sqlite3_column_int(statement, 1)))月")
            
            y.append(Int(sqlite3_column_int(statement,2)))
            
            
            
        }
        
        x = x.reversed()
        
        
        y = y.reversed()
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (x,y)
        
        
        
        
    }

    
    
    func read_limit10_info_cell4() -> (oilYear:Array<String>,oilMonth:Array<String>,oilMoney:Array<String>,oilLibre:Array<String>)
    {

        //年月油錢
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilYear = [String]()
        var oilMonth = [String]()
        var oilMoney = [String]()
        var oilLibre = [String]()
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "SELECT strftime('%Y',fillDate) as Year , strftime('%m',fillDate) as Month,sum (FillMoney),sum(Filllitre) from FillOil where carid = \(defaultcarid) group by Year,Month order by year desc ,month desc"
        
        
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
            oilYear.append(String(sqlite3_column_int(statement, 0)))
            oilMonth.append(String(sqlite3_column_int(statement, 1)))
            oilMoney.append(String(sqlite3_column_int(statement, 2)))
            oilLibre.append(String(format:"%.f",sqlite3_column_double(statement, 3)))
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilYear,oilMonth,oilMoney,oilLibre)
        
        
       

    }

    func read_limit10_info_cell5() -> (oilYear:Array<String>,oilMoney:Array<String>,oilLibre:Array<String>)
    {
        
        //年油錢
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilYear = [String]()
        var oilMoney = [String]()
        var oilLibre = [String]()
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "SELECT strftime('%Y',fillDate) as Year ,sum (FillMoney),sum(Filllitre) from FillOil where carid = \(defaultcarid) group by Year order by year desc"
            
        
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
            oilYear.append(String(sqlite3_column_int(statement, 0)))
            oilMoney.append(String(sqlite3_column_int(statement, 1)))
            oilLibre.append(String(format:"%.f",sqlite3_column_double(statement, 2)))
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilYear,oilMoney,oilLibre)
        
        
        
        
    }
    
    
    func read_limit10_info_cell66() -> (oilYear:Array<String>,oilMonth:Array<String>,oilLibre:Array<String>)
    {
        
        //年月油錢
        
        let mytools = mytool()
        let defaultcarid = mytools.read_car_default()
        
        var db:OpaquePointer? = nil //資料庫
        var statement:OpaquePointer?=nil //資料記錄
        var sql:String = "" //SQL指令
        
        var oilYear = [String]()
        var oilMonth = [String]()
        var oilLibre = [String]()
        
        
        let fm:FileManager = FileManager()
        
        var src:String = ""
        var dst:String = ""
        
            src = Bundle.main.path(forResource: "OilInfo", ofType: "sqlite")!
            dst = NSHomeDirectory()+"/Documents/OilInfo.sqlite"
            //讀取資料庫
            sql = "SELECT strftime('%Y',fillDate) as Year , strftime('%m',fillDate) as Month,sum(workKM) from FillOil where carid = \(defaultcarid) group by Year,Month order by year desc ,month desc"
        
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
            oilYear.append(String(sqlite3_column_int(statement, 0)))
            oilMonth.append(String(sqlite3_column_int(statement, 1)))
            oilLibre.append(String(format:"%.f",sqlite3_column_double(statement, 2)))
            
        }
        
        
        
        
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
        
        
        return (oilYear,oilMonth,oilLibre)
        
        
        
        
    }


    
    func daysBetweenDate(_ fromDateTime: String, andDate toDateTime: String) -> Int
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fromdate = dateFormatter.date(from: fromDateTime)
        let toDate = dateFormatter.date(from: toDateTime)
 
        //計算日期之間差幾天
        let calendar = Calendar.current
        
        let difference = calendar.dateComponents([.day], from: fromdate!, to: toDate!)
        return difference.day!
        
    
    }
    
    
    
    
    
    
    

    
}
