//
//  ParticipantActivityTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class ParticipantActivityTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var approveLabel: UILabel!
    @IBOutlet weak var approveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension ParticipantActivityTableViewCell {
    func configure(model: MemberActivityListList) {
        selectionStyle = .none
        let url = URL(string: model.memPhoto ?? "")
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        nameLabel.text = model.memName ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(model.memDate ?? 0))
        joinDateLabel.text = "Join at \(date.dateToString())"
        if model.memActive == 1 {
            self.approveLabel.isHidden = false
            self.approveButton.isHidden = true
        } else {
            self.approveLabel.isHidden = true
            self.approveButton.isHidden = false
        }
    }
    
    func configureOthers(model: MemberActivityListOthersList) {
        selectionStyle = .none
        let url = URL(string: model.memPhoto ?? "")
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        nameLabel.text = model.memName ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(model.memDate ?? 0))
        joinDateLabel.text = "Join at \(date.dateToString())"
        self.approveLabel.isHidden = true
        self.approveButton.isHidden = true
    }
    
    func configureJoin(model: MemberJoinActivityListList) {
        selectionStyle = .none
        let url = URL(string: model.memPhoto ?? "")
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        nameLabel.text = model.memName ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(model.memDate ?? 0))
        joinDateLabel.text = "Join at \(date.dateToString())"
        self.approveLabel.isHidden = true
        self.approveButton.isHidden = true
    }
    
    func configureLike(model: ListLikeActivityResponse?) {
        selectionStyle = .none
        guard let model = model else { return }
        let url = URL(string: model.actlikPhoto ?? "")
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        nameLabel.text = model.actlikName ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(model.actlikDate ?? 0))
        joinDateLabel.text = "Join at \(date.dateToString())"
        self.approveLabel.isHidden = true
        self.approveButton.isHidden = true
    }
}
