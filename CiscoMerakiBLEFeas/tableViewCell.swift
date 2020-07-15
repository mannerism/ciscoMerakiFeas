//
//  tableViewCell.swift
//  CiscoMerakiBLEFeas
//
//  Created by Yu Juno on 2020/07/15.
//  Copyright © 2020 hitit. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
	// MARK: - Properties
	var buildingLabel:UILabel = UILabel()
	var distanceLabel:UILabel = UILabel()
	var classLabel:UILabel = UILabel()
	
	// MARK: - Init
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
		addViews()
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		return nil
	}
	
	// MARK: - Handlers
	func setup() {
		backgroundColor = .white
	}
	
	func addViews() {
		addSubview(buildingLabel)
		addSubview(distanceLabel)
		addSubview(classLabel)
	}
	
	func setConstraints() {
		buildingLabelConstraints()
		distanceLabelConstraints()
		classLabelConstraints()
	}
	
	// MARK: - Constraints
	func buildingLabelConstraints() {
		buildingLabel.translatesAutoresizingMaskIntoConstraints = false
		buildingLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		buildingLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		buildingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		buildingLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
	}
	
	func classLabelConstraints() {
		classLabel.translatesAutoresizingMaskIntoConstraints = false
		classLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		classLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		classLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		classLabel.topAnchor.constraint(equalTo: buildingLabel.bottomAnchor).isActive = true
	}
	
	func distanceLabelConstraints() {
		distanceLabel.translatesAutoresizingMaskIntoConstraints = false
		distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		distanceLabel.topAnchor.constraint(equalTo: classLabel.bottomAnchor).isActive = true
	}
}
