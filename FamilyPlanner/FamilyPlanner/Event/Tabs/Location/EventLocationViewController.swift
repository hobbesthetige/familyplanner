//
//  EventLocationViewController.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/20/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import UIKit
import NXUIKit
import MapKit
import AppData
import FLAnimatedImage

public class EventLocationViewController : UIViewController
{
    public var location : Location?
    
    @IBOutlet private var mapView : MKMapView!
    
    @IBOutlet private var nameLabel : UILabel!
    @IBOutlet private var addressLabel : UILabel!
    @IBOutlet private var notesLabel : UILabel!
    
    @IBOutlet private var directionsButton : UIButton!
    @IBOutlet private var editButton : UIButton!
    
    @IBOutlet private var noLocationPanel : UIView!
    @IBOutlet weak var noLocationImageView: FLAnimatedImageView!
    
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        
        setupForLocation()
    }
    
    private func setupForNoLocation() {
        
        directionsButton.isEnabled = false
        editButton.setTitle("Add Location", for: .normal)
        
        nameLabel.text = "No location provided"
        addressLabel.text = nil
        notesLabel.text = nil
        
        let dataAsset = NSDataAsset(name: "waitforit", bundle: Bundle.main)
        noLocationImageView.animatedImage = FLAnimatedImage(animatedGIFData: dataAsset!.data)
        showNoLocationPanel()
    }
    
    private func setupForLocation() {
        
        guard let location = location else {
            
            setupForNoLocation()
            return
        }
        
        nameLabel.text = location.title
        addressLabel.text = location.formattedAddress
        notesLabel.text = location.instructions
        
        showPlacemarkOnMap(placemark: location.mapPlacemark)
    }
    
    private func showNoLocationPanel() {
        
        guard noLocationPanel.superview == nil else { return }
        
        view.addSubview(noLocationPanel)
        
        noLocationPanel.mas_makeConstraints { (make) in
            make?.edges.mas_equalTo()(self.mapView)
        }
    }
    
    private func showPlacemarkOnMap(placemark : MKPlacemark) {
        
        var region = mapView.region
        
        region.center = placemark.coordinate
        region.span.longitudeDelta /= 64.0
        region.span.latitudeDelta /= 64.0
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(placemark)
    }
    
    private func hideNoLocationPanel() {
        
    }
    
    
    @IBAction func getDirectionsButtonAction(_ sender: UIButton) {
        
        guard let location = location else { return }
        
        let mapItem = MKMapItem(placemark: location.mapPlacemark)
        
        mapItem.openInMaps(launchOptions: nil)
    }
}
