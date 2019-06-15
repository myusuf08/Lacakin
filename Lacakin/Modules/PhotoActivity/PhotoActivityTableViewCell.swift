//
//  PhotoActivityTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoActivityTableViewCell: BaseTableViewCell {

    var didTrashTap: (() -> Void)?
    
    @IBOutlet weak var trashView: UIView!
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var uploadedLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PhotoActivityTableViewCell {
    func configure(model: ListPhotoActivityResponse?) {
        guard let model = model else { return }
        let url = URL(string: model.actphoPhotourl ?? "")
        bgImageView.kf.setImage(with: url, placeholder: UIImage(named: ""))
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        let url2 = URL(string: model.photoUploader ?? "")
        imagesView.kf.setImage(with: url2, placeholder: UIImage(named: ""))
        self.imagesView.layer.cornerRadius = 20
        self.imagesView.clipsToBounds = true
        uploadedLabel.text = "Uploaded by \(model.uploader ?? "")"
        descLabel.text = model.actphoTitle ?? ""
        if model.uploaderId == User.shared.profile?.userId {
            trashView.isHidden = false
        } else {
            trashView.isHidden = true
        }
        trashButton.addTarget(self, action: #selector(trash), for: .touchUpInside)
    }
    
    @objc func trash() {
        didTrashTap?()
    }
}
