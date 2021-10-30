import Foundation
import UIKit

class myWebService:NSObject, XMLParserDelegate
{
    
    
    func reg_oil_user(car_info:Array<String>)
    {
        //輸入車子的陣列
        //["54", "脆瓜", "M-Benz", "S-Class", "1974-09-10", "藍", "", "0", "0", "", "0", "0"]

        //car_name:car_info[1]
        //default_car:car_info[0]
        //car_Company:car_info[2]
        //car_Style:car_info[3]
        //car_type:car_info[11]
        //car_cc:car_info[8]
        //car_subtype:car_info[9]
        //carid,carNickName,carCompany,carStyle,carBirthday,carColor,carimg,uploadOilDeviceID,carcc,subcarStyle,oilplace,cartype from car where carid = \(defaultcarid)"


        guard let url = URL(string: "http://adonisy94.westus.cloudapp.azure.com/oilinfo/Products.asmx?op=insert_Device_Oil") else {return}
        var request = URLRequest(url: url)
        
        let soapMessage =
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " + "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" " + "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
          "<soap:Body>" +
            "<insert_Device_Oil xmlns=\"http://tempuri.org/\">" +
              "<car_name>\(car_info[1])</car_name>" +
              "<default_car>\(car_info[0])</default_car>" +
              "<car_Company>\(car_info[2])</car_Company>" +
              "<car_Style>\(car_info[3])</car_Style>" +
              "<car_type>\(car_info[11])</car_type>" +
              "<car_cc>\(car_info[8])</car_cc>" +
              "<car_subtype>\(car_info[9])</car_subtype>" +
            "</insert_Device_Oil>" +
          "</soap:Body>" +
        "</soap:Envelope>"
        
        let msgLength = String(soapMessage.count)
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: .utf8,allowLossyConversion: false)
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("http://tempuri.org/insert_Device_Oil", forHTTPHeaderField: "SOAPAction")
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                                
                            }
            else{
                
                let parser = XMLParser(data: data!)
                    parser.delegate = self
                    parser.parse()
                
            }}.resume()

        //要能回傳 device id
   
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        print(string)
        //更新 updatedevieid
        let mytools = mytool()
        mytools.updateOilDeviceID(deviceID: string)
  
        
        
    }
    
    func upload_oil(deviceid:String,walkkm:String,litre:String)
    {
        
        
        guard let url = URL(string: "http://adonisy94.westus.cloudapp.azure.com/oilinfo/Products.asmx?op=updateOil") else {return}
        var request = URLRequest(url: url)
        
        let soapMessage =
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " + "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" " + "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
          "<soap:Body>" +
            "<updateOil xmlns=\"http://tempuri.org/\">" +
              "<deviceid>\(deviceid)</deviceid>" +
              "<totalwork>\(walkkm)</totalwork>" +
              "<totallitre>\(litre)</totallitre>" +
            "</updateOil>" +
          "</soap:Body>" +
        "</soap:Envelope>"
        
        let msgLength = String(soapMessage.count)
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: .utf8,allowLossyConversion: false)
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("http://tempuri.org/updateOil", forHTTPHeaderField: "SOAPAction")
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                                
                            }
            else{
                
                
            }}.resume()
        
        
        
    }
    
    
    
    func update_oil_user(car_info:Array<String>)
    {
        //輸入車子的陣列
        //["54", "脆瓜", "M-Benz", "S-Class", "1974-09-10", "藍", "", "0", "0", "", "0", "0"]

        //car_name:car_info[1]
        //default_car:car_info[0]
        //car_Company:car_info[2]
        //car_Style:car_info[3]
        //car_type:car_info[11]
        //car_cc:car_info[8]
        //car_subtype:car_info[9]
        //carid,carNickName,carCompany,carStyle,carBirthday,carColor,carimg,uploadOilDeviceID,carcc,subcarStyle,oilplace,cartype from car where carid = \(defaultcarid)"


        guard let url = URL(string: "http://adonisy94.westus.cloudapp.azure.com/oilinfo/Products.asmx?op=update_Device") else {return}
        var request = URLRequest(url: url)
        
        let soapMessage =
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " + "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" " + "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
          "<soap:Body>" +
            "<update_Device xmlns=\"http://tempuri.org/\">" +
        "<device_id>\(car_info[7])</device_id>" +
              "<car_Company>\(car_info[2])</car_Company>" +
              "<car_Style>\(car_info[3])</car_Style>" +
              "<car_type>\(car_info[11])</car_type>" +
              "<car_cc>\(car_info[8])</car_cc>" +
              "<car_subtype>\(car_info[9])</car_subtype>" +
            "</update_Device>" +
          "</soap:Body>" +
        "</soap:Envelope>"
        
        let msgLength = String(soapMessage.count)
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: .utf8,allowLossyConversion: false)
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("http://tempuri.org/update_Device", forHTTPHeaderField: "SOAPAction")
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                
                print("error")
                                
                            }
            else{
                
                
            }}.resume()

        //要能回傳 device id
   
    }
    

}
