//
//  EmptyTableViewCell.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 06/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell, ReusableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    fileprivate func initialize() {
        let bgView = UIView()
        bgView.backgroundColor = .white
        self.backgroundView = bgView
        
        self.contentView.backgroundColor = .white
        self.backgroundColor = .white
        self.selectionStyle = .none
    }
}
