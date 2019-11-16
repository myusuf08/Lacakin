//  
//  DetailProfileViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class DetailProfileViewController: BaseViewController {

    @IBOutlet weak var secondWidthScrollView: NSLayoutConstraint!
    @IBOutlet weak var secondBgView: UIView!
    @IBOutlet weak var secondScrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var activitiesButton: UIButton!
    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var activitiesView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var heightBgViewConst: NSLayoutConstraint!
    
    var viewModel: DetailProfileViewModel!
    var coordinator: DetailProfileCoordinator!
    var isActivity = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initEventScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isActivity {
            activities(animated: false)
        } else {
            events(animated: false)
        }
    }
}

// MARK: Private

extension DetailProfileViewController {
    
    func setupViews() {
        eventsView.isHidden = true
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        activitiesButton.addTarget(self, action: #selector(activities), for: .touchUpInside)
        eventsButton.addTarget(self, action: #selector(events), for: .touchUpInside)
    }
    
    func initEventScrollView() {
        scrollView.bounces = false
        let width = UIScreen.main.bounds.width
        let height = secondScrollView.frame.size.height
        secondWidthScrollView.constant = 2 * width
        secondScrollView.delegate = self
        secondScrollView.isPagingEnabled = true
        
        // Activities
        let activitiesFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let activities = FriendActivityCoordinator.createFriendActivityViewController(friendId: viewModel.outputs.friendId, isUser: viewModel.outputs.isUser)
        activities.delegate = self
        addChild(activities)
        secondBgView.addSubview(activities.view)
        activities.didMove(toParent: self)
        activities.view.frame = activitiesFrame
        
        // Events
        let eventsFrame = CGRect(x: width, y: 0, width: width, height: height)
        let events = FriendEventsCoordinator.createFriendEventsViewController()
        addChild(events)
        secondBgView.addSubview(events.view)
        events.didMove(toParent: self)
        events.view.frame = eventsFrame
        
        secondScrollView.isScrollEnabled = false
        secondScrollView.canCancelContentTouches = false
        secondScrollView.delaysContentTouches = true
        secondScrollView.contentSize = CGSize(width: 2 * width,
                                             height: height)
        
        secondScrollView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
        observerUserProfileModel()
        observerFriendProfileModel()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                //
            })
            .disposed(by: disposeBag)
    }
    
    func observerUserProfileModel() {
        viewModel.outputs.userProfileModel
            .subscribe(onNext: { [unowned self] model in
                self.nameLabel.text = model?.profile?.fullname ?? ""
                let url = URL(string: model?.profile?.photoUrl ?? "")
                self.imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
                let actDate = Date(timeIntervalSince1970: TimeInterval(model?.profile?.memberSince ?? 0))
                self.memberSinceLabel.text = "Member since \(actDate.dateToStringStandart())"
                
            })
            .disposed(by: disposeBag)
    }
    
    func observerFriendProfileModel() {
        viewModel.outputs.friendProfileModel
            .subscribe(onNext: { [unowned self] model in
                self.nameLabel.text = model?.profile?.fullname ?? ""
                let url = URL(string: model?.profile?.photoUrl ?? "")
                self.imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
                let actDate = Date(timeIntervalSince1970: TimeInterval(model?.profile?.memberSince ?? 0))
                self.memberSinceLabel.text = "Member since \(actDate.dateToStringStandart())"
                
            })
            .disposed(by: disposeBag)
    }
    
    func observeError() {
        viewModel.outputs.errorString
            .subscribe(onNext: { [unowned self] error in
                ToastView.show(message: error, in: self, length: .short)
            })
            .disposed(by: disposeBag)
    }
    
    
    @objc func activities(animated: Bool = true) {
        isActivity = true
        let firstPage = CGPoint(x: 0, y: scrollView.contentOffset.y)
        secondScrollView.setContentOffset(firstPage, animated: animated)
        activitiesView.isHidden = false
        eventsView.isHidden = true
    }
    
    @objc func events(animated: Bool = true) {
        isActivity = false
        activitiesView.isHidden = true
        eventsView.isHidden = false
        let screen = UIScreen.main.bounds
        let secondPage = CGPoint(x: screen.width,
                                 y: scrollView.contentOffset.y)
        secondScrollView.setContentOffset(secondPage, animated: animated)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
    }
}

extension DetailProfileViewController: FriendActivityDelegate {
    func updateHeightScrollView(height: CGFloat) {
        heightBgViewConst.constant = CGFloat(335) + height
    }
}
