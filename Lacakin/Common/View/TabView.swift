//
//  TabPagerController.swift
//  CIRCL_IOS_v2
//
//  Created by User on 16/11/18.
//  Copyright © 2018 Circl.It. All rights reserved.
//

import UIKit

class TabView: UIView {
    
    weak var delegate: TabViewDelegate?
    private var tabButtons = [UIButton]()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -3),
            stackView.topAnchor.constraint(equalTo: topAnchor)
            ])
        return stackView
    }()
    
    private var widthTabConstraint: CGFloat = 0.0
    private var xTabConstraint: NSLayoutConstraint!
    private lazy var tabIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension TabView {
    func addTabs(_ title: [String]) {
        let screenSize = UIScreen.main.bounds
        tabButtons = []
        let width = CGFloat(screenSize.width / CGFloat(title.count))
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        title.enumerated().forEach { [weak self] (titles) in
            self?.addTabButton(title: titles.element, width: width)
        }
        if tabButtons.count > 0 {
            addIndicatorView(width: width)
            onSelect(button: tabButtons[0], animated: false)
        }
        
    }
    
    func addTabButton(title: String, width: CGFloat,
                      titleColor: UIColor = .white) {
        let button = UIButton()
        button.tag = tabButtons.count
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.defaultBoldFont(size: 15)
        button.addTarget(self,  action: #selector(tapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        contentStackView.addArrangedSubview(button)
        button.frame = contentStackView.arrangedSubviews[tabButtons.count].frame
        tabButtons.append(button)
    }
    
    func addIndicatorView(width: CGFloat) {
        widthTabConstraint = width
        xTabConstraint = tabIndicator.leftAnchor.constraint(equalTo: leftAnchor)
        NSLayoutConstraint.activate([
            xTabConstraint,
            tabIndicator.topAnchor.constraint(equalTo: topAnchor, constant: frame.size.height - 3),
            tabIndicator.widthAnchor.constraint(equalToConstant: width),
            tabIndicator.heightAnchor.constraint(equalToConstant: 3)
            ])
        bringSubviewToFront(tabIndicator)
        layoutIfNeeded()
    }
}

extension TabView {
    @objc func tapped(sender: UIButton) {
        self.onSelect(button: sender, animated: true)
        self.delegate?.tabView(self, didSelectAt: sender.tag)
    }
    
    func onSelect(button: UIButton, animated: Bool) {
        guard let index = tabButtons.index(of: button) else {
            return
        }
        self.xTabConstraint.constant = CGFloat(self.widthTabConstraint * CGFloat(index))
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.33) {
            self.layoutIfNeeded()
        }
    }
}

protocol TabViewDelegate: class {
    func tabView(_ tabView: TabView, didSelectAt index: Int)
}

extension TabViewDelegate {
    func tabView(_ tabView: TabView, didSelectAt index: Int) {
        
    }
}
