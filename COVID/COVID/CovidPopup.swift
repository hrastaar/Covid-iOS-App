//
//  CovidPopup.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/13/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CovidPopup: UIView {
    
    @IBOutlet var popupHeadingLabel: UILabel!
    @IBOutlet var confirmedCaseLabel: UILabel!
    @IBOutlet var criticalCaseLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    var covidData: CovidData?
    
    func designPopup() {
        
        self.covidData = CovidData()
        self.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.superview!).offset(UIScreen.main.bounds.maxY*(1/4))
            make.left.equalTo(self.superview!).offset(30)
            make.bottom.equalTo(self.superview!).offset(-UIScreen.main.bounds.maxY*(1/4))
            make.right.equalTo(self.superview!).offset(-30)
        }
        self.popupHeadingLabel = UILabel()
        self.confirmedCaseLabel = UILabel()
        self.criticalCaseLabel = UILabel()
        self.deathsLabel = UILabel()
        self.recoveredLabel = UILabel()
        while(self.covidData?.confirmedCount == "") {
            // wait until a response is given TODO: Implement a better way of doing this
        }
        updateCovidLabels()
        
        self.addSubview(popupHeadingLabel)
        self.addSubview(confirmedCaseLabel)
        self.addSubview(criticalCaseLabel)
        self.addSubview(deathsLabel)
        self.addSubview(recoveredLabel)
    }
    
    func updateCovidLabels() {
        
        print("Entered updateCovidLabels")
        
        self.popupHeadingLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 25, width: superview!.bounds.width, height: 75))
        self.popupHeadingLabel.textAlignment = .center
        self.popupHeadingLabel.font = UIFont(name: "D-DIN", size: 35)
        self.popupHeadingLabel.center.x = superview!.center.x

        self.confirmedCaseLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 100, width: superview!.bounds.width, height: 50))
        self.confirmedCaseLabel.textAlignment = .center
        self.confirmedCaseLabel.numberOfLines = 0
        self.confirmedCaseLabel.font = UIFont(name: "D-DIN", size: 20)
        self.confirmedCaseLabel.center.x = superview!.center.x

        
        self.criticalCaseLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 150, width: superview!.bounds.width, height: 50))
        self.criticalCaseLabel.textAlignment = .center
        self.criticalCaseLabel.numberOfLines = 0
        self.criticalCaseLabel.font = UIFont(name: "D-DIN", size: 20)
        self.criticalCaseLabel.center.x = superview!.center.x

        
        self.deathsLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 200, width: superview!.bounds.width, height: 50))
        self.deathsLabel.textAlignment = .center
        self.deathsLabel.numberOfLines = 0
        self.deathsLabel.font = UIFont(name: "D-DIN", size: 20)
        self.deathsLabel.center.x = superview!.center.x

        
        self.recoveredLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 250, width: superview!.bounds.width, height: 50))
        self.recoveredLabel.textAlignment = .center
        self.recoveredLabel.numberOfLines = 0
        self.recoveredLabel.font = UIFont(name: "D-DIN", size: 20)
        self.recoveredLabel.center.x = superview!.center.x

        
        print("Created label details")
        
        self.popupHeadingLabel.text = "Current Covid Data"
        self.confirmedCaseLabel.text = self.covidData!.confirmedCount + " confirmed cases"
        self.criticalCaseLabel.text = self.covidData!.criticalCount + " patients in critical condition"
        self.deathsLabel.text = self.covidData!.deathCount + " people died."
        self.recoveredLabel.text = self.covidData!.recoveredCount + " people recovered"
        
        print("Updated label text")
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }

}
