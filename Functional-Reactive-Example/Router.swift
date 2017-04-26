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
		case pureFunction = 0
		case binding
		case signal
		
		var viewController: UIViewController? {
			switch self {
			case .pureFunction:
				return BindingViewController.storyboardInstance
			case .binding:
				return BindingViewController.storyboardInstance
			case .signal:
				return SignalViewController.storyboardInstance
			}
		}
		
		var title: String {
			switch self {
			case .pureFunction:
				return "Pure vs Impure"
			case .binding:
				return "Binding"
			case .signal:
				return "Create Signal"
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
