//
//  GitHubSignupViewModel.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/9/2.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GitHubSignupViewModel {
    
    let validateUserName: Driver<ValidationResult>
    let validatePassword: Driver<ValidationResult>
    let validateRepeatedPassword: Driver<ValidationResult>
    
    let signupEnabled: Driver<Bool>
    let signupResult: Driver<Bool>
    
    init(
        input:(
            userName: Driver<String>,
            password: Driver<String>,
            repeatedPassword: Driver<String>,
            loginTaps: Driver<Void>),
        dependency:(
            networkService: GitHubNetworkService,
            signupService: GitHubSignupService)) {
        
        validateUserName = input.userName
            .flatMap { username in
                return dependency.signupService.validateUserName(username).asDriver(onErrorJustReturn: .failed(message: "服务器发生错误！"))
        }
        
        validatePassword = input.password
            .map { password in
                return dependency.signupService.validatePassword(password)
        }
        
        validateRepeatedPassword = Driver.combineLatest(
            input.password,
            input.repeatedPassword,
            resultSelector: dependency.signupService.validateRepeatedPassword)
        
        signupEnabled = Driver.combineLatest(
            validateUserName,
            validatePassword,
            validateRepeatedPassword) { userName, password, repeatedPassword in
               userName.isValid && password.isValid && repeatedPassword.isValid
            }
            .distinctUntilChanged()
        
        let usernameAndPassword = Driver.combineLatest( input.userName, input.password) {
            (username: $0, password: $1)
        }
        
        //注册按钮点击结果
        signupResult = input.loginTaps
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return dependency.networkService.signup(pair.username, password: pair.password)
                    .asDriver(onErrorJustReturn: false)
        }
        
    }
}


// 扩展UILabel
extension Reactive where Base: UILabel {
    //让验证结果（ValidationResult类型）可以绑定到label上
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
    
/**
   var validationResult: Binder<ValidationResult> {
     let observer: Binder<ValidationResult> = Binder(base) { label, result in
        label.textColor = result.textColor
        label.text = result.description
     }
     return observer
   }
 */

}

