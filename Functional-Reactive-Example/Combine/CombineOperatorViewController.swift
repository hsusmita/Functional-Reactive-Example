//
//  CombineOperatorViewController.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 26/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit

class CombineOperatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension CombineOperatorViewController: Routable {
	static var storyboardId: String {
		return "CombineOperatorViewController"
	}
	
	static var storyboardName: String {
		return "Main"
	}
}
