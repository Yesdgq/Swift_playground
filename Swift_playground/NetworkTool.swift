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

enum NetRequestMethodType {
    case GET
    case POST
}

class NetworkTool {
    class func requestData(_ requestType: NetRequestMethodType, URLString: String, parameters: [String : Any]?, finishedHandler: @escaping (_ result: Any) -> ()) {
        
        let headers:HTTPHeaders = ["Content-type" : "application/json;charset=utf-8",
                                   "Accept"       : "application/json"]
        // 1.获取类型
        let method = requestType == .GET ? HTTPMethod.get : HTTPMethod.post
        // 2.发送网络请求
        
        
        // 响应数据 Handler
        // responseData使用responseDataSerializer（这个对象把服务器的数据序列化成其他类型）来提取服务器返回的数据。
        Alamofire.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            let data = response.result.value
            guard let XMLString = String(data: data!, encoding: .utf8) else {
                DONG_Log(response.result.error!)
                return
            }
            
            // 工具1
            let dict =  try! XMLReader.dictionary(forXMLString: XMLString)
            // 工具2
//            let xmlParser = XMLDictionaryParser()
//            let dictionary = xmlParser.dictionary(with: XMLString)
            
            finishedHandler(dict)
            
            
//            // 响应 JSON Handler
//            Alamofire.request(URLString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//                guard let JSON = response.result.value else {
//                    DONG_Log(response.result.error!)
//                    return
//                }
//                callback(JSON)
//            }
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
