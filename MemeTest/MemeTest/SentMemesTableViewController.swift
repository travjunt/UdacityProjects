//
//  SentMemesTableViewController.swift
//  MemeTest
//
//  Created by Travis McCormick on 8/8/17.
//  Copyright © 2017 TravisMcCormick. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
	
	var memes: [Meme]!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		memes = appDelegate.memes
		tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
		memeDetailViewController.memes = memes[indexPath.row]
		navigationController?.pushViewController(memeDetailViewController, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return memes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
		let meme = self.memes[(indexPath as NSIndexPath).row]
		
		cell.memeImageView?.image = meme.memedImage
		cell.topBottomText?.text = "\(meme.topTextField) \(meme.bottomTextField)"

		
		return cell
	}
	
	
}
