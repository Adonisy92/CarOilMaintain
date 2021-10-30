//
//  StatisticMainViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/11.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit

class StatisticMainViewController: UIViewController {
    
    @IBOutlet weak var carimg: UIImageView!
    //var carimg = UIImageView()
    var defaultcarid:String = "0"
    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask

    var paths  = [String]()
    
    var oilStatistic:Float = 0.0 //平均每n天加油一次

    var xwidth:Int = 1 //1，橫 2方，3直

    
    @IBOutlet weak var mytext: UITextView!
    //let mytext = UITextView()

    

    var myscreensize:Int = 1


    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //self.view.backgroundColor = UIColor.brown
        self.view.backgroundColor = UIColor(red: 153.0/255.0, green: 102.0/255.0, blue: 51.0/255.0, alpha: 1.0)

        
        NotificationCenter.default.addObserver(self, selector: #selector(StatisticMainViewController.reloadimg), name: NSNotification.Name(rawValue: "refreshimg"), object: nil)


        NotificationCenter.default.addObserver(self, selector: #selector(StatisticMainViewController.refreshtext), name: NSNotification.Name(rawValue: "refreshtext"), object: nil)
        

        
        
        
        //self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 500, vertical: 600)

        /*
        let deviceType = UIDevice().type

        
        
        switch deviceType
        {
            

        case .iPhoneSE:
            
            //print("4吋")
            myscreensize = 1
            

            
        case .iPhone7,.iPhone6,.iPhone6S,.iPhone8,.iPhoneSE2:
            
            //print("4.7吋")
            
            myscreensize = 2

            
        case .iPhone7Plus,.iPhone6Plus,.iPhone6SPlus,.iPhone8Plus,.iPhone12Mini,.iPhone13Mini:
            //print("5.5吋")
            
            myscreensize = 3
            

        case .iPhoneX,.iPhoneXS,.iPhone11Pro:
            
            //5.8吋
            
            myscreensize = 4
            
            
        case .iPhoneXR,.iPhone11,.iPhone12,.iPhone13,.iPhone13Pro,.iPhone12Pro:
            
            //6.1吋
            
            myscreensize = 5
            
        case .iPhoneXSMax,.iPhone11ProMax,.iPhone12ProMax,.iPhone13ProMax:
            
            //6.5吋
            
            myscreensize = 6
            
            
            
        default:
            break
        }

        */
        

    
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        let tmpimg: UIView? = (view.viewWithTag(100))
        if tmpimg != nil
        {
            tmpimg?.removeFromSuperview()
        }

        //mytext.tag = 100
        self.reloadimg()
        self.refreshtext()
        
        
    }
    
    @objc func refreshtext()
    {

        
        //var myscreensize:Int = 1
        //var textY:Int = 0
        
        var total_km:String = ""
        var total_libre:String = ""
        var total_money:String = ""
        var maintain_A:String = ""
        var maintain_B:String = ""
        var maintain_C:String = ""
        
                
        //計算

        /*
        
        switch myscreensize
        {
        case 1://4吋  iphone SE OK
            
            mytext.font = UIFont.boldSystemFont(ofSize: 14)
            
            switch self.xwidth //長寬比
            {
            case 1:
                textY = 340
                mytext.frame = CGRect(x: 10, y: textY, width: 300, height: 170)
                mytext.isScrollEnabled = false

            case 2:
                
                textY = 390
                mytext.frame = CGRect(x: 10, y: textY, width: 300, height: 110)
                mytext.isScrollEnabled = true

                
            case 3:
                
                textY = 430
                mytext.frame = CGRect(x: 10, y: textY, width: 300, height: 100)
                mytext.isScrollEnabled = true

                
            default: break
                
            }

            
            break
            
        case 2://4.7吋 iphone 7 OK
            
            mytext.font = UIFont.boldSystemFont(ofSize: 16)

            
            switch self.xwidth //長寬比
            {
            case 1:
                textY = 410
                mytext.frame = CGRect(x: 20, y: textY, width: 400, height: 190)
                mytext.isScrollEnabled = false
                
            case 2:
                
                textY = 440
                mytext.frame = CGRect(x: 20, y: textY, width: 400, height: 160)
                mytext.isScrollEnabled = true
                
                
            case 3:
                
                textY = 480
                mytext.frame = CGRect(x: 20, y: textY, width: 400, height: 110)
                mytext.isScrollEnabled = true
                
                
            default: break
                
            }

            
            
            break
            
        case 3://5.5吋  iphone13mini OK
            
            mytext.font = UIFont.boldSystemFont(ofSize: 18)
            
            switch self.xwidth //長寬比
            {
            case 1:
                textY = 440
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
            case 2:
                
                textY = 490
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
                
            case 3:
                
                textY = 510
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 200)
                mytext.isScrollEnabled = true
                
                
            default: break
                
            }
            
        case 4:// 5.8吋 iPhone11Pro OK
            
            

            mytext.font = UIFont.boldSystemFont(ofSize: 18)
            
            switch self.xwidth //長寬比
            {
            case 1:
                textY = 460
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
            case 2:
                
                textY = 490
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
                
            case 3:
                
                textY = 520
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = true
                
                
            default: break
                
            }

            
        case 5:// 6.1吋 iPhone13Pro ok
            
            
            mytext.font = UIFont.boldSystemFont(ofSize: 18)
            
            switch self.xwidth //長寬比
            {
            case 1:
                textY = 440
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
            case 2:
                
                textY = 490
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
                
            case 3:
                
                textY = 550
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = true
                
                
            default: break
                
            }
            
            


        case 6:// 6.5吋 iPhone13Promax ok

            mytext.font = UIFont.boldSystemFont(ofSize: 18)
            
            switch self.xwidth //長寬比
            {
            case 1:
                textY = 500
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
            case 2:
                
                textY = 530
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = false
                
                
            case 3:
                
                textY = 600
                mytext.frame = CGRect(x: 15, y: textY, width: 400, height: 250)
                mytext.isScrollEnabled = true
                
                
            default: break
                
            }

            
            
            break
        default:
            break
        }
         
         */

        
        mytext.backgroundColor = .clear
        mytext.isEditable = false

        let st = mystatistic()
        let ms = st.read_totalkm_statistic()
        total_km = ms.totalkm
        total_libre = ms.totalLibre
        total_money = ms.totalMoney
        
        let ms1 = st.read_maintain_menu_statistic()
        
        maintain_A = ms1.maintain_A
        maintain_B = ms1.maintain_B
        maintain_C = ms1.maintain_C
        
        if maintain_A == "0"
        {
        
            maintain_A = "$0"
        
        }

        if maintain_B == "0"
        {
            
            maintain_B = "$0"
            
        }

        if maintain_C == "0"
        {
            
            maintain_C = "$0"
            
        }

        let ms3 = st.read_total_money()
        
        var totalMoney = st.formatCurrency(value: ms3)

        
        if totalMoney == "0"
        {
            totalMoney = "$0"
        }
        
        //相差天數,取出今天與 birthday
        
        let mytools = mytool()
        
        let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)

        let differentDay = st.daysBetweenDate(carinfo[4], andDate: today)

        let onedaycost = ms3 / Double(differentDay)
        
        var onedayString:String = ""
        
        
        if onedaycost.isNaN
        {
        
            onedayString = "$0"
        
        }
        else
        {
            onedayString = st.formatCurrency(value: onedaycost)
        }
        //每隔多久加一次油
        
        var oilday: Float = 0

        
        let oilStatistic = st.read_statistic_date()
        var oilnum = [Int]()
        
        if oilStatistic.count != 0 && oilStatistic.count != 1
        {
            for i in 0..<oilStatistic.count
            {
                if i + 1 < oilStatistic.count
                {
                    let a = st.daysBetweenDate(oilStatistic[i], andDate: oilStatistic[i + 1])
                    oilnum.append(a)
                }
            }

            var tempj:Int = 0
            var sum:Int = 0
            
            for j in 0..<oilnum.count
            {
                tempj = oilnum[j]
                sum = sum + tempj
            }
            
            oilday = Float(sum) / Float(oilnum.count)

            
            
            
            
        }
        
        let oildayString = String(format: "%.f", oilday)
        
        let menu = mytools.read_maintain_menu()
        

        mytext.text = "行駛里程\(total_km)公里使用\(total_libre)公升汽油\n加油金額為\(total_money)元\n平均每\(oildayString)天加油一次\n\(menu[0])總金額為 \(maintain_A)元\n\(menu[1])總金額為 \(maintain_B)元\n\(menu[2])總金額為 \(maintain_C)元\n平均一天花費 \(onedayString)元\n－－－－－－－－－－－－－－－－－\n總計花費 \(totalMoney)元"
        
        //self.view.addSubview(mytext)

        
        
    }
    
    @objc func reloadimg()
    {
        
        let mytools = mytool()
        
        defaultcarid = mytools.read_car_default()
        
        paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath          = paths.first
        {
            
            //let screenSize: CGRect = UIScreen.main.bounds
            
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
            if !fileManager.fileExists(atPath: imageURL.path)
            {
                
                //檢查有沒有 images目錄

                
            }
            else
            {
            
                image    = UIImage(contentsOfFile: imageURL.path)
                // Do whatever you want with the image

            
            }
            

            /*
            
            if let x = image?.size.width,
                let y = image?.size.height
            {
                
                
                if x > y //橫
                {

                    self.xwidth = 1
                    
                }
                else if x == y //正方
                {
                    
                    self.xwidth = 2
                    
                }
                else //直
                {
                    
                    self.xwidth = 3
                    
                }
                
            }
            
             */

            

            //carimg.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
            
            /*
            switch self.xwidth //長寬比
            {
            case 1:
                
                //carimg.frame = CGRect(x: 10, y: 120, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)

                carimg.frame = CGRect(x: 0, y: 0, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)


            case 2:
                
                //carimg.frame = CGRect(x: 20, y: 120, width: screenSize.width - 50, height: screenSize.width - 50 )

                carimg.frame = CGRect(x: 0, y: 0, width: screenSize.width - 50, height: screenSize.width - 50 )


            case 3:
                

                //carimg.frame = CGRect(x: 50, y: 120, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)

                carimg.frame = CGRect(x: 0, y: 0, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)


 
                
            default: break
                
            }
            
             */
            
            /*
            
            switch myscreensize
             {
             case 1://4吋
                 
                 
                 switch self.xwidth //長寬比
                 {
                 case 1:
                     
                     carimg.frame = CGRect(x: 10, y: 120, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)


                 case 2:
                     
                     carimg.frame = CGRect(x: 20, y: 120, width: screenSize.width - 50, height: screenSize.width - 50 )

     
                 case 3:
                     

                     carimg.frame = CGRect(x: 50, y: 120, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)


      
                     
                 default: break
                     
                 }

                 
                 
             case 2://4.7吋
                 

                 
                switch self.xwidth //長寬比
                {
                case 1:
                    
                    carimg.frame = CGRect(x: 10, y: 120, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)


                case 2:
                    
                    carimg.frame = CGRect(x: 20, y: 120, width: screenSize.width - 50, height: screenSize.width - 50 )

    
                case 3:
                    
                    carimg.frame = CGRect(x: 50, y: 120, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)


     
                    
                default: break
                    
                }

                 
                 
                 
             case 3://5.5吋
                 
                 
                switch self.xwidth //長寬比
                {
                case 1:
                    
                    carimg.frame = CGRect(x: 10, y: 150, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)


                case 2:
                    
                    carimg.frame = CGRect(x: 20, y: 150, width: screenSize.width - 50, height: screenSize.width - 50 )

    
                case 3:
                    
                    carimg.frame = CGRect(x: 50, y: 150, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)


     
                    
                default: break
                    
                }

             case 4:// 5.8吋
                 
                switch self.xwidth //長寬比
                {
                case 1:
                    
                    carimg.frame = CGRect(x: 10, y: 160, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)


                case 2:
                    
                    carimg.frame = CGRect(x: 20, y: 160, width: screenSize.width - 50, height: screenSize.width - 50 )

    
                case 3:
                    
                    carimg.frame = CGRect(x: 50, y: 150, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)


     
                    
                default: break
                    
                }

                 


                 
             case 5:// 6.1吋
                 
                 
                 
                switch self.xwidth //長寬比
                {
                case 1:
                    
                    carimg.frame = CGRect(x: 10, y: 150, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)


                case 2:
                    
                    carimg.frame = CGRect(x: 20, y: 150, width: screenSize.width - 50, height: screenSize.width - 50 )

    
                case 3:
                    
                    carimg.frame = CGRect(x: 50, y: 150, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)


     
                    
                default: break
                    
                }

                 


             case 6:// 6.5吋


                switch self.xwidth //長寬比
                {
                case 1:
                    
                    carimg.frame = CGRect(x: 10, y: 150, width: screenSize.width - 20 , height: (screenSize.width - 20) * 0.75)


                case 2:
                    
                    carimg.frame = CGRect(x: 20, y: 150, width: screenSize.width - 50, height: screenSize.width - 50 )

    
                case 3:
                    
                    carimg.frame = CGRect(x: 50, y: 150, width: screenSize.width - 100, height: (screenSize.width - 100) / 0.75)


     
                    
                default: break
                    
                }

            
            default:
                 break
             }
            
            */
            
            
            
            
            carimg.image = image
            carimg.contentMode = .scaleAspectFit
        
            //self.view.addSubview(carimg)
            
            
        }
        
        
        
    }

    

}


public enum Model : String {

//Simulator
case simulator     = "simulator/sandbox",

//iPod
iPod1              = "iPod 1",
iPod2              = "iPod 2",
iPod3              = "iPod 3",
iPod4              = "iPod 4",
iPod5              = "iPod 5",
iPod6              = "iPod 6",
iPod7              = "iPod 7",

//iPad
iPad2              = "iPad 2",
iPad3              = "iPad 3",
iPad4              = "iPad 4",
iPadAir            = "iPad Air ",
iPadAir2           = "iPad Air 2",
iPadAir3           = "iPad Air 3",
iPadAir4           = "iPad Air 4",
iPad5              = "iPad 5", //iPad 2017
iPad6              = "iPad 6", //iPad 2018
iPad7              = "iPad 7", //iPad 2019
iPad8              = "iPad 8", //iPad 2020
iPad9              = "iPad 9", //iPad 2021

//iPad Mini
iPadMini           = "iPad Mini",
iPadMini2          = "iPad Mini 2",
iPadMini3          = "iPad Mini 3",
iPadMini4          = "iPad Mini 4",
iPadMini5          = "iPad Mini 5",
iPadMini6          = "iPad Mini 6",

//iPad Pro
iPadPro9_7         = "iPad Pro 9.7\"",
iPadPro10_5        = "iPad Pro 10.5\"",
iPadPro11          = "iPad Pro 11\"",
iPadPro2_11        = "iPad Pro 11\" 2nd gen",
iPadPro3_11        = "iPad Pro 11\" 3rd gen",
iPadPro12_9        = "iPad Pro 12.9\"",
iPadPro2_12_9      = "iPad Pro 2 12.9\"",
iPadPro3_12_9      = "iPad Pro 3 12.9\"",
iPadPro4_12_9      = "iPad Pro 4 12.9\"",
iPadPro5_12_9      = "iPad Pro 5 12.9\"",

//iPhone
iPhone4            = "iPhone 4",
iPhone4S           = "iPhone 4S",
iPhone5            = "iPhone 5",
iPhone5S           = "iPhone 5S",
iPhone5C           = "iPhone 5C",
iPhone6            = "iPhone 6",
iPhone6Plus        = "iPhone 6 Plus",
iPhone6S           = "iPhone 6S",
iPhone6SPlus       = "iPhone 6S Plus",
iPhoneSE           = "iPhone SE",
iPhone7            = "iPhone 7",
iPhone7Plus        = "iPhone 7 Plus",
iPhone8            = "iPhone 8",
iPhone8Plus        = "iPhone 8 Plus",
iPhoneX            = "iPhone X",
iPhoneXS           = "iPhone XS",
iPhoneXSMax        = "iPhone XS Max",
iPhoneXR           = "iPhone XR",
iPhone11           = "iPhone 11",
iPhone11Pro        = "iPhone 11 Pro",
iPhone11ProMax     = "iPhone 11 Pro Max",
iPhoneSE2          = "iPhone SE 2nd gen",
iPhone12Mini       = "iPhone 12 Mini",
iPhone12           = "iPhone 12",
iPhone12Pro        = "iPhone 12 Pro",
iPhone12ProMax     = "iPhone 12 Pro Max",
iPhone13Mini       = "iPhone 13 Mini",
iPhone13           = "iPhone 13",
iPhone13Pro        = "iPhone 13 Pro",
iPhone13ProMax     = "iPhone 13 Pro Max",

// Apple Watch
AppleWatch1         = "Apple Watch 1gen",
AppleWatchS1        = "Apple Watch Series 1",
AppleWatchS2        = "Apple Watch Series 2",
AppleWatchS3        = "Apple Watch Series 3",
AppleWatchS4        = "Apple Watch Series 4",
AppleWatchS5        = "Apple Watch Series 5",
AppleWatchSE        = "Apple Watch Special Edition",
AppleWatchS6        = "Apple Watch Series 6",

//Apple TV
AppleTV1           = "Apple TV 1gen",
AppleTV2           = "Apple TV 2gen",
AppleTV3           = "Apple TV 3gen",
AppleTV4           = "Apple TV 4gen",
AppleTV_4K         = "Apple TV 4K",
AppleTV2_4K        = "Apple TV 4K 2gen",

unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

    public extension UIDevice {
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
    
        let modelMap : [String: Model] = [
    
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,
    
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPod7,1"   : .iPod6,
            "iPod9,1"   : .iPod7,
    
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            "iPad7,11"  : .iPad7, //iPad 2019
            "iPad7,12"  : .iPad7,
            "iPad11,6"  : .iPad8, //iPad 2020
            "iPad11,7"  : .iPad8,
            "iPad12,1"  : .iPad9, //iPad 2021
            "iPad12,2"  : .iPad9,
    
            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            "iPad14,1"  : .iPadMini6,
            "iPad14,2"  : .iPadMini6,
    
            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,9"   : .iPadPro2_11,
            "iPad8,10"  : .iPadPro2_11,
            "iPad13,4"  : .iPadPro3_11,
            "iPad13,5"  : .iPadPro3_11,
            "iPad13,6"  : .iPadPro3_11,
            "iPad13,7"  : .iPadPro3_11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            "iPad8,11"  : .iPadPro4_12_9,
            "iPad8,12"  : .iPadPro4_12_9,
            "iPad13,8"  : .iPadPro5_12_9,
            "iPad13,9"  : .iPadPro5_12_9,
            "iPad13,10" : .iPadPro5_12_9,
            "iPad13,11" : .iPadPro5_12_9,
    
            //iPad Air
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            "iPad13,1"  : .iPadAir4,
            "iPad13,2"  : .iPadAir4,
            
    
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,8" : .iPhoneSE2,
            "iPhone13,1" : .iPhone12Mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,
            "iPhone14,4" : .iPhone13Mini,
            "iPhone14,5" : .iPhone13,
            "iPhone14,2" : .iPhone13Pro,
            "iPhone14,3" : .iPhone13ProMax,
            
            // Apple Watch
            "Watch1,1" : .AppleWatch1,
            "Watch1,2" : .AppleWatch1,
            "Watch2,6" : .AppleWatchS1,
            "Watch2,7" : .AppleWatchS1,
            "Watch2,3" : .AppleWatchS2,
            "Watch2,4" : .AppleWatchS2,
            "Watch3,1" : .AppleWatchS3,
            "Watch3,2" : .AppleWatchS3,
            "Watch3,3" : .AppleWatchS3,
            "Watch3,4" : .AppleWatchS3,
            "Watch4,1" : .AppleWatchS4,
            "Watch4,2" : .AppleWatchS4,
            "Watch4,3" : .AppleWatchS4,
            "Watch4,4" : .AppleWatchS4,
            "Watch5,1" : .AppleWatchS5,
            "Watch5,2" : .AppleWatchS5,
            "Watch5,3" : .AppleWatchS5,
            "Watch5,4" : .AppleWatchS5,
            "Watch5,9" : .AppleWatchSE,
            "Watch5,10" : .AppleWatchSE,
            "Watch5,11" : .AppleWatchSE,
            "Watch5,12" : .AppleWatchSE,
            "Watch6,1" : .AppleWatchS6,
            "Watch6,2" : .AppleWatchS6,
            "Watch6,3" : .AppleWatchS6,
            "Watch6,4" : .AppleWatchS6,
    
            //Apple TV
            "AppleTV1,1" : .AppleTV1,
            "AppleTV2,1" : .AppleTV2,
            "AppleTV3,1" : .AppleTV3,
            "AppleTV3,2" : .AppleTV3,
            "AppleTV5,3" : .AppleTV4,
            "AppleTV6,2" : .AppleTV_4K,
            "AppleTV11,1" : .AppleTV2_4K
        ]
    
        guard let mcode = modelCode, let map = String(validatingUTF8: mcode), let model = modelMap[map] else { return Model.unrecognized }
        if model == .simulator {
            if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                if let simMap = String(validatingUTF8: simModelCode), let simModel = modelMap[simMap] {
                    return simModel
                }
            }
        }
        return model
        }
    }



