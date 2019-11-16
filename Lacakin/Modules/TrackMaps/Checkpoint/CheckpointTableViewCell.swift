//
//  CheckpointTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import GoogleMaps

class CheckpointTableViewCell: BaseTableViewCell {

    var didSelectedCheckin: (() -> Void)?
    var didSelectedDirection: (() -> Void)?
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    
    var map: GMSMapView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CheckpointTableViewCell {
    func configure(model: ListCheckpointResponse?) {
        selectionStyle = .none
        guard let model = model else { return }
        var point = model.actcpPoint ?? ""
        point = point.replacingOccurrences(of: "[", with: "")
        point = point.replacingOccurrences(of: "]", with: "")
        let latLong = point.components(separatedBy: ",")
        let lat = latLong.first ?? "0"
        let lng = latLong.last ?? "0"
        let camera = GMSCameraPosition.camera(withLatitude: (Double(lat))!, longitude: (Double(lng))!, zoom: 17.0)
        map = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 100, height: mapView.frame.size.height), camera: camera)
        map?.isUserInteractionEnabled = false
        mapView.addSubview(self.map!)
        mapView.sendSubviewToBack(self.map!)
        mapView.isUserInteractionEnabled = false
        let image = UIImageView()
        let url = URL(string: model.actcpIcon ?? "")
        image.kf.setImage(with: url, placeholder: UIImage(named: ""))
        image.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        image.layer.cornerRadius = 8
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        let marker = GMSMarker(position: CLLocationCoordinate2D.init(latitude: (Double(lat))!, longitude: (Double(lng))!))
        marker.iconView = image
        marker.map = self.map
        
        bgView.layer.cornerRadius = 2
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        checkinButton.addTarget(self, action: #selector(checkin), for: .touchUpInside)
        directionButton.addTarget(self, action: #selector(direction), for: .touchUpInside)
        descLabel.text = model.actcpName ?? ""
    }
    
    @objc func checkin() {
        didSelectedCheckin?()
    }
    
    @objc func direction() {
        didSelectedDirection?()
    }
    
}
