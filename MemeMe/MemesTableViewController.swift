//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Matt Henry on 3/16/20.
//  Copyright © 2020 Beardbird. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeRow"

var memes: [Meme]! {
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    return appDelegate.memes
}

class MemesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let selectedMeme = memes![indexPath.row]
        
        cell.imageView!.image = selectedMeme.originalImage

        cell.textLabel!.text = selectedMeme.topText + " " + selectedMeme.bottomText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
