//
//  PhotoListCollectionViewController.swift
//  PINREST
//
//  Created by Layana on 08/03/18.
//  Copyright © 2018 Experion. All rights reserved.
//

import UIKit

class PhotoListCollectionViewController: UICollectionViewController {
     var photos = Photo.allPhotos()
    var zoomRect = CGRect.zero
    var photoRect = CGRect.zero
    var selectedIndex: IndexPath = IndexPath()
    var detailPage = DetailViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        // Set the PinterestLayout delegate
        let customLayout = PinRestLayout()
        collectionView?.collectionViewLayout = customLayout
        if let layout = collectionView?.collectionViewLayout as? PinRestLayout {
            layout.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        if let annotateCell = cell as? PhotoCell {
            annotateCell.photo = photos[indexPath.item]
        }
        return cell
    }

    func animateZoomforCell(zoomCell : UICollectionViewCell)
    {
        if let photocell = zoomCell as? PhotoCell {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {
                    photocell.containerView.layer.borderColor = UIColor.lightGray.cgColor
                    photocell.containerView.layer.borderWidth = 4.0
                    photocell.containerView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
            },
                completion: nil)
        }
    }
    func animateZoomforCellremove(zoomCell : UICollectionViewCell)
    {
        if let photocell = zoomCell as? PhotoCell {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: UIView.AnimationOptions.curveEaseOut,
                animations: {
                    photocell.containerView.layer.borderColor = UIColor.clear.cgColor
                    photocell.containerView.layer.borderWidth = 0.0
                    photocell.containerView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            },
                completion: nil)
        }
    }
    func presentPopViewController(indexPath: IndexPath) {
        selectedIndex = indexPath
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popView = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        popView.photo = photos[indexPath.item]
        popView.photoFrameSize = zoomRect.size
        popView.view.frame = UIScreen.main.bounds
        popView.transitioningDelegate = self
        detailPage = popView
        self.present(popView, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.animateZoomforCell(zoomCell: collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell())
    }
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.animateZoomforCellremove(zoomCell: collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell())
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        zoomRect = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        self.presentPopViewController(indexPath: indexPath)
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredVertically, animated: true)
        
    }
}
extension PhotoListCollectionViewController: PinRestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return photos[indexPath.item].image.size.height
    }
}
extension PhotoListCollectionViewController: UIViewControllerTransitioningDelegate {
    func getSnapFrame() -> CGRect {
        let snapFrameWidth = zoomRect.size.width * 2
        let snapFrameHeight = zoomRect.size.height * 2
        return CGRect(x: (self.view.frame.size.width - snapFrameWidth) / 2, y: 40, width: snapFrameWidth, height: snapFrameHeight)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimationController(originFrame: zoomRect, snapFrame: self.getSnapFrame())
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView?.layoutAttributesForItem(at: selectedIndex)
        zoomRect = (collectionView?.convert(theAttributes.frame, to: collectionView?.superview)) ?? CGRect.zero
        return DismissAnimationController(originFrame: zoomRect, snapFrame: getSnapFrame())
    }
}
