//
//  Routable.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 20/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation

protocol Routable {
	static var storyboardId: String { get }
	static var storyboardName: String { get }
}
