//
//  MineTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class MineTableViewCell: BaseTableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var comentLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint! // 70
    var photoModel: [ActivityListPhoto]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension MineTableViewCell {
    func configure(model: ActivityListResponse) {
        selectionStyle = .none
        bgView.dropShadow(color: UIColor.transparantShadow, offset: CGSize(width: 0, height: 1), opacity: 1, radius: 4)
        titleLabel.text = model.actName
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        titleLabel.layoutIfNeeded()
        descriptionLabel.text = model.actDesc
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.layoutIfNeeded()
        comentLabel.text = "\(model.actComments ?? 0) Comment"
        likeLabel.text = "\(model.actLikes ?? 0) Like"
        let actDateString = String(model.actDateTimeStart ?? 0).stringToDate()
        dateTimeLabel.text = actDateString.dateToStringFull()
        let url = URL(string: User.shared.profile?.photoUrl ?? "")
        userImageView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        usernameLabel.text = User.shared.profile?.fullname ?? ""
        statusLabel.isHidden = true
        statusDateLabel.isHidden = true
        if model.photos?.count ?? 0 > 0 {
            collectionView.registerNib(MinePhotoCollectionViewCell.self)
            photoModel = model.photos
            let width = collectionView.frame.width / 3
            heightCollectionViewConstraint.constant = width
            collectionView.reloadData()
        } else {
            heightCollectionViewConstraint.constant = 0
        }
    }
}

extension MineTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let count = photoModel?.count ?? 0
        if count > 3 {
            return 3
        } else {
            return count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = photoModel?[indexPath.row]
        let cell = collectionView.dequeueClass(indexPath,
                                               MinePhotoCollectionViewCell.self)
        cell.configure(model: model, count: photoModel?.count ?? 0, index: indexPath.row)
        return cell
    }
}

extension MineTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
       
    }
    
}

extension MineTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var count = 1
        if photoModel?.count ?? 0 > 3 {
            count = 3
        } else {
            count = photoModel?.count ?? 0
        }
        let width = collectionView.frame.width / CGFloat(count)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 3, bottom: 0, right: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
