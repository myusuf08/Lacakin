//
//  FriendCommentTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class FriendCommentTableViewCell: BaseTableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imagesView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FriendCommentTableViewCell {
    func configure(model: ListCommentActivityResponse?) {
        selectionStyle = .none
        guard let model = model else { return } 
        nameLabel.text = model.actcomUser ?? ""
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.layoutIfNeeded()
        messageLabel.text = model.actcomText ?? ""
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        messageLabel.layoutIfNeeded()
        let url = URL(string: model.actcomPhoto ?? "")
        self.imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        let actDate = Date(timeIntervalSince1970: TimeInterval(model.actcomTime ?? 0))
        dateLabel.text = actDate.dateToStringComment()
    }
    
    func configureChat(model: ListGroupChatResponse?) {
        selectionStyle = .none
        guard let model = model else { return }
        nameLabel.text = model.chatUserName ?? ""
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.layoutIfNeeded()
        messageLabel.text = model.chatMsg ?? ""
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        messageLabel.layoutIfNeeded()
        let url = URL(string: model.chatUserPhoto ?? "")
        self.imagesView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        let actDate = Date(timeIntervalSince1970: TimeInterval(Int(model.chatTime ?? "") ?? 0))
        dateLabel.text = actDate.dateToStringComment()
    }
}
