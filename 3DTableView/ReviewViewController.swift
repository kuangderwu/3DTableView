//
//  ReviewViewController.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/25.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var reviewImage: UIImageView!
    
    var restaurant : Restaurant? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        reviewImage.image = UIImage(named: (restaurant?.image)!)
        reviewImage.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        UIView.animate(withDuration: 0.5, animations: {
            self.reviewImage.transform = CGAffineTransform.identity
        })

        
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
