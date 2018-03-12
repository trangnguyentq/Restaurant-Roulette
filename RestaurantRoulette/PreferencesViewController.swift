//
//  PreferencesViewController.swift
//  RestaurantRoulette
//
//  Created by Labuser on 4/13/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var width: Int = 0
    var height: Int = 0
    var scrollView: UIScrollView!
    
    var ratingLabel: UILabel!
    var ratingStarsImageView: UIImageView!
    var ratingStarsImages: [UIImage] = []
    var minRatings = 3 {
        didSet{
            pushToMVC()
        }
    }
    
    var radiusLabel: UILabel!
    var radiusSlider: UISlider!
    var searchRadius = 5.0 {
        didSet{
            pushToMVC()
        }
    }
    
    var priceLabel: UILabel!
    var priceImageViews: [UIImageView] = []
    var priceImages: [UIImage] = []
    var onePriceTapped = true {
        didSet{
            pushToMVC()
        }
    }
    var twoPriceTapped = true {
        didSet{
            pushToMVC()
        }
    }
    var threePriceTapped = false {
        didSet{
            pushToMVC()
        }
    }
    var fourPriceTapped = false {
        didSet{
            pushToMVC()
        }
    }
    
    var typeLabel: UILabel!
    var typePickerView: UIPickerView!
    var typeArray: [String] = ["All Restaurants","American","Breakfast & Brunch", "Cafe", "Chinese", "Indian", "Mexican", "SteakHouse", "Sushi", "Vegetarian"]
    var pickedType = "All Restaurants" {
        didSet{
            pushToMVC()
        }
    }
    var dictionary: [String:String] = ["All Restaurants": "all", "American": "newamerican", "Breakfast & Brunch":"breakfast_brunch", "Cafe" : "cafes", "Chinese": "chinese", "Indian": "indpak", "Mexican": "mexican", "SteakHouse": "steak", "Sushi": "sushi", "Vegetarian": "vegetarian"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width = Int(self.view.frame.width - 60)
        self.height = 100
        scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 710)
        self.setUpRestaurantType(x:30, y: 30)
        self.addStarAssests()
        self.setupRating(x:30, y: 180)
        self.addPriceAssets()
        self.setUpPrice(x:30, y: 330)
        self.setUpSearchRadius(x: 30, y: 480)
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushToMVC(){
        let count = self.navigationController?.viewControllers.count;
        let menuVC = self.navigationController?.viewControllers[count!-2] as! MenuViewController
        menuVC.minRatings = self.minRatings
        menuVC.searchRadius = self.searchRadius
        menuVC.prices[0] = self.onePriceTapped
        menuVC.prices[1] = self.twoPriceTapped
        menuVC.prices[2] = self.threePriceTapped
        menuVC.prices[3] = self.fourPriceTapped
        menuVC.type = self.dictionary[self.pickedType]!
    }
    func setUpRestaurantType(x: Int, y: Int) {
        self.typeLabel = UILabel()
        self.typeLabel.frame = CGRect(x: x, y: y, width: Int(width), height: height/2)
        self.typeLabel.text = "Type of Food"
        self.scrollView.addSubview(self.typeLabel)
        
        self.typePickerView = UIPickerView()
        self.typePickerView.dataSource = self
        self.typePickerView.delegate = self
        self.typePickerView.frame = CGRect(x: x, y: y+50, width: Int(width), height: height)
        self.scrollView.addSubview(self.typePickerView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickedType = typeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 3*self.view.frame.width/4
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }

    func setupRating(x: Int, y: Int) {
        self.ratingLabel = UILabel()
        self.ratingLabel.frame = CGRect(x: x, y: y, width: Int(width), height: height/2)
        self.ratingLabel.text = "Rating"
        self.scrollView.addSubview(self.ratingLabel)

        self.ratingStarsImageView = UIImageView()
        self.ratingStarsImageView.frame = CGRect(x: x, y: y+50, width: Int(width), height: height)
        self.ratingStarsImageView.contentMode = .scaleAspectFit
        self.ratingStarsImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingTapped))
        self.ratingStarsImageView.addGestureRecognizer(tapRecognizer)
        self.ratingStarsImageView.image = self.ratingStarsImages[2]
        self.scrollView.addSubview(self.ratingStarsImageView)
        
    }
    func ratingTapped(gestureRecognizer: UITapGestureRecognizer) {
        let ratingView = gestureRecognizer.view!
        let tapLocation = gestureRecognizer.location(in: ratingView)
        let width = self.view.frame.width - 60
        let offset = width/5
        if (tapLocation.x < offset) {
            self.ratingStarsImageView.image = self.ratingStarsImages[0]
            self.minRatings = 1
        }
        else if (tapLocation.x < 2*offset) {
            self.ratingStarsImageView.image = self.ratingStarsImages[1]
            self.minRatings = 2
        }
        else if (tapLocation.x < 3*offset) {
            self.ratingStarsImageView.image = self.ratingStarsImages[2]
            self.minRatings = 3
        }
        else if (tapLocation.x < 4*offset) {
            self.ratingStarsImageView.image = self.ratingStarsImages[3]
            self.minRatings = 4
        }
        else {
            self.ratingStarsImageView.image = self.ratingStarsImages[4]
            self.minRatings = 5
        }
    }
    
    func addStarAssests() {
        self.ratingStarsImages.append(UIImage(named: "regular_1")!)
        self.ratingStarsImages.append(UIImage(named: "regular_2")!)
        self.ratingStarsImages.append(UIImage(named: "regular_3")!)
        self.ratingStarsImages.append(UIImage(named: "regular_4")!)
        self.ratingStarsImages.append(UIImage(named: "regular_5")!)
    }
    
    func setUpPrice(x: Int, y: Int){
        self.priceLabel = UILabel()
        self.priceLabel.frame = CGRect(x: x, y: y, width: Int(width), height: height/2)
        self.priceLabel.text = "Prices"
        self.scrollView.addSubview(self.priceLabel)
        let iconWidth = self.width/4
        
        for index in 0...3 {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: x + Int(iconWidth)*index, y: y + 50, width: Int(iconWidth), height: height)
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(priceTapped))
            imageView.addGestureRecognizer(tapRecognizer)
            if (index == 0 || index == 1) {
                imageView.image = self.priceImages[index*2 + 1]
            }
            else{
                imageView.image = self.priceImages[index*2]
            }
            self.scrollView.addSubview(imageView)
            self.priceImageViews.append(imageView)
        }
        
    }
    func priceTapped(gestureRecognizer: UITapGestureRecognizer) {
        let priceView = gestureRecognizer.view!
        let maxX = Int(priceView.frame.maxX)
        let iconReference = self.width/4 + 30
        if (maxX <= iconReference) {
            if !onePriceTapped {
                self.priceImageViews[0].image = priceImages[1]
                onePriceTapped = true
            }
            else {
                self.priceImageViews[0].image = priceImages[0]
                onePriceTapped = false
            }
        }
        else if (maxX <= iconReference*2){
            if !twoPriceTapped {
                self.priceImageViews[1].image = priceImages[3]
                twoPriceTapped = true
            }
            else {
                self.priceImageViews[1].image = priceImages[2]
                twoPriceTapped = false
            }
            
        }
        else if (maxX <= iconReference*3) {
            if !threePriceTapped {
                self.priceImageViews[2].image = priceImages[5]
                threePriceTapped = true
            }
            else {
                self.priceImageViews[2].image = priceImages[4]
                threePriceTapped = false
            }
            
        }
        else {
            if !fourPriceTapped {
                self.priceImageViews[3].image = priceImages[7]
                fourPriceTapped = true
            }
            else {
                self.priceImageViews[3].image = priceImages[6]
                fourPriceTapped = false
            }
            
        }
    }
    
    func addPriceAssets() {
        self.priceImages.append(UIImage(named: "e_1")!)
        self.priceImages.append(UIImage(named: "f_1")!)
        self.priceImages.append(UIImage(named: "e_2")!)
        self.priceImages.append(UIImage(named: "f_2")!)
        self.priceImages.append(UIImage(named: "e_3")!)
        self.priceImages.append(UIImage(named: "f_3")!)
        self.priceImages.append(UIImage(named: "e_4")!)
        self.priceImages.append(UIImage(named: "f_4")!)
    }
    
    func setUpSearchRadius(x: Int, y: Int) {
        self.radiusLabel = UILabel()
        self.radiusLabel.frame = CGRect(x: x, y: y, width: Int(width), height: height/2)
        self.radiusLabel.text = "Max Distance: 5 Miles"
        self.scrollView.addSubview(self.radiusLabel)
        
        self.radiusSlider = UISlider()
        self.radiusSlider.minimumValue = 1
        self.radiusSlider.maximumValue = 25
        self.radiusSlider.isContinuous = true
        self.radiusSlider.value = 5

        self.radiusSlider.frame = CGRect(x: x, y: y + 50, width: Int(width), height: height)
        self.radiusSlider.addTarget(self, action: #selector(radiusDidChange(sender:)), for: .valueChanged)
        self.scrollView.addSubview(self.radiusSlider)
        
    }
    
    func radiusDidChange(sender: UISlider!) {
        //self.ratingStarsImageView.image = ratingStarsImages[Int(2*round(ratingSlider.value*2)/2.0 - 2)]
        let currentRadius = self.radiusSlider.value
        let roundedRadius = round(currentRadius*10)/10
        self.searchRadius = Double(roundedRadius)
        self.radiusLabel.text = "Search Radius: " + String(roundedRadius) + " Miles"
    }
}
