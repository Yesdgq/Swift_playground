//
//  GitHubAPI.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/8/19.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation
import Moya


let GitHubProvider = MoyaProvider<GitHubAPI>()

// 请求分类
public enum GitHubAPI {
    case repositories(String)
}

// 请求配置
extension GitHubAPI: TargetType {
    
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    // 各个请求的具体路径
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        return .get
    }
    
//    public var sampleData: Data {
//        <#code#>
//    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        DDLogDebug("发起请求")
        switch self {
        case .repositories(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        default:
            return .requestPlain
        }
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 这个就是做单元测试的模拟数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 请求头
    public var headers: [String : String]? {
        return nil
    }
}
