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

enum NetRequestMethodType: String {
    case GET = "GET"
    case POST = "POST"
}

// MARK: - 网络请求返回的数据类型
enum DataResult<T> {
    case success(T)         // 返回成功 返回数据
    case failure(NSError)   // 返回失败 返回error
}

extension DataResult {
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: T? {
        switch self {
        case .success(let value):
            return value;
        case .failure:
            return nil
        }
    }
    
    public var error: NSError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

// MARK: - 接口协议
protocol URLConfig {
    func getPath() -> String
}

// MARK: - 接口环境
struct NetConfig {
    static var curServerIP = "app.sms.huhutv.com.cn"
    static var devIP = "192.168.22.16"
}


// MARK: - 接口枚举定义 生产环境
enum InterFaceEnum: String, URLConfig {
    case checkPassword = "1836/server-run/ws/rest/Login/checkPwd"
    case GetShortMsgUrl = "1836/server-run/ws/rest/Login/getShortMsg"
    
    func getPath() -> String {
        let url = "https://" + NetConfig.curServerIP + ":\(self.rawValue)"
        return url
    }
}

// MARK: - 接口枚举定义 测试环境
enum DevInterFaceEnum: String, URLConfig {
    case checkPassword = "1836/server-run/ws/rest/Login/checkPwd"
    case GetShortMsgUrl = "1836/server-run/ws/rest/Login/getShortMsg"
    
    func getPath() -> String {
        let url = "https://" + NetConfig.devIP + ":\(self.rawValue)"
        return url
    }
}

// MARK: - 服务器加密类型
enum ServerEncryptionType {
    case `default`
    case jiami1
    case jiami2
    
    //对参数进行加密
    fileprivate func getEncryptionData(_ parameters: Dictionary<String, Any>?) throws -> Dictionary<String, Any> {
        
        switch self {
        case .default:
            return parameters ?? [String : String]()
            
        case .jiami1: //备用加密方式
            return parameters ?? [String : String]()
            
        case .jiami2: //备用加密方式
            return parameters ?? [String : String]()
        }
    }
    
    //解析解密服务端数据
    fileprivate func analysisData(withResponse response: DataResult<Data>) ->  DataResult<Dictionary<String, Any>> {
        
        switch self {
        case .default:
            switch response {
            case .failure(let error):
                return DataResult.failure(error)
                
            case .success(let value):
                do {
                    let json = try JSONSerialization.jsonObject(with: value, options: .mutableContainers)
                    let dic = json as! Dictionary<String, Any>
                    return DataResult.success(dic)
                } catch let error {
                    print("数据解析失败")
                    return DataResult.failure(error as NSError)
                }
            }
            
        case .jiami1:
            switch response {
            case .failure(let error):
                return DataResult.failure(error)
                
            case .success(let value):
                //先解密...
                do {
                    let json = try JSONSerialization.jsonObject(with: value, options: .mutableContainers)
                    let dic = json as! Dictionary<String, Any>
                    return DataResult.success(dic)
                } catch let error {
                    print("数据解析失败")
                    return DataResult.failure(error as NSError)
                }
            }
            
        case .jiami2:
            switch response {
            case .failure(let error):
                return DataResult.failure(error)
                
            case .success(let value):
                //先解密...
                do {
                    let json = try JSONSerialization.jsonObject(with: value, options: .mutableContainers)
                    let dic = json as! Dictionary<String, Any>
                    return DataResult.success(dic)
                } catch let error {
                    print("数据解析失败")
                    return DataResult.failure(error as NSError)
                }
            }
        }
    }
}

// MARK: - 网络层

class NetworkTool {
    
    private static let `default`: RequestManagerProtocol = RequestManager()
    
    // MARK: - 中间层 数据整合解析层
    @discardableResult class func request(withInterface interface: URLConfig, parameters: Dictionary<String, Any>?, requestMethod: NetRequestMethodType = .POST, serverEncryptionType: ServerEncryptionType = .default, completionHandler: @escaping(_ dataResult: DataResult<Dictionary<String, Any>>) -> Void) -> URLSessionTask? {
        
        do {
            print("---------------------- Request Begin! ----------------------")
            print("urlString:\(interface.getPath())")
            print("requestMethod:\(requestMethod.rawValue)")
            
            let encryptedParameters = try serverEncryptionType.getEncryptionData(parameters)
            let task = self.default.managerRequest(withInterface: interface.getPath(), parameters: encryptedParameters, method: requestMethod) { (dataResult) in
                
                let rawDataResult = serverEncryptionType.analysisData(withResponse: dataResult)
                switch rawDataResult {
                case .failure(let error):
                    print("errorCode:\(error.code) \nerrorMessage:\(error.localizedDescription)")
                    
                case .success(let value):
                    print("ResponseData:\(value)")
                }
                print("---------------------- Request End! ----------------------")
                completionHandler(rawDataResult)
            }
            return task
            
        } catch {
            completionHandler(DataResult.failure(error as NSError))
            return nil
        }
        
    }
    
    /*
     *  
     *
     *
     */
    
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
    
    
}

protocol RequestManagerProtocol {
    func managerRequest(withInterface interface: String, parameters: Dictionary<String, Any>, method: NetRequestMethodType, callBack: @escaping(_ dataResult: DataResult<Data>) -> Void) -> URLSessionTask?
}

final class RequestManager: RequestManagerProtocol {
    
    static let sessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
        // 证书信任设置
        let serverTrustPolicies: [String : ServerTrustPolicy] = [
            "192.168.22.16" : .pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: true, validateHost: true)]
        
        return Alamofire.SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        //        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    // 调用Alamofire发起请求
    @discardableResult func managerRequest(withInterface interface: String, parameters: Dictionary<String, Any>, method: NetRequestMethodType, callBack: @escaping (DataResult<Data>) -> Void) -> URLSessionTask? {
        
        
        let headers:HTTPHeaders = ["Content-type" : "application/json",
                                   "Accept"       : "application/json"]
        
        var dataRequest: Alamofire.DataRequest?
        dataRequest = RequestManager.sessionManager.request(interface, method: HTTPMethod(rawValue: method.rawValue) ?? HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            
            switch response.result {
                
            case .failure(let error):
                
                print("---------------------- Request Fail! ----------------------",
                      "\nTotalDurationTime:", response.timeline.totalDuration, "sec",
                         "\nerror:", error
                )
                
                callBack(DataResult.failure(error as NSError))
                
            case .success(let value):
                
                print("---------------------- Request Succeed! ----------------------",
                      "\nTotalDurationTime:", response.timeline.totalDuration, "sec",
                      "\nDataSize:", response.data ?? "0 bytes")
                
                callBack(DataResult.success(value))
            }
            
        }
        return dataRequest?.task
    }
}
