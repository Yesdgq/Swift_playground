//
//  GitHubViewModel.swift
//  Swift_playground
//
//  Created by yesdgq on 2019/8/19.
//  Copyright © 2019 yesdgq. All rights reserved.
//

import Foundation
import RxSwift
import Result
import Moya_ObjectMapper

class GitHubViewModel {
    let disposeBag = DisposeBag()
    //输入部分
    //查询行为
    fileprivate let searchAction: Observable<String>
    
    //输出部分
    //所有的查询结果
    let searchResult: Observable<GitHubRepositories>
    
    //查询结果里的资源列表
    let repositories: Observable<[GitHubRepository]>
    
    //清空查询结果
    let cleanResult: Observable<Void>
    
    let subject: Observable<String>
    
    //导航栏标题
    let navigationTitle: Observable<String>
    
    
    //ViewModel初始化（根据输入实现对应的输出）
    init(searchAction: Observable<String>) {
        self.searchAction = searchAction
        //生成查询结果序列
        self.searchResult = searchAction
            .filter{
                return !$0.isEmpty
            }  //如果输入为空则不发送请求了 过滤操作
            .flatMapLatest{ (event) -> Observable<GitHubRepositories> in

//                print(event)
                //return Observable<GitHubRepositories>.empty()

                GitHubProvider.rx.request(.repositories(event))
                    .filterSuccessfulStatusCodes() //(statusCodes: 200...299)
                    .mapObject(GitHubRepositories.self)
                    .asObservable()
                    .catchError({ error in
                        DDLogDebug("发生错误：\(error.localizedDescription)")
                        return Observable<GitHubRepositories>.empty()
                    })
            }.share(replay: 1) //让HTTP请求是被共享的 这样就不会出现『多次订阅导致重复地网络请求』的情况了
        
        
        
        
        //瞎试
        subject  =  searchAction
            .filter{
                DDLogDebug("输入框00000：\($0)")
                return !$0.isEmpty }
            .flatMapLatest{ (event) -> Observable<String> in
                DDLogDebug("输出11111：\(event)")
                return Observable.of("默认值")
            }
            .catchError({ error in
                DDLogDebug("发生错误：\(error.localizedDescription)")
                return Observable<String>.empty()
            })
        
        
        //生成清空结果动作序列
        self.cleanResult = searchAction
            .filter{ $0.isEmpty }
            .map{ _ in Void() }
        
        //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
        self.repositories = Observable.of(searchResult.map{ $0.items }, cleanResult.map{[]}).merge()
        
        //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
        self.navigationTitle = Observable.of(
            searchResult.map{ "共有 \($0.totalCount!) 个结果" },
            cleanResult.map{ "yesdgq" })
            .merge()
        
        
        /*
         *  RxSwift学习测试
         *
         *  观察merge()的使用
         */
        
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        //        subject1.onNext(20)
        //        subject1.onNext(40)
        //        subject1.onNext(60)
        //        subject2.onNext(1)
        //        subject1.onNext(80)
        //        subject1.onNext(100)
        //        subject2.onNext(1)
        
        
    }
    
}
