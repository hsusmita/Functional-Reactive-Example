//
//  FlattenViewModel.swift
//  Functional-Reactive-Example
//
//  Created by Pulkit Vaid on 03/05/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

class TableViewDataModel {
	var itemName: String = ""
	var price: Float = 0.0
}
extension TableViewDataModel {
	var type: String {
		return "TableViewDataModel"
	}
}

enum MenSizes: String {
	case s = "36"
	case m =  "38"
	case l =  "40"
	case xl =  "42"
}

class MenDataModel: TableViewDataModel {
	var size: MenSizes = .m

	init(name: String, price: Float, size: MenSizes) {
		super.init()
		self.itemName = name
		self.price = price
		self.size = size
	}
}

enum WomenSizes: String {
	case s = "30"
	case m =  "32"
	case l =  "34"
	case xl =  "36"
}
class WomenDataModel: TableViewDataModel {
	var size: WomenSizes = .m
	init(name: String, price: Float, size: WomenSizes) {
		super.init()
		self.itemName = name
		self.price = price
		self.size = size
	}
}

enum KidSizes: String {
	case s = "1-2 years"
	case m = "3-4 years"
	case l = "4-5 years"
	case xl = "5-6 years"
}
class KidsDataModel: TableViewDataModel {
	var size: KidSizes = .m
	init(name: String, price: Float, size: KidSizes) {
		super.init()
		self.itemName = name
		self.price = price
		self.size = size
	}
}

enum ClothingCategory: Int {
	case men, women, kids
}

class FlattenViewModel {

	let datasourceMen: MutableProperty<[TableViewDataModel]?> = MutableProperty<[TableViewDataModel]?>(nil)
	let datasourceWomen: MutableProperty<[TableViewDataModel]?> = MutableProperty<[TableViewDataModel]?>(nil)
	let datasourceKids: MutableProperty<[TableViewDataModel]?> = MutableProperty<[TableViewDataModel]?>(nil)

	var ds: SignalProducer<[TableViewDataModel], NoError>!
	var currentSelection: ClothingCategory = .men
	let clothingSignal = Signal<ClothingCategory, NoError>.pipe()

	init() {
		ds = SignalProducer(
			[datasourceMen.producer.skipNil(),
			 datasourceWomen.producer.skipNil(),
			 datasourceKids.producer.skipNil()
			])
			.flatten(.merge)
	}


	func setupDataSource() {

		switch currentSelection {
		case .men:
			datasourceMen.value = [
				MenDataModel(name: "Printed T Shirt", price: 499, size: .s),
				MenDataModel(name: "Shorts", price: 599, size: .m),
				MenDataModel(name: "Shirt T Shirt", price: 699, size: .l),
				MenDataModel(name: "Blazer", price: 799, size: .xl)
			]

		case .women:
			datasourceWomen.value = [
				WomenDataModel(name: "Tank Top", price: 499, size: .s),
				WomenDataModel(name: "Printed Dress", price: 599, size: .m),
				WomenDataModel(name: "Crop Top", price: 699, size: .l),
				WomenDataModel(name: "Black Dress", price: 799, size: .xl)
			]
		case .kids:
			datasourceKids.value = [
				KidsDataModel(name: "Iron Man T Shirt Boys", price: 499, size: .s),
				KidsDataModel(name: "Batman T Shirt Boys", price: 499, size: .m),
				KidsDataModel(name: "Swat Kats T Shirt Boys", price: 499, size: .l),
				KidsDataModel(name: "DragonBallZ T Shirt Boys", price: 499, size: .xl)

			]
		}
	}

	//MARK: - Event Generation
	func generateEvent(category: ClothingCategory, after delay: Int = 0) {
		switch category {
		case .men:
			clothingSignal.input.send(value: .men)
		case .women:
			clothingSignal.input.send(value: .women)
		case .kids:
			clothingSignal.input.send(value: .kids)
		}
		currentSelection = category
		setupDataSource()
	}

	//MARK: - TableViewHelper
	func numberofRowsInSection(section: Int) -> Int {
		switch currentSelection {
		case .men:
			return datasourceMen.value?.count ?? 0
		case .women:
			return datasourceWomen.value?.count ?? 0
		case .kids:
			return datasourceKids.value?.count ?? 0
		}
	}

	func tableViewModelforIndexPath(indexPath: IndexPath) -> TableViewDataModel? {
		switch currentSelection {
		case .men:
			guard let itemArr = datasourceMen.value as? [MenDataModel] else { return nil }
			return itemArr[indexPath.row]
		case .women:
			guard let itemArr = datasourceWomen.value as? [WomenDataModel] else { return nil }
			return itemArr[indexPath.row]
		case .kids:
			guard let itemArr = datasourceKids.value as? [KidsDataModel] else { return nil }
			return itemArr[indexPath.row]
		}
	}

}

