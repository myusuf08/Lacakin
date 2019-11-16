//  
//  FriendActivityViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class FriendActivityViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: FriendActivityDelegate?
    var viewModel: FriendActivityViewModel!
    var coordinator: FriendActivityCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension FriendActivityViewController {
    
    func setupViews() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(DetailProfileCollectionViewCell.self)
        collectionView.isScrollEnabled = false
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
                self?.delegate?.updateHeightScrollView(height: self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 400)
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
    
}


extension FriendActivityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if viewModel.isUser {
            let count = viewModel.userActivityModel?.data?.count ?? 0
            return count
        } else {
            let count = viewModel.friendActivityModel?.data?.count ?? 0
            return count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueClass(indexPath,
                                               DetailProfileCollectionViewCell.self)
        if viewModel.isUser {
            let model = viewModel.userActivityModel?.data?[indexPath.row]
            cell.configureUser(model: model)
        } else {
            let model = viewModel.friendActivityModel?.data?[indexPath.row]
            cell.configureFriend(model: model)
        }
        return cell
    }
}

extension FriendActivityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if viewModel.isUser {
            let models = viewModel.userActivityModel?.data?[indexPath.row]
            guard let model = models else { return }
            let emptyModel = ActivityListOthersResponse.init(actId: nil, actCode: nil, actName: nil, actDesc: nil, actDateTimeStart: nil, actTimezone: nil, actCreated: nil, actComments: nil, actUserid: nil, actLikes: nil, actIslike: nil, actmemActive: nil, actmemDate: nil, ownerId: nil, ownerName: nil, ownerPhoto: nil, photos: [])
            let vc = DetailActivityCoordinator.createDetailActivityViewController(activityModel: model, activityModelOthers: emptyModel, isFromList: true, joinActivityCode: "", isFromFriend: false)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let models = viewModel.friendActivityModel?.data?[indexPath.row]
            guard let model = models else { return }
            var status = false
            if model.flag == "owned" {
                status = true
            } else if model.flag == "joined" {
                status = true
            } else {
                status = false
            }
            let emptyModel = ActivityListResponse.init(actId: nil, actCode: nil, actName: nil, actDesc: nil, actDateTimeStart: nil, actTimezone: nil, actPublic: nil, actCreated: nil, actComments: nil, actUserid: nil, actLikes: nil, actIslike: nil,actLocation: nil , photos: [])
            let emptyModel2 = ActivityListOthersResponse.init(actId: nil, actCode: nil, actName: nil, actDesc: nil, actDateTimeStart: nil, actTimezone: nil, actCreated: nil, actComments: nil, actUserid: nil, actLikes: nil, actIslike: nil, actmemActive: nil, actmemDate: nil, ownerId: nil, ownerName: nil, ownerPhoto: nil, photos: [])
            let vc = DetailActivityCoordinator.createDetailActivityViewController(activityModel: emptyModel, activityModelOthers: emptyModel2, isFromList: true, joinActivityCode: model.actCode ?? "", isFromFriend: status)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension FriendActivityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if viewModel.isUser {
            let model = viewModel.userActivityModel?.data?[indexPath.row]
            let screenSize = UIScreen.main.bounds
            let width = screenSize.width/2 - 8
            let heightName = model?.actName?.height(withConstrainedWidth: width - 16, font: UIFont.boldSystemFont(ofSize: 16))
            let heightDesc = model?.actDesc?.height(withConstrainedWidth: width - 16, font: UIFont.systemFont(ofSize: 13))
            let height = CGFloat(80)
            let totalHeight = CGFloat(heightName ?? 0) + CGFloat(heightDesc ?? 0) + height
            return CGSize(width: width, height: totalHeight)
        } else {
            let model = viewModel.friendActivityModel?.data?[indexPath.row]
            let screenSize = UIScreen.main.bounds
            let width = screenSize.width/2 - 8
            let heightName = model?.actName?.height(withConstrainedWidth: width - 16, font: UIFont.boldSystemFont(ofSize: 16))
            let heightDesc = model?.actDesc?.height(withConstrainedWidth: width - 16, font: UIFont.systemFont(ofSize: 13))
            let height = CGFloat(80)
            let totalHeight = CGFloat(heightName ?? 0) + CGFloat(heightDesc ?? 0) + height
            return CGSize(width: width, height: totalHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

protocol FriendActivityDelegate {
    func updateHeightScrollView(height: CGFloat)
}
