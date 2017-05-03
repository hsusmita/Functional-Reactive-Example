//
//  Router.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 20/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

class Router {
	
	enum Destination: Int {
		case signal
		case signalProducer
		case action
		case binding
		case transform
		case aggregate
		case combine
		case flatten
		case limit
		case logical
		
		var viewController: UIViewController? {
			switch self {
			case .signal:
				return SignalViewController.storyboardInstance
			case .signalProducer:
				return SignalProducerViewController.storyboardInstance
			case .action:
				return ValidatorAndActionViewController.storyboardInstance
			case .binding:
				return BindingViewController.storyboardInstance
			case .transform:
				return TransformOperatorViewController.storyboardInstance
			case .combine:
				return CombineOperatorViewController.storyboardInstance
			case .flatten:
				return FlattenViewController.storyboardInstance
			default:
				return BindingViewController.storyboardInstance
			}
		}
		
		var title: String {
			switch self {
			case .signal:
				return "Signal"
			case .signalProducer:
				return "Signal Producer"
			case .binding:
				return "Binding"
			case .action:
				return "Action"
			case .transform:
				return "Transform Operators"
			case .aggregate:
				return "Aggregate Operators"
			case .combine:
				return "Combine Operators"
			case .flatten:
				return "Flatten Operators"
			case .limit:
				return "Limiting Operators"
			case .logical:
				return "Logical Operators"
			}
		}
	}
	
	private let rootViewController: UIViewController
	
	init(root: UIViewController) {
		self.rootViewController = root
	}
	
	func present(destination: Destination) {
		if let vc = destination.viewController {
			rootViewController.navigationController?.pushViewController(vc, animated: true)
		}
	}
}

extension Routable where Self: UIViewController {
	static var storyboardInstance: Self? {
		let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
		let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
		return viewController as? Self
	}
}
