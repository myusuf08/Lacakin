//
//  OthersViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

protocol OthersViewModelType {
    var inputs: OthersViewModelInputs { get }
    var outputs: OthersViewModelOutputs { get }
}

protocol OthersViewModelInputs {
    func onViewDidLoad()
    func getActivityListOthersData() -> ActivityListOthersData?
}

protocol OthersViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
}

class OthersViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var OthersModel: OthersModel?
    var model: ActivityListOthersData? = nil
    let network = MoyaProvider<LacakinApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension OthersViewModel {
    
}

extension OthersViewModel: OthersViewModelType {
    var inputs: OthersViewModelInputs { return self }
    var outputs: OthersViewModelOutputs { return self }
}

extension OthersViewModel: OthersViewModelInputs {
    func getActivityListOthersData() -> ActivityListOthersData? {
        return model
    }
    
    func onViewDidLoad() {
        getOthersList()
    }
    
    func getOthersList() {
        let headers = ["x-access-token":User.shared.token ?? ""]
        let url = "\(String.BaseApiUrl)/activity/list_join"
        print("header getOthersList = \(headers)")
        print("url getOthersList = \(url)")
        Alamofire.request(url, method: .get, headers: headers).responseJSON {
            (response) -> Void in
            print("response =\(response.result.value ?? "")")
            switch response.result {
            case .success(let json):
                do {
                    
                    let dataResponse = try JSONDecoder().decode(ActivityListOthersBase.self,from:response.data ?? Data())
                    if dataResponse.gtfwResult.status ?? 0 > 200 {
                        self.errorStringVariable.value = dataResponse.gtfwResult.message ?? ""
                        self.updateVariable.value = false
                        return
                    }
                    if dataResponse.gtfwResult.status == 200 {
                        if dataResponse.gtfwResult.data?.count == 0 {
                            self.updateVariable.value = false
                            return
                        }
                        self.model = dataResponse.gtfwResult
                        self.updateVariable.value = true
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                self.errorStringVariable.value = error.localizedDescription
                self.updateVariable.value = false
            }
        }
    
    }
}

extension OthersViewModel: OthersViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable()
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
