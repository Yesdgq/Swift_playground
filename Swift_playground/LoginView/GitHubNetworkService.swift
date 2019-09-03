//
//  GitHubNetworkService.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/9/2.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation
import RxSwift


class GitHubNetworkService {
   
    //验证用户是否存在
    func userNameAvailable(_ userName: String) ->  Observable<Bool> {
        //通过检查这个用户的GitHub主页是否存在来判断用户是否存在
        let url = URL(string: "http://github.com/\(userName.URLEscaped)")!
        let requsest = URLRequest(url: url)
        return URLSession.shared.rx.response(request: requsest)
            .map{ pair in
                //如果不存在该用户主页，则说明这个用户名可用
                return pair.response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    //注册用户
    func signup(_ userName: String, password: String) -> Observable<Bool> {
        //这里我们没有真正去发起请求，而是模拟这个操作（平均每3次有1次失败）
        let signupResult = arc4random() % 2 == 0 ? false : true
        return Observable.just(signupResult)
            .delay(1.5, scheduler: MainScheduler.instance)
    }
}


//扩展String
extension String {
    var URLEscaped: String {
        //字符串的url地址转义
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}



