//
//  HomeViewController.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/8/27.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    var tableView: UITableView!
    var dataSource: Observable<Array<String>>!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "首页"
        
        self.dataSource = Observable.of(["RxSwift小demo", "信息核查工具 tableView", "TableView", "CollectionView", "Alamofire", "MVVM + Rxswift + Moya + ObjectMapper", "用户注册 Rx MVVM"])
        
        
        self.setupTableView()
        
        
    }
 
}


extension HomeViewController {
    
    func setupTableView() {
        
        
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        
        //将数据绑定到表格
        self.dataSource.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element
            
            return cell
            }.disposed(by: disposeBag)
        
        //设置代理
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { item in
                
                DDLogDebug("标题:\(item)")
                
            }).disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView .deselectRow(at: indexPath, animated: true)
                switch indexPath.row {
                case 0:
                    let cusInfoCollVC = CusInfoColleVC()
                    self?.navigationController?.pushViewController(cusInfoCollVC, animated: true)
                    
                case 1:
                    let cusInfoCollVC = CusInfoColleVC()
                    self?.navigationController?.pushViewController(cusInfoCollVC, animated: true)
                    
                case 2:
                    let tableViewVC = MyTableListVC()
                    self?.navigationController?.pushViewController(tableViewVC, animated: true)
                    
                case 3:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self?.navigationController?.pushViewController(loginVC, animated: true)
                    
                case 4:
                    let cusInfoCollVC = CusInfoColleVC()
                    self?.navigationController?.pushViewController(cusInfoCollVC, animated: true)
                    
                case 5:
                    let gitHubInfoVC = GitHubInfoVC()
                    self?.navigationController?.pushViewController(gitHubInfoVC, animated: true)
                    
                case 6:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let logInVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                    self?.navigationController?.pushViewController(logInVC, animated: true)
                    
                default:
                    break
                }
                
            }).disposed(by: disposeBag)
        
        
        
    }
}


//tableView代理实现
extension HomeViewController : UITableViewDelegate {
    //设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 60
    }
}
