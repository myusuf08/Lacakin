//
//  EventsTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class EventsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var participantLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var viewedLabel: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension EventsTableViewCell {
    func configure(model: AllListEventResponse) {
        selectionStyle = .none
        bgView.addBorder(color: UIColor.lightGray.withAlphaComponent(0.4))
        let urlPhoto = model.eventPhoto?.photoUrl ?? ""
        let url = URL(string: urlPhoto)
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: "image_not_available"))
        imagesView.contentMode = .scaleAspectFill
        imagesView.clipsToBounds = true
        nameLabel.text = model.eventName ?? ""
        locationLabel.text = model.eventLocation ?? ""
        participantLabel.text = "\(model.eventTotalParticipant ?? 0) Participant"
        viewedLabel.text = "Viewed: \(model.viewer ?? 0)"
        // OPEN CLOSE
        let close = model.isRegClose ?? "0"
        statusLabel.layer.cornerRadius = 6
        statusLabel.layer.masksToBounds = true
        if close == "0" {
            statusLabel.text = "  Opened  "
            statusLabel.backgroundColor = UIColor.init(red: 61.0/255.0, green: 182.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        } else {
            statusLabel.text = "  Closed  "
            statusLabel.backgroundColor = UIColor.red
        }
        // COMPARE DATE
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0)))
        let date2 = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(model.eventEndDateUnix ?? 0)))
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if components.day ?? 0 == 0 {
            let date = Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0))
            dateLabel.text = date.dateToStringStandart()
        } else {
            let dateOpen = Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0))
            let dateClose = Date(timeIntervalSince1970: TimeInterval(model.eventEndDateUnix ?? 0))
            dateLabel.text = "\(dateOpen.dateToStringStandart()) - \(dateClose.dateToStringStandart())"
        }
        // MAX PRICE
        let maxPrice = model.eventMaxPrice ?? 0
        freeLabel.text = "  FREE EVENT  "
        freeLabel.textAlignment = .center
        freeLabel.layer.cornerRadius = 6
        freeLabel.layer.masksToBounds = true
        if maxPrice > 0 {
            freeLabel.isHidden = true
        } else {
            if urlPhoto == "" {
                freeLabel.isHidden = true
            } else {
                freeLabel.isHidden = false
            }
        }
        nameLabel.sizeToFit()
        nameLabel.layoutIfNeeded()
        dateLabel.sizeToFit()
        dateLabel.layoutIfNeeded()
        locationLabel.sizeToFit()
        locationLabel.layoutIfNeeded()
    }
    
    func configureThisMonth(model: ThisMonthListEventResponse) {
        selectionStyle = .none
        bgView.addBorder(color: UIColor.lightGray.withAlphaComponent(0.4))
        let urlPhoto = model.eventPhoto?.photoUrl ?? ""
        let url = URL(string: urlPhoto)
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: "image_not_available"))
        imagesView.contentMode = .scaleAspectFill
        imagesView.clipsToBounds = true
        nameLabel.text = model.eventName ?? ""
        locationLabel.text = model.eventLocation ?? ""
        participantLabel.text = "\(model.eventTotalParticipant ?? 0) Participant"
        viewedLabel.text = "Viewed: \(model.viewer ?? 0)"
        // OPEN CLOSE
        let close = model.isRegClose ?? "0"
        statusLabel.layer.cornerRadius = 6
        statusLabel.layer.masksToBounds = true
        if close == "0" {
            statusLabel.text = "  Opened  "
            statusLabel.backgroundColor = UIColor.init(red: 61.0/255.0, green: 182.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        } else {
            statusLabel.text = "  Closed  "
            statusLabel.backgroundColor = UIColor.red
        }
        // COMPARE DATE
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0)))
        let date2 = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(model.eventEndDateUnix ?? 0)))
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if components.day ?? 0 == 0 {
            let date = Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0))
            dateLabel.text = date.dateToStringStandart()
        } else {
            let dateOpen = Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0))
            let dateClose = Date(timeIntervalSince1970: TimeInterval(model.eventEndDateUnix ?? 0))
            dateLabel.text = "\(dateOpen.dateToStringStandart()) - \(dateClose.dateToStringStandart())"
        }
        // MAX PRICE
        let maxPrice = model.eventMaxPrice ?? 0
        freeLabel.text = "  FREE EVENT  "
        freeLabel.textAlignment = .center
        freeLabel.layer.cornerRadius = 6
        freeLabel.layer.masksToBounds = true
        if maxPrice > 0 {
            freeLabel.isHidden = true
        } else {
            if urlPhoto == "" {
                freeLabel.isHidden = true
            } else {
                freeLabel.isHidden = false
            }
        }
        nameLabel.sizeToFit()
        nameLabel.layoutIfNeeded()
        dateLabel.sizeToFit()
        dateLabel.layoutIfNeeded()
        locationLabel.sizeToFit()
        locationLabel.layoutIfNeeded()
    }
    
    func configureRegister(model: RegisteredListEventResponse) {
        selectionStyle = .none
        bgView.addBorder(color: UIColor.lightGray.withAlphaComponent(0.4))
        let urlPhoto = model.eventPhoto?.photoUrl ?? ""
        let url = URL(string: urlPhoto)
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: "image_not_available"))
        imagesView.contentMode = .scaleAspectFill
        imagesView.clipsToBounds = true
        nameLabel.text = model.eventName ?? ""
        locationLabel.text = model.eventLocation ?? ""
        participantLabel.text = "\(model.eventTotalParticipant ?? 0) Participant"
        viewedLabel.text = "Viewed: \(model.viewer ?? 0)"
        // OPEN CLOSE
        let close = model.isRegClose ?? "0"
        statusLabel.layer.cornerRadius = 6
        statusLabel.layer.masksToBounds = true
        if close == "0" {
            statusLabel.text = "  Opened  "
            statusLabel.backgroundColor = UIColor.init(red: 61.0/255.0, green: 182.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        } else {
            statusLabel.text = "  Closed  "
            statusLabel.backgroundColor = UIColor.red
        }
        // COMPARE DATE
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0)))
        let date2 = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(model.eventEndDateUnix ?? 0)))
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        if components.day ?? 0 == 0 {
            let date = Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0))
            dateLabel.text = date.dateToStringStandart()
        } else {
            let dateOpen = Date(timeIntervalSince1970: TimeInterval(model.eventStartDateUnix ?? 0))
            let dateClose = Date(timeIntervalSince1970: TimeInterval(model.eventEndDateUnix ?? 0))
            dateLabel.text = "\(dateOpen.dateToStringStandart()) - \(dateClose.dateToStringStandart())"
        }
        // EXPIRED
        let expired = model.paymentIsExpired ?? 0
        if expired == 1 {
            statusLabel.text = "  Expired  "
            statusLabel.backgroundColor = UIColor.red
        }
        // MAX PRICE
        let maxPrice = model.eventMaxPrice ?? 0
        freeLabel.text = "  FREE EVENT  "
        freeLabel.textAlignment = .center
        freeLabel.layer.cornerRadius = 6
        freeLabel.layer.masksToBounds = true
        if maxPrice > 0 {
            freeLabel.isHidden = true
        } else {
            if urlPhoto == "" {
                freeLabel.isHidden = true
            } else {
                freeLabel.isHidden = false
            }
        }
        nameLabel.sizeToFit()
        nameLabel.layoutIfNeeded()
        dateLabel.sizeToFit()
        dateLabel.layoutIfNeeded()
        locationLabel.sizeToFit()
        locationLabel.layoutIfNeeded()
    }
}
