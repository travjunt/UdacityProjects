//
//  MemeDetailViewController.swift
//  MemeTest
//
//  Created by Travis McCormick on 8/5/17.
//  Copyright © 2017 TravisMcCormick. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
  
  var memes: Meme!
  
	@IBOutlet weak var imageView: UIImageView!
	
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    imageView.image = memes.memedImage
    self.tabBarController?.tabBar.isHidden = true
	
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
}
