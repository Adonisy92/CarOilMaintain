//
//  historyViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/1.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class historyViewController: myBaseViewController
{

    
    @IBOutlet weak var history_desc: UITextView!
    
    

    
    @IBAction func click_me(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //myscrollview.contentSize = CGSize(width: 320, height: 3000)

        //history_desc.frame = CGRect(x:0,y:0,width:300,height:3000)
        

        
        history_desc.text = "這是一個給車主方便記錄自己愛車的加油以及維護保養記錄軟體，透過定期的加油記錄，可以知道平均花費多少錢在加油，以及平均油耗。而定期保養則是方便車主了解每次保養所做的細項。\n\nFree版只支援一台車而新油耗維修 Pro能支援多台車。\n\n本軟體歷程記錄：\n\n3.2.7版\n1.使用者界面修改。\n\n3.2.6版\n1.一些 bug的修改\n\n3.2.5版\n1.車圖版本調整。\n2.自動上傳油耗以及觀看油耗統計報表。\n\n3.2.4版\n1.明細的圖片可以利用縮放功能放大。\n\n3.2.3版\n1.修正長按明細的使用者界面。\n\n3.2.2版\n1.bug修正。\n\n3.2.2版\n1.bug修正。\n2.明細表單中可以長按看過去有哪些日期有買過該產品。\n\n3.2.1版\n1.每個車輛都有獨立的保修選單。\n2.新增資料庫結構。\n3.車圖佈置修改。\n4.可以在維修單上傳照片。\n5.在維修主單長按可以直接先看到明細資訊不會換頁。\n6.產品分類與產品可以調整出現順序，把不常用的分類或產品放在下面吧。\n7.產品可以更改分類了。\n\n3.2.0版\n1.修正各種機型呈現資料。\n2.移除上傳油耗資訊。\n\n3.1.0版\n1.修正下載車型車種資料的bug。\n\n3.0.9\n1.界面修正。\n2.油耗輸入修正。\n\n3.0.8版\n1.每月公里圖表。\n2.界面修正。\n\n3.0.7版\n1.支援 iCloud備份還原。\n2.支援 email匯出資料庫。\n\n3.0.6版\n1.界面修正。\n2.支援手勢。\n3.同一天的保修記錄在主單顯示時產品細項不會錯置。\n\n3.0.5版\n1.備份還原車圖與資料庫功能。\n2.bug的修正。\n\n3.0.4版：\n1.油耗可以修改。\n2.油耗可以顯示全部資料。\n3.維修資料可以顯示全部。\n4.bug的修正。\n\n3.0.3版：\n1.bug修正。\n\n3.0.2版：\n1.界面修改。\n\n3.0.1版：\n1.支援ios11，重新改寫程式。\n2.支援備份檔案到自己的Dropbox帳戶。\n3.每輛車都可以設定獨立的油耗計算方式。\n4.可以設定預設車輛是否要顯示。\n5.新的統計圖表支援手勢縮放。\n\n2.1.7版:\n1.支援ios7。\n2.搜尋bug修改。\n\n2.0.7版:\n最新車型資料可由網路下載。\n\n2.0.6版:\n車型資料修改bug修正。\n\n2.0.5版:\n取消裝置id機制，請備份用戶重新備份。\n\n2.0.4版:\n1.油耗可選擇使用總里程或行走里程，總里程僅是幫你換算行走里程。\n2.維護明細若有備註資訊，會有✪呈現。\n3.點選加油明細也會顯示油種與細項資訊。\n\n2.0.3版:\n1.保修記錄主單與明細皆可修改。\n2.搜尋bug修改。\n3.油耗比較界面修改。\n4.明細備註不用換頁即可觀看。\n\n2.0.2版:\n1.車圖比例調整。\n2.輸入備註資訊bug修改。\n\n2.0.1版:\n1.支援備份還原系統資料。\n2.分享油耗至facebook(ios 6適用)。\n3.bug修改。\n\n1.07版:\n1.搜尋捲動bug修改\n2.支援iOS 6作業系統\n\n1.06版:\n1.綜合統計中多出平均一天花費金額。\n2.刪除車籍資料不能刪除車圖的bug修正。\n3.背景圖在未來ios6無法出現的問題解決。\n\n1.05版:\n1.統計數值的 bug修正。\n\n1.04版：\n1.記住上次輸入的油種與油價資訊。\n2.產品分類設定可新增修改與刪除，在「設定」->「進階設定」->「分類設定」中修改。\n3.保修記錄的選單多增加一欄，並可自行修改，在「設定」->「進階設定」->「保修設定」中自行修改。\n4.綜合統計即便只有加油一次依舊會顯示資訊。\n5.支援多國語言(美、日、正體與簡體中文四種語言)\n6.只輸入加油金額會自動換算加油公升\n\n1.03版：\n1.顯示單筆油耗，在「油耗」->「列出明細」可看到。\n\n1.02版：\n1.愛車圖片顯示改善。\n2.加油時輸入現金或刷卡。\n3.加油時選擇油種與是否加滿。\n4.車輛種類選擇。\n5.車輛排氣量與次型號輸入。\n6.資料結構改變，搬移資料庫將連同基本資料移動。\n7.保修備註資料允許多行資訊。\n8.上傳油耗資訊時的資訊變多，將會細分油電、汽油、柴油與機車。\n\n1.01版：\n1.提供油耗上傳，和全世界網友比較油耗資訊(需使用網路)。\n2.提供油耗資訊修改。\n3.圖表功能改善。\n\n1.0版：\n1.提供多輛車籍管理。\n2.提供總里程計算與記錄功能。\n3.資料庫重整功能，此為維護資料庫。\n"

        
    }
    
    @IBAction func right_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

        
    }
    
    
    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated:true)

        
    }


}
