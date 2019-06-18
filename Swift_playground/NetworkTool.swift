//
//  NetworkTool.swift
//  Swift_playground
//
//  Created by yesdgq on 2018/1/19.
//  Copyright © 2018年 yesdgq. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXMLParser
import SwiftyJSON

enum NetRequestMethodType {
    case GET
    case POST
}

class NetworkTool {
    class func requestData(_ requestType: NetRequestMethodType, URLString: String, parameters: [String : Any]?, completionHandler: @escaping (_ result: Any) -> ()) {
        
        let headers:HTTPHeaders = ["Content-type" : "application/json",
                                   "Accept"       : "application/json"]
        // 1.获取类型
        let method = requestType == .GET ? HTTPMethod.get : HTTPMethod.post
        // 2.发送网络请求
        
        
        // 响应数据 Handler
        // responseData使用responseDataSerializer（这个对象把服务器的数据序列化成其他类型）来提取服务器返回的数据。
        //        Alamofire.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { (response) in
        //
        //            let data = response.result.value
        //            guard let XMLString = String(data: data!, encoding: .utf8) else {
        //                DONG_Log(response.result.error!)
        //                return
        //            }
        //
        //            // 工具1
        //            let dict =  try! XMLReader.dictionary(forXMLString: XMLString)
        //            // 工具2
        ////            let xmlParser = XMLDictionaryParser()
        ////            let dictionary = xmlParser.dictionary(with: XMLString)
        //
        //            complitionHandler(dict)
        //        }
        
        // 响应 Handler：response/responseData/responseString/responseJSON/responsePropertyList
        Alamofire.request(URLString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            DONG_Log("Request：\(response.request!)")  // 原始的URL请求
            //DONG_Log("Response：\(response.response!)") // HTTP URL响应
            DONG_Log("Data：\(response.data!)")     // 服务器返回的数据
            DONG_Log("Result：\(response.result)")   // 响应序列化结果，在这个闭包里，存储的是JSON数据
            
            
                        switch response.result {
            
                        case .success:
            
                            DONG_Log("成功")
                        case .failure:
                            
                            DONG_Log("失败")
                        }
            
            
            guard let data = response.result.value  else {
                DONG_Log("Error: \(response.result.error!)")
                
                return
            }
            
            
            // 1 responseData序列化 解析一
            //            do {
            //                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //                let dic = json as! Dictionary<String, Any>
            //                DONG_Log("dic:\(dic)")
            //
            //                completionHandler(dic)
            //
            //            } catch {
            //                DONG_Log("获取data失败")
            //
            //            }
            //
            //            // 2 responseData序列化 解析二
            //            do {
            //                let jsonData = try JSON(data: data)
            //                DONG_Log(jsonData)
            //
            //                DONG_Log(jsonData["resultCode"])
            //                DONG_Log(jsonData["resultMessage"])
            //
            //            } catch {
            //
            //            }
            
            
                       // 1 responseJSON序列化 解析一
                        let jsonData = data as! Dictionary<String, Any>
            
                        DONG_Log("jsonData: \(jsonData)")
                        DONG_Log(jsonData["resultCode"])
                        DONG_Log(jsonData["resultMessage"])
            
            
            //            // 2 responseJSON序列化 解析二
            //            let jsonData = JSON(data)
            //            DONG_Log("jsonData: \(jsonData)")
            //            DONG_Log(jsonData["resultCode"])
            //            DONG_Log(jsonData["resultMessage"])
            
        }
    }
    
    
    
    // 配置header，可以自定义
    func configHeaders() -> HTTPHeaders {
        
        let headers:HTTPHeaders = ["Content-type":"application/json;charset=utf-8",
                                   "Accept":"application/json",
                                   "systemtype":"ios",
                                   "channel":"00",
                                   "Authorization":""]
        
        return headers
    }
}
