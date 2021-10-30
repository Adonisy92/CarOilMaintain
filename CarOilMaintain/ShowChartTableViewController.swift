//
//  ShowChartTableViewController.swift
//  CarOilMaintain
//
//  Created by YOUNG SEN-MING on 2017/7/19.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit
import Charts

class ShowChartTableViewController: myBaseTableViewController
{

    var inputtype:Int = 0 //點選第幾列而來
    
    var oilStatisticrow = [String]()
    @IBOutlet weak var cell0: UILabel!
    @IBOutlet weak var cell1: UILabel!
    @IBOutlet weak var cell2: UILabel!
    @IBOutlet weak var cell3: UILabel!
    
    @IBOutlet weak var lblDateStart: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    
    @IBOutlet weak var lblMidEnd: UILabel!
    
    
    @IBOutlet weak var lineChartView: LineChartView!

    var txtCharName = [String]() //X軸
    var txtCharValue = [Int]() //Y軸，高度
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        switch inputtype
        {
        case 0:
            navigationItem.title = "一公升跑幾公里"
        case 1:
            navigationItem.title = "百公里耗幾公升"
        case 2:
            navigationItem.title = "一公里花多少錢"
        case 3:
            navigationItem.title = "平均加油金額"
        case 7:
            navigationItem.title = "油價趨勢"
        default:
         break
        }
        
        lineChartView.chartDescription?.textColor = UIColor.white
        lineChartView.gridBackgroundColor = UIColor.darkGray

        lblMidEnd.text = ""
        

    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
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
            
        else if indexPath.row == 3
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


    @IBAction func click_me(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let myst = mystatistic()

        
        switch inputtype
        {
        case 0:
            
            oilStatisticrow = myst.read_limit10_info_cell0()
            
            cell0.text = "\(oilStatisticrow[0])公里"
            cell1.text = "\(oilStatisticrow[1])公里"
            cell2.text = "\(oilStatisticrow[2])公里"
            cell3.text = "\(oilStatisticrow[3])公里"

            let ms = myst.read_limit10_chart_cell0()
            
            txtCharValue = ms.y
            
            
            txtCharName = ms.x
            
            if txtCharName.count != 0
            {
                lblDateStart.text = txtCharName[0]
                lblDateEnd.text = txtCharName[txtCharName.count - 1]
                
                if txtCharName.count > 2
                {
                    
                    lblMidEnd.text = txtCharName[(txtCharName.count - 1)/2]
                    
                }
                
                
            }
                else
            {

                lblDateStart.text = ""
                lblDateEnd.text = ""
                lblMidEnd.text = ""
            
            }
            
            setChart(txtCharName, values: txtCharValue)

        case 1:
            //百公里耗
            oilStatisticrow = myst.read_limit10_info_cell1()
            
            cell0.text = "\(oilStatisticrow[0])公升"
            cell1.text = "\(oilStatisticrow[1])公升"
            cell2.text = "\(oilStatisticrow[2])公升"
            cell3.text = "\(oilStatisticrow[3])公升"
            
            let ms = myst.read_limit10_chart_cell1()
            
            txtCharValue = ms.y
            
            
            txtCharName = ms.x
            
            if txtCharName.count != 0
            {
                lblDateStart.text = txtCharName[0]
                lblDateEnd.text = txtCharName[txtCharName.count - 1]
                if txtCharName.count > 2
                {
                    
                    lblMidEnd.text = txtCharName[(txtCharName.count - 1)/2]
                    
                }

            }
            else
            {
                
                lblDateStart.text = ""
                lblDateEnd.text = ""
                lblMidEnd.text = ""
                
            }
            
            
            setChart(txtCharName, values: txtCharValue)

        case 2:
            //一公里花
            oilStatisticrow = myst.read_limit10_info_cell2()
            
            cell0.text = "\(oilStatisticrow[0])元"
            cell1.text = "\(oilStatisticrow[1])元"
            cell2.text = "\(oilStatisticrow[2])元"
            cell3.text = "\(oilStatisticrow[3])元"
            
            let ms = myst.read_limit10_chart_cell2()
            
            txtCharValue = ms.y
            
            
            txtCharName = ms.x
            
            if txtCharName.count != 0
            {
                lblDateStart.text = txtCharName[0]
                lblDateEnd.text = txtCharName[txtCharName.count - 1]
                if txtCharName.count > 2
                {
                    
                    lblMidEnd.text = txtCharName[(txtCharName.count - 1)/2]
                    
                }

            }
            else
            {
                
                lblDateStart.text = ""
                lblDateEnd.text = ""
                lblMidEnd.text = ""
                
            }
            
            
            setChart(txtCharName, values: txtCharValue)

        case 3:
            //平均加油
            oilStatisticrow = myst.read_limit10_info_cell3()
            
            cell0.text = "\(oilStatisticrow[0])元"
            cell1.text = "\(oilStatisticrow[1])元"
            cell2.text = "\(oilStatisticrow[2])元"
            cell3.text = "\(oilStatisticrow[3])元"
            
            let ms = myst.read_limit10_chart_cell3()
            
            txtCharValue = ms.y
            
            
            txtCharName = ms.x
            
            if txtCharName.count != 0
            {
                lblDateStart.text = txtCharName[0]
                lblDateEnd.text = txtCharName[txtCharName.count - 1]
                if txtCharName.count > 2
                {
                    
                    lblMidEnd.text = txtCharName[(txtCharName.count - 1)/2]
                    
                }

            }
            else
            {
                
                lblDateStart.text = ""
                lblDateEnd.text = ""
                lblMidEnd.text = ""
                
            }
            
            
            setChart(txtCharName, values: txtCharValue)

        case 7:

            //平均加油
            oilStatisticrow = myst.read_limit10_info_cell6()
            
            cell0.text = "\(oilStatisticrow[0])元"
            cell1.text = "\(oilStatisticrow[1])元"
            cell2.text = "\(oilStatisticrow[2])元"
            cell3.text = "\(oilStatisticrow[3])元"
            
            let ms = myst.read_limit10_chart_cell6()
            
            txtCharValue = ms.y
            
            
            txtCharName = ms.x
            
            if txtCharName.count != 0
            {
                lblDateStart.text = txtCharName[0]
                lblDateEnd.text = txtCharName[txtCharName.count - 1]
                if txtCharName.count > 2
                {
                    
                    lblMidEnd.text = txtCharName[(txtCharName.count - 1)/2]
                    
                }

            }
            else
            {
                
                lblDateStart.text = ""
                lblDateEnd.text = ""
                lblMidEnd.text = ""
                
            }
            
            
            setChart(txtCharName, values: txtCharValue)

            
        default:
            break
        }
        
        
        
        
        
    }
    

    func setChart(_ dataPoints: [String], values: [Int])
    {
        
        var dataEntries: [ChartDataEntry] = []
        
        //Coloring
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        
        
        
        for i in 0..<dataPoints.count {
            
            
            let dataEntry = ChartDataEntry(x:Double(i) , y: Double(values[i]))//暫改
            
            
            
            
            dataEntries.append(dataEntry)
        }
        
        var label:String = ""
        
        switch inputtype
        {
        case 0:
            label = "油耗統計圖（公里）"
        case 1:

            label = "油耗統計圖（公升）"

            
        case 2:
            
            label = "油耗統計圖（元）"

            
        case 3:
            
            label = "油耗統計圖（元）"

            
        case 7:
            
            label = "油價趨勢圖（元）"

            
        default:
            break
        }
        
        
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: label)
        
        
        
        lineChartDataSet.axisDependency = YAxis.AxisDependency.left // Line will correlate with left axis values
        lineChartDataSet.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        lineChartDataSet.setCircleColor(UIColor.red) // our circle will be dark red
        
        
        lineChartDataSet.drawFilledEnabled = true
        //color graph
        lineChartDataSet.colors = [color]
        
        
        
        lineChartDataSet.lineWidth = 5.0
        lineChartDataSet.circleRadius = 1.0 // the radius of the node circle
        lineChartDataSet.fillAlpha = 65 / 255.0
        lineChartDataSet.fillColor = UIColor.blue
        //lineChartDataSet.highlightColor = UIColor.blueColor()
        lineChartDataSet.drawCircleHoleEnabled = true

        
        var dataSets = [IChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        let lineChartData = LineChartData(dataSets: dataSets)
                
        
        lineChartData.setValueTextColor(UIColor.clear)
        
        lineChartView.data = lineChartData
        lineChartView.chartDescription?.text = ""
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelTextColor = UIColor.clear
        lineChartView.leftAxis.labelTextColor = UIColor.white
        
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)//新加入
        
        lineChartView.xAxis.granularity = 1
        
        
        lineChartView.xAxis.labelPosition = .bottom
        
        
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        
        
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
