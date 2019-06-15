//
//  BaseTableViewCell.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 02/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import Foundation
import RxSwift

class BaseTableViewCell: UITableViewCell, ReusableView {
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
}
