//
//  RouteTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import GoogleMaps
import Polyline

class RouteTableViewCell: BaseTableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var kmView: UIView!
    @IBOutlet weak var mapView: UIView!
    
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

extension RouteTableViewCell {
    func configure(model: ListRouteResponse?) {
        guard let model = model else { return }
        selectionStyle = .none
        bgView.layer.cornerRadius = 2
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        
        let km = Int(model.actruteDist ?? 0)/1000
        distanceLabel.text = "\(km)"
        elevationLabel.text = "\(model.actruteElevgain ?? 0)"
        nameLabel.text = model.actruteName ?? ""
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(0.0), longitude: Double(0.0), zoom: 17.0)
        let screenSize = UIScreen.main.bounds
        map = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: screenSize.width - 20, height: mapView.frame.height), camera: camera)
        mapView.addSubview(self.map!)
        mapView.sendSubviewToBack(self.map!)
        
        let polyline = Polyline(encodedPolyline: model.actruteData ?? "")
        let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
        let polylineFix = decodedCoordinates ?? []
        let path = GMSMutablePath()
        for items in polylineFix {
            path.add(items)
        }
        let polylines = GMSPolyline(path: path)
        polylines.strokeColor = .bluePath
        polylines.strokeWidth = 2
        polylines.map = self.map!
        self.fitAllMarkers(_path: path)
        bgView.isUserInteractionEnabled = false
        kmView.isUserInteractionEnabled = false
    }
    
    func fitAllMarkers(_path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1..._path.count() {
            bounds = bounds.includingCoordinate(_path.coordinate(at: index))
        }
        map?.animate(with: GMSCameraUpdate.fit(bounds))
    }
}
