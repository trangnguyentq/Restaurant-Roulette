//
//  PopUpViewController.swift
//  RestaurantRoulette
//
//  Created by Labuser on 4/16/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    var wheelViewController : WheelViewController!

    @IBOutlet var popUpView: UIView!
    
    @IBOutlet weak var logoImg: UIImageView!
    
    @IBOutlet weak var details: UILabel!
    
    var superViewFrame: CGRect!
    
    var YelpUrl: String!
    let screenSize:CGRect = UIScreen.main.bounds
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!, frame: CGRect) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.superViewFrame = frame
        self.superViewFrame.origin.y = 0
        print(frame)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //popUpView.center = CGPoint(x: 100, y:);
        //popUpView.frame.origin.x = 20
        //popUpView.frame.origin.y =
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        //self.popUpView.bounds(wheelViewController)
        self.popUpView.frame = self.superViewFrame
    }
    
    open func showInView(_ aView: UIView!, withImage image : String!, withMessage message: String!, withURL url: String!, animated: Bool)
    {
        aView.addSubview(self.view)
        if let url = NSURL(string: image) {
            if let data = NSData(contentsOf: url as URL) {
                logoImg!.image = UIImage(data: data as Data)
            }
        }
        YelpUrl = url
        details!.text = message
        if animated
        {
            self.showAnimate()
        }
    }
    
    
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    @IBAction open func closePopup(_ sender: AnyObject) {
        self.removeAnimate()
    }
    
    @IBOutlet weak var goToYelp: UIButton!
    
    @IBAction func goToYelp(_ sender: Any) {
        if var weburl = NSURL(string: "http://www.yelp.com/biz/" + YelpUrl) {
            if UIApplication.shared.canOpenURL(NSURL(string: "yelp5.3:" ) as! URL) == true {
                weburl = NSURL(string: "yelp5.3:///biz/" + YelpUrl)!
                UIApplication.shared.openURL(weburl as URL)
            } else {
                UIApplication.shared.openURL(weburl as URL)
            }
        }
    }
    

}
