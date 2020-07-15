//
//  MainViewController.swift
//  CiscoMerakiBLEFeas
//
//  Created by Yu Juno on 2020/07/15.
//  Copyright © 2020 hitit. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController:UIViewController {
	// MARK: - Properties
	let tableViewCellID = "MainViewController.tableViewCellID"
	lazy var tableView:UITableView = {
		let tv = UITableView()
		tv.delegate = self
		tv.dataSource = self
		return tv
	}()
	
	lazy var findButton:UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("find", for: .normal)
		button.addTarget(self, action: #selector(handleFindButton), for: .touchUpInside)
		return button
	}()
	
	lazy var stopButton:UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("stop", for: .normal)
		button.addTarget(self, action: #selector(handleStopButton), for: .touchUpInside)
		return button
	}()
	
	var uuidString = "6d406fed-5aed-4bc5-a4fe-e5d19682ed0c"
	var locationManager = CLLocationManager()
	var beaconConstraints = [CLBeaconIdentityConstraint: [CLBeacon]]()
	var beacons = [CLBeacon]()
	
	// MARK: - Init
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		addViews()
		setConstraints()
		startMonitoring()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		stopMonitoring()
	}
	
	// MARK: - Handlers
	func startMonitoring() {
		locationManager.requestAlwaysAuthorization()
		guard let uuid = UUID(uuidString: uuidString) else {return}
		let constraint = CLBeaconIdentityConstraint(uuid: uuid)
		self.beaconConstraints[constraint] = []
		let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid.uuidString)
		locationManager.startMonitoring(for: beaconRegion)
	}
	
	func stopMonitoring() {
		// Stop monitoring when the view disappears.
		print("------------------stop monitoring-------------------")
		print("monitoredRegions: \(locationManager.monitoredRegions)")
		print("ranging Beacons: \(locationManager.monitoredRegions)")
		
		for region in locationManager.monitoredRegions {
			locationManager.stopMonitoring(for: region)
		}
		
		// Stop ranging when the view disappears.
		for constraint in beaconConstraints.keys {
			locationManager.stopRangingBeacons(satisfying: constraint)
		}
		
		print("--------------stop monitoring complete---------------")
		print("monitoredRegions: \(locationManager.monitoredRegions)")
		print("ranging Beacons: \(locationManager.monitoredRegions)")
	}
	
	func setup() {
		view.backgroundColor = .black
		configureLocationManager()
		configureTableView()
	}
	
	func addViews() {
		view.addSubview(findButton)
		view.addSubview(stopButton)
		view.addSubview(tableView)
	}
	
	func setConstraints() {
		findButtonConstraints()
		stopButtonConstraints()
		tableViewConstraints()
	}
	
	func configureLocationManager() {
		locationManager.delegate = self
		locationManager.distanceFilter = 50
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
	}
	
	func configureTableView() {
		tableView.register(TableViewCell.self, forCellReuseIdentifier: tableViewCellID)
	}
	
	func getBeaconConstraints() -> CLBeaconIdentityConstraint{
		let uuid = UUID(uuidString: uuidString)!
		let constraint = CLBeaconIdentityConstraint(uuid: uuid)
		return constraint
	}
	
	@objc func handleFindButton() {
		startMonitoring()
	}
	
	@objc func handleStopButton() {
		stopMonitoring()
	}
	
	// MARK: - Constraints
	func findButtonConstraints() {
		findButton.translatesAutoresizingMaskIntoConstraints = false
		findButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
		findButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		findButton.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
		findButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	func stopButtonConstraints() {
		stopButton.translatesAutoresizingMaskIntoConstraints = false
		stopButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
		stopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		stopButton.topAnchor.constraint(equalTo: findButton.bottomAnchor, constant: 10).isActive = true
		stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
	
	func tableViewConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.widthAnchor.constraint(equalToConstant: 600).isActive = true
		tableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
		tableView.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 20).isActive = true
		tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
}

extension MainViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
		/*
		Beacons are categorized by proximity. A beacon can satisfy
		multiple constraints and can be displayed multiple times.
		*/
		beaconConstraints[beaconConstraint] = beacons
		
		self.beacons.removeAll()
		
		var allBeacons = [CLBeacon]()
		
		for regionResult in beaconConstraints.values {
			allBeacons.append(contentsOf: regionResult)
		}
		
		for range in [CLProximity.unknown, .immediate, .near, .far] {
			let proximityBeacons = allBeacons.filter { $0.proximity == range }
			if !proximityBeacons.isEmpty {
				self.beacons = proximityBeacons
			}
		}
		print(beacons)
		tableView.reloadData()
	}
	
	func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
		let beaconRegion = region as? CLBeaconRegion
		print(state.rawValue)
		if state == .inside {
			// Start ranging when inside a region.
			manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
		} else {
			// Stop ranging when not inside a region.
			manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			print("status not determined")
		case .restricted:
			print("status restricted")
		case .denied:
			print("status denied")
		case .authorizedAlways:
			print("status authorize always")
		case .authorizedWhenInUse:
			print("status authorizedWhenInUse")
		@unknown default:
			print("status unknown")
		}
	}
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return beacons.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! TableViewCell
		let beacon = beacons[indexPath.row]
		cell.buildingLabel.text = beacon.uuid.uuidString
		cell.classLabel.text = "class number: \(beacon.minor)"
		cell.distanceLabel.text = "distance: \(beacon.accuracy)"
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(100)
	}
	
}
