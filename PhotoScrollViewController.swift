//
//  ViewController.swift
//  ImageScroller
//
//  Created by Greg Heo on 2014-12-18.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class PhotoScrollViewController: UIViewController {
    
  var imageView: UIImageView!
  var scrollView: UIScrollView!
  // label to show the origin points of the image
  var originLabel: UILabel!
    
  var showOriginLable:Bool = false{
        didSet{
            originLabel.hidden = !showOriginLable
        }
    }

  override func viewDidLoad() {
    super.viewDidLoad()

    imageView = UIImageView(image: UIImage(named: "zombies.jpg"))
    
    // Set up scrollView's frame: same as the window bounds
    // Set up the scrollView's content size: same as the imageView's bounds.size
    scrollView = UIScrollView(frame: view.bounds)
    scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    scrollView.backgroundColor = UIColor.blackColor()
    scrollView.contentSize = imageView.bounds.size

    scrollView.addSubview(imageView)
    view.addSubview(scrollView)

    originLabel = UILabel(frame: CGRect(x: 20, y: 30, width: 0, height: 0))
    originLabel.backgroundColor = UIColor.blackColor()
    originLabel.textColor = UIColor.whiteColor()
    view.addSubview(originLabel)

    scrollView.delegate = self
    
    updateMinZoomScaleForSize(scrollView.bounds.size)
    // Make sure zoomScale will not bounce to minimalScale when changing between portrait and 
    // landscape mode
    scrollView.zoomScale = scrollView.minimumZoomScale
    
    centerImage()
  }
   
  // Readjust the scale when transfer between portait mode and landscape mode
  override func viewWillLayoutSubviews() {
        updateMinZoomScaleForSize(scrollView.bounds.size)
        centerImage()
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    
    /* viewWillTransitionToSize(_:withTransitionCoordinator:) is new in iOS 8 and will
    let you handle changes to the view on rotation. Here, you first calculate the existing
    center point – as previously mentioned, there’s a little math here to go from
    content offset + half the screen size to calculate the center point of the image.
    Then, you use animateAlongsideTransition to add changes the view while it rotates.
    All you need to do here is set the new content offset. Notice the method has the
    size parameter, which is the size of the view after rotation. So you can use this to
    calculate the new content offset – it’s just the saved center point minus half the
    new screen size.*/
    
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let centerPoint = CGPoint(x: scrollView.contentOffset.x + scrollView.bounds.width / 2, y: scrollView.contentOffset.y + scrollView.bounds.height / 2)
        
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.scrollView.contentOffset = CGPoint(x: centerPoint.x - size.width / 2, y: centerPoint.y - size.height / 2) }, completion: nil)
    }
    
    // MARK: - Helper Methods

    func updateMinZoomScaleForSize(size: CGSize) {
        
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        
        let minScale = min(widthScale, heightScale)
        
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = minScale
        
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
    }
    
    func centerImage() {
        
        let imageFrame = imageView.frame
        let scrollViewBounds = scrollView.bounds
        
        let heightOffset = imageFrame.height < scrollViewBounds.height ? (scrollViewBounds.height - imageFrame.height) / 2 : 0
        
        let widthOffset = imageFrame.width < scrollViewBounds.width ? (scrollViewBounds.width - imageFrame.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: heightOffset, left: widthOffset, bottom: heightOffset, right: widthOffset)
    }
    
}

// MARK: - UIScrollViewDelegate

extension PhotoScrollViewController: UIScrollViewDelegate {
    
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
  func scrollViewDidScroll(scrollView: UIScrollView) {
    originLabel.text = "\(scrollView.contentOffset)"
    originLabel.sizeToFit()
    centerImage()
  }
}
