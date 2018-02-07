//
//  ViewController.swift
//  Swift_playground
//
//  Created by yesdgq on 2017/5/11.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

import UIKit
import SwiftyXMLParser

class ViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel.text = "你好"
        myLabel.backgroundColor = UIColor.red
        myButton.setImage(UIImage(named: "Delete"), for: .normal)
        myButton.setTitle("CollectionView", for: .normal)
        
        // 构造方法
        DogVC().eat(nil)
        
        //         在swift4.0中，提供了专门的语法来显示多行字符串，从而告别转义
        //                let longString = """
        //        When you write a string that spans multiple
        //        lines make sure you start its content on a
        //        line all of its own, and end it with three
        //        quotes also on a line of their own.
        //        Multi-line strings also let you write "quote marks"
        //        freely inside your strings, which is great!
        //        """
        //                print(longString)
        
        
        
        
        
        
        let button2: UIButton = UIButton(type: .custom)
        button2.frame = CGRect(x:80, y:150, width:100, height:30)
        button2.backgroundColor = UIColor.red
        button2.setTitle("普通状态", for: .normal)
        button2.setTitle("高亮状态", for: .highlighted)
        button2.setTitleShadowColor(UIColor.cyan, for: .normal)
        button2.setTitleShadowColor(UIColor.green, for: .highlighted)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        // 省略尾部文字
        button2.titleLabel?.lineBreakMode = .byTruncatingTail
        button2.addTarget(self, action: #selector(someMethod(button:)), for: .touchUpInside)
        self.view.addSubview(button2)
        
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
        button3.addTarget(self, action: #selector(someMethod(button:)), for: .touchUpInside)
        self.view.addSubview(button3)
        
        
        
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
            
            NetworkTool.requestData(.GET, URLString: "http://skmobiletv.96396.cn:10019/html/hlj_appjh/index.xml", parameters: nil) { (response) in
                DONG_Log(response)
                
                
                
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
}




