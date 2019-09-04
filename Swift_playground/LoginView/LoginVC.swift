//
//  LoginVC.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/9/2.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LoginVC: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var repeatedPasswordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = GitHubSignupViewModel(
            input: (
                userName: userNameTF.rx.text.orEmpty.asDriver()
                    .throttle(0.5) //只有间隔超过0.5k秒才发送
                    .distinctUntilChanged(),
                password: passwordTF.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordTF.rx.text.orEmpty.asDriver(),
                loginTaps: registerBtn.rx.tap.asDriver()
            ),
            dependency: (
                networkService: GitHubNetworkService(),
                signupService: GitHubSignupService()
            )
        )
        
        viewModel.validateUserName
            .drive(label1.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validatePassword
            .drive(label2.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validateRepeatedPassword
            .drive(label3.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.signupEnabled
            .drive(onNext: { [weak self] valid in
                self?.registerBtn.isEnabled = valid
                self?.registerBtn.alpha = valid ? 1.0 : 0.3
            })
            .disposed(by: disposeBag)
        
        viewModel.signupResult
            .drive(onNext: { [weak self] (result) in
                self?.showMessage("注册" + (result ? "成功" : "失败") + "!")
            })
            .disposed(by: disposeBag)
    }
    
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        DDLogDebug("LoginVC 控制器释放")
    }
}
