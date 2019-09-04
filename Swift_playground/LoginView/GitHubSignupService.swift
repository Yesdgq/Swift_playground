//
//  GitHubSignupService.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/9/2.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation
import RxSwift

// MARK: ValidationResult枚举

//验证结果和信息的枚举
enum ValidationResult {
    case validating
    case empty
    case ok(message: String)
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

//扩展ValidationResult，对应不同的验证结果返回不同的文字描述
extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .validating:
            return "正在验证..."
        case .empty:
            return ""
        case .ok(let msg):
            return msg
        case .failed(let msg):
            return msg
        }
    }
}

//扩展ValidationResult，对应不同的验证结果返回不同的文字颜色
extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .validating:
            return UIColor.gray
        case .empty:
            return UIColor.black
        case .ok:
            return UIColor(red: 0/255, green: 130/255, blue: 0/255, alpha: 1)
        case .failed:
            return UIColor.red
        }
    }
}

// MARK: GitHubSignupService

class GitHubSignupService {
    
    let minPasswordCount = 5
    
    lazy var networkService = {
        return GitHubNetworkService()
    }()
    
    func validateUserName(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return Observable.just(.empty)
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字和字母"))
        }
        
        //发起网络请求检查用户名是否已存在
        return networkService.userNameAvailable(username)
            .map{ available in
                //根据查询情况返回不同的验证结果
                if available {
                    return .ok(message: "用户名可用")
                } else {
                    return .failed(message: "用户名已经存在")
                }
            }
            .startWith(.validating) //在发起网络请求前，先返回一个“正在检查”的验证结果
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码至少需要\(minPasswordCount)个字符")
        }
        
        return .ok(message: "密码有效")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "密码有效")
        } else {
            return .failed(message: "两次输入的密码不一致")
        }
    }
}





