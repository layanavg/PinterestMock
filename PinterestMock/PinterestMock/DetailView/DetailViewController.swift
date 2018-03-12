//
//  DetailViewController.swift
//  PINREST
//
//  Created by Layana on 08/03/18.
//  Copyright © 2018 Experion. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var containerDetailsView: UIView!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    var photoFrameSize = CGSize.zero
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(popSuperView(gesture:)))
        swipeGesture.direction = .down
        self.view.addGestureRecognizer(swipeGesture)
        // Do any additional setup after loading the view.
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        if let photo = photo {
            imageView.image = photo.image
            captionLabel.text = photo.caption
            commentLabel.text = photo.comment
        }
        containerWidthConstraint.constant = photoFrameSize.width * 2
        containerHeightConstraint.constant = photoFrameSize.height * 2
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func popSuperView(gesture: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
