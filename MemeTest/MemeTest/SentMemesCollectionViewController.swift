//
//  SentMemesCollectionViewController.swift
//  MemeTest
//
//  Created by Travis McCormick on 8/2/17.
//  Copyright © 2017 TravisMcCormick. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
	
  @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
	
  var memes: [Meme]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
	
	let space: CGFloat = 3.0
	let dimension = (self.view.frame.size.width - (2 * space)) / 3
	let hDimension = (self.view.frame.size.height - (2 * space)) / 3
	
	flowlayout.minimumLineSpacing = space
	flowlayout.minimumInteritemSpacing = space
	flowlayout.itemSize = CGSize(width: dimension, height: dimension)
	
	
  }

  override func viewWillAppear(_ animated: Bool) {
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	memes = appDelegate.memes
	self.collectionView?.reloadData()
	
    super.viewWillAppear(animated)
	super.collectionView?.reloadData()
    self.tabBarController?.tabBar.isHidden = false
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
	
    return self.memes.count
  }
	
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	
    let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
    detailController.memes = memes[indexPath.item]
    self.navigationController?.pushViewController(detailController, animated: true)
  }
	
  override func collectionView(_ collectionsView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
		let meme = self.memes[(indexPath as NSIndexPath).row]
	
		cell.memeImageView.image = meme.memedImage
		
		return cell
	}

}
