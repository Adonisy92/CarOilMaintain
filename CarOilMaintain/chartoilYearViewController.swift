//
//  chartoilYearViewController.swift
//  CarOilMaintain
//
//  Created by Mac on 2017/7/19.
//  Copyright © 2017年 YOUNG SEN-MING. All rights reserved.
//

import UIKit
import Charts

class chartoilYearViewController: myBaseViewController
{
    
    var inputtype:Int = 4
    var x = [String]()
    var y = [Int]()

    @IBOutlet weak var lineChartView: LineChartView!

    @IBOutlet weak var lblStartYear:UILabel!
    @IBOutlet weak var lblEndYear:UILabel!
    @IBOutlet weak var lblMidYear:UILabel!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblMidYear.text = ""

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let st = mystatistic()
        
        let mytools = mytool()
        
        let defaultcarid = mytools.read_car_default()
        
        let carinfo = mytools.read_car_info(defaultcarid: defaultcarid)
        

        /*
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ] //titile 改白色
   
         待改
         */
         
        switch inputtype
        {
        case 4:
            
            navigationItem.title = "\(carinfo[1])年月油錢"
            let st1 = st.read_limit10_chart_cell4()
            
            x = st1.x
            y = st1.y

            
        case 5:
            
            
            navigationItem.title = "\(carinfo[1])每年油錢"
            let st1 = st.read_limit10_chart_cell5()
            
            x = st1.x
            y = st1.y
            
            
        case 6:
            
            
            navigationItem.title = "\(carinfo[1])年月公里"
            let st1 = st.read_limit10_chart_cell66()
            
            x = st1.x
            y = st1.y

            
            
        default:
            break
        }
        
        
        setChart(x, values: y)
        if x.count != 0
        {
            lblStartYear.text = x[0]
            lblEndYear.text = x[x.count - 1]
            if x.count > 2
            {
                
                lblMidYear.text = x[(x.count - 1)/2]
                
            }
            
            
        }
        else
        {
        
            lblEndYear.text = ""
            lblStartYear.text = ""
            lblMidYear.text = ""
        
        }

        
    }

    @IBAction func click_me(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
        
        
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
        case 4:
            label = "年月油錢"
        case 5:
            
            label = "每年油錢"
            
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

        self.navigationController?.popViewController(animated: true)

        
    }

    
    @IBAction func left_click(_ sender: UISwipeGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: true)

        
    }

}
