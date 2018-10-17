//
//  PostUITableViewCell.swift
//  Post_iOS22
//
//  Created by Ivan Ramirez on 10/16/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class PostUITableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    var post: Post? {
        didSet{
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.sizeToFit()
        timeLabel.sizeToFit()
        userLabel.sizeToFit()
    }
    
    // MARK: - Funcs
    
    func updateViews(){
        messageLabel.text = post?.text
        userLabel.text = post?.username
        timeLabel.text = post?.timestampAsString
    }
}
