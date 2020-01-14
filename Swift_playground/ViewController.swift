//
//  ViewController.swift
//  Swift_playground
//
//  Created by yesdgq on 2017/5/11.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

import UIKit
import SwiftyXMLParser
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    var mask: CALayer?
    
    let disposeBag = DisposeBag()
    
    
    //         在swift4.0中，提供了专门的语法来显示多行字符串，从而告别转义
    let longString = """
                    When you write a string that spans multiple
                    lines make sure you start its content on a
                    line all of its own, and end it with three
                    quotes also on a line of their own.
                    Multi-line strings also let you write "quote marks"
                    freely inside your strings, which is great!
                    """

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
        // 构造方法
        DogVC().eat(nil)
        
        DDLogDebug("hello")
        
        self.setupSubviews()
        
        //self.setupNavigationItem()
        
        self.addAButton()
        
        
//        self.setupTwitterBirdAnimation()
//
//        animateMask()

        
 
       
        
        
        
        
    }
    
    func setupTwitterBirdAnimation() {
        // set up mask
        mask = CALayer()
        mask?.contents = UIImage(named: "twitterBird")?.cgImage
        mask?.position = self.view.center
        mask?.bounds = CGRect(x: 0, y: 0, width: 100, height: 80)
        self.view.layer.mask = mask
    }
    
    func animateMask() {
        // init key frame animation
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1
        
        // animate zoom in and then zoom out
        let initalBounds = NSValue(cgRect: mask!.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 80, height: 64))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        
        // set up time interals
        keyFrameAnimation.keyTimes = [0, 0.3, 1]
        
        // add animation to current view
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        mask!.add(keyFrameAnimation, forKey: "bounds")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.view.layer.mask = nil
    }
    
    
    
    func loadData() {
        DONG_Log("网络请求")
    }
    
    @objc private func someMethod(button:UIButton) {
        if button.tag == 3 {
            DONG_Log("tableView")
            let tableViewVC = MyTableListVC()
            self.navigationController?.pushViewController(tableViewVC, animated: true)
            
        } else {
            DONG_Log("网络请求开始。。。")
            
            let nowDate = Date.init()
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timeStr = dataFormatter.string(from: nowDate);
            
            
            let parameters: [String:Any] = ["appKey"        :"100001",
                                            "sysUserCode"   :"MIYUNXIANAPPTEST-DGQ",
                                            "password"      :"1234Abcd",
                                            "channelCode"   :"0307",
                                            "tenancyCode"   :"003",
                                            "timestamp"     :timeStr]
            
            //            NetworkTool.requestData(.POST, URLString: "https://app.sms.huhutv.com.cn:1836/server-run/ws/rest/Login/checkPwd", parameters: parameters) { (response) in
            //
            //                DONG_Log(response)
            //            }
            DDLogDebug("DDLogDebug")
            print("print log")
            NSLog("NSlog log")
            
            NetworkTool.request(withInterface: InterFaceEnum.checkPassword, parameters: parameters) { data in
                
                switch data {
                case .failure(let error):
                    DONG_Log(error)
                case .success:
                    DONG_Log(data)
                }
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func doClickAction(_ sender: Any) {
        DONG_Log("下一页")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let loginVC = storyboard.instantiateInitialViewController() // 创建箭头指向的实例化控制器
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @IBAction func gotoMVVMDemoPage(_ sender: Any) {
        let gitHubVC: GitHubInfoVC = GitHubInfoVC()
        self.navigationController?.pushViewController(gitHubVC, animated: true)
        
    }
    
    func setupNavigationItem() -> Void {
        let naviBarIV = UIImageView(frame: CGRect(x: 0, y: 420, width: 50, height: 50))
        naviBarIV.image = UIImage(named: "NavigationBar")
        naviBarIV.backgroundColor = UIColor.yellow
        let backBtn: UIButton = UIButton(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        backBtn.setImage(UIImage(named: "GoBack"), for: .normal)
        backBtn.setImage(UIImage(named: "GoBak"), for: .highlighted)
        backBtn.setTitle("返回", for: .normal)
        backBtn.setTitleColor(UIColor.red, for: .normal)
        backBtn.addTarget(self, action: #selector(someMethod(button:)), for: .touchUpInside)
        naviBarIV.isUserInteractionEnabled = true
        naviBarIV.addSubview(backBtn)
        self.view.addSubview(naviBarIV)
    }
}

extension ViewController {
    
    
    
    
    func setupSubviews() -> Void {
        
//        myLabel.text = "你好"
//        myLabel.backgroundColor = UIColor.red
//        myButton.setImage(UIImage(named: "Delete"), for: .normal)
//        myButton.setTitle("CollectionView", for: .normal)
        
        
        let button2: UIButton = UIButton(type: .custom)
        button2.frame = CGRect(x:80, y:150, width:100, height:30)
        button2.backgroundColor = UIColor.red
        button2.setTitle("Alamofire", for: .normal)
        button2.setTitle("高亮状态", for: .highlighted)
        button2.setTitleShadowColor(UIColor.cyan, for: .normal)
        button2.setTitleShadowColor(UIColor.green, for: .highlighted)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        // 省略尾部文字
        button2.titleLabel?.lineBreakMode = .byTruncatingTail
        button2.addTarget(self, action: #selector(someMethod(button:)), for: .touchUpInside)
        self.view.addSubview(button2)
        
        let button3: UIButton = UIButton(type: .custom)
        button3.frame = CGRect(x:80, y:500, width:100, height:30)
        button3.backgroundColor = UIColor.red
        button3.setTitle("tableView", for: .normal)
        button3.setTitle("tableView", for: .highlighted)
        button3.setTitleShadowColor(UIColor.cyan, for: .normal)
        button3.setTitleShadowColor(UIColor.green, for: .highlighted)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        button3.tag = 3
        // 省略尾部文字
        button3.titleLabel?.lineBreakMode = .byTruncatingTail
        button3.addTarget(self, action: #selector(someMethod(button:)), for: .touchUpInside)
        self.view.addSubview(button3)
        
    }
}


extension ViewController {
    
    func addInfoCollecBtn() -> Void {
        
        let button3: UIButton = UIButton(type: .custom)
        button3.frame = CGRect(x:80, y:450, width:100, height:30)
        button3.backgroundColor = UIColor.red
        button3.setTitle("tableView", for: .normal)
        button3.setTitle("tableView", for: .highlighted)
        button3.setTitleShadowColor(UIColor.cyan, for: .normal)
        button3.setTitleShadowColor(UIColor.green, for: .highlighted)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        button3.tag = 3
        // 省略尾部文字
        button3.titleLabel?.lineBreakMode = .byTruncatingTail
        self.view.addSubview(button3)
        
    }
    
}


extension ViewController {
    
    func addAButton() -> Void {
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.green
        button.setTitle("RXSwift按钮", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(200)
            make.right.equalTo(self.view.snp.right).offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        // 按钮点击响应
        button.rx.tap
            .subscribe(onNext: {
                DDLogDebug("rx点击事件")
                
                let cusInfoCollVC = CusInfoColleVC()
                self.navigationController?.pushViewController(cusInfoCollVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
    }
}


class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dict = [Int: Int]()
        
        for (i, num) in nums.enumerated() {
            if let lastIndex = dict[target - num] {
                return [lastIndex, i]
            } else {
                dict[num] = i
            }
        }
        fatalError("No valid output")
    }
}


