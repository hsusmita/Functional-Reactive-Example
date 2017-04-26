//
//  ItemTableViewCell.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 26/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ItemTableViewCell: UITableViewCell {

	@IBOutlet private weak var label: UILabel!
	@IBOutlet private weak var button: UIButton!
	
	let isCellSelected: MutableProperty<Bool> = MutableProperty<Bool>(false)
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func configure(string: String) {
		label.text = string
		isCellSelected <~ button.reactive.controlEvents(.touchUpInside).map({ [unowned self] _ in
			return !self.isCellSelected.value
		})
		button.reactive.isSelected <~ isCellSelected
	}
}
