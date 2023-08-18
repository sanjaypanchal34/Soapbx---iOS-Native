//
//  SplashVC.swift
//  SoapBx
//
//  Created by Mac on 03/07/23.
//

import UIKit

class SplashVC: UIViewController {
    
    
    @IBOutlet weak var redBalloon: UIImageView!
    @IBOutlet weak var blueBalloon: UIImageView!
    @IBOutlet weak var greenBalloon: UIImageView!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var soapBxText: UIImageView!
    @IBOutlet weak var subtitle: UIImageView!
    @IBOutlet weak var subtitle2: UIImageView!
    @IBOutlet weak var smallBlueBalloon: UIImageView!
    @IBOutlet weak var smallRedBalloon: UIImageView!
    @IBOutlet weak var smallGreenBalloon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Hiding objects before app opening
        goToInitialScreen()
        return
        
        redBalloon.center.x += view.bounds.width
        blueBalloon.center.x -= view.bounds.width
        greenBalloon.center.y -= view.bounds.height
        firstStar.center.x = self.view.bounds.midX
        secondStar.center.x = self.view.bounds.midX
        thirdStar.center.x = self.view.bounds.midX
        
//        smallBlueBalloon.center.y -= view.bounds.height
//        smallRedBalloon.center.y -= view.bounds.height
//        smallGreenBalloon.center.y -= view.bounds.height
        
        firstStar.alpha = 0
        secondStar.alpha = 0
        thirdStar.alpha = 0
        soapBxText.alpha = 0
        subtitle.alpha = 0
        subtitle2.alpha = 0
        smallRedBalloon.alpha = 0
        smallGreenBalloon.alpha = 0
        smallBlueBalloon.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //Logo Main Animations
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: {
            self.redBalloon.center.x = self.view.bounds.midX }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: UIView.AnimationOptions(), animations: {
            self.blueBalloon.center.x = self.view.bounds.midX }, completion: nil)
        UIView.animate(withDuration: 2.0, delay: 1.0, options: UIView.AnimationOptions(), animations: {
            self.greenBalloon.center.y = self.view.bounds.midY-120 }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 3.0, options: UIView.AnimationOptions(), animations: {
            self.firstStar.alpha = 1 }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 3.3, options: UIView.AnimationOptions(), animations: {
            self.secondStar.alpha = 1 }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 3.6, options: UIView.AnimationOptions(), animations: {
            self.thirdStar.alpha = 1 }, completion: nil)
        
        
        UIView.animate(withDuration: 0.7, delay: 3.9, options: UIView.AnimationOptions(), animations: {
            self.soapBxText.alpha = 1.0 }, completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 5.4, options: UIView.AnimationOptions(), animations: {
            self.subtitle.alpha = 1 }, completion: nil)
        UIView.animate(withDuration: 2.0, delay: 7.2, options: UIView.AnimationOptions(), animations: {
            self.subtitle2.alpha = 1 }, completion: nil)
        
        UIView.animate(withDuration: 30.0, delay: 5.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            _ = Timer.scheduledTimer(timeInterval: 5.5, target: self, selector:  #selector(self.hapticBalloon), userInfo: nil, repeats: false)
            self.smallRedBalloon.alpha = 0.0
            self.smallRedBalloon.center.y -= self.view.bounds.height
        }, completion: {

            (value: Bool) in
        })

        UIView.animate(withDuration: 30.0, delay: 6.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            _ = Timer.scheduledTimer(timeInterval: 6.1, target: self, selector:  #selector(self.hapticBalloon), userInfo: nil, repeats: false)
            self.smallBlueBalloon.alpha = 0.0
            self.smallBlueBalloon.center.y -= self.view.bounds.height
        }, completion: {

            (value: Bool) in
        })

        UIView.animate(withDuration: 30.0, delay: 6.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            _ = Timer.scheduledTimer(timeInterval: 6.6, target: self, selector:  #selector(self.hapticBalloon), userInfo: nil, repeats: false)
            _ = Timer.scheduledTimer(timeInterval: 7.6, target: self, selector:  #selector(self.resetBalloons), userInfo: nil, repeats: false)
            self.smallGreenBalloon.alpha = 0.0
            self.smallGreenBalloon.center.y -= self.view.bounds.height
        }, completion: {

            (value: Bool) in
        })
        

        
        UIView.animate(withDuration: 26.0, delay: 6.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            _ = Timer.scheduledTimer(timeInterval: 7.1, target: self, selector:  #selector(self.hapticBalloon), userInfo: nil, repeats: false)
            self.smallRedBalloon.alpha = 1.0
            self.smallRedBalloon.center.y -= self.view.bounds.height
        }, completion: {

            (value: Bool) in
        })
        
        UIView.animate(withDuration: 26.0, delay: 7.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            _ = Timer.scheduledTimer(timeInterval: 7.3, target: self, selector:  #selector(self.hapticBalloon), userInfo: nil, repeats: false)
            self.smallBlueBalloon.alpha = 1.0
            self.smallBlueBalloon.center.y -= self.view.bounds.height
        }, completion: {

            (value: Bool) in
        })
        
        UIView.animate(withDuration: 26.0, delay: 7.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: [], animations: {
            _ = Timer.scheduledTimer(timeInterval: 7.8, target: self, selector:  #selector(self.hapticBalloon), userInfo: nil, repeats: false)
            //_ = Timer.scheduledTimer(timeInterval: 6.6, target: self, selector:  #selector(self.resetBalloons), userInfo: nil, repeats: false)
            self.smallGreenBalloon.alpha = 1.0
            self.smallGreenBalloon.center.y -= self.view.bounds.height
        }, completion: {

            (value: Bool) in
        })
        
        _ = Timer.scheduledTimer(timeInterval: 13.5, target: self, selector:  #selector(goToInitialScreen), userInfo: nil, repeats: false)
        
        //Alternative balloon animations
        
//        animateBalloon(smallRedBalloon)
//        animateBalloon(smallBlueBalloon)
//        animateBalloon(smallGreenBalloon)
       
        
    }
    
    @objc func hapticBalloon() {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
    }
    
    @objc func goToInitialScreen() {
        if AuthorizedUser.isUserSessionAvailable(){
            if authUser?.loginType  == .userLogin  {
                if authUser?.user?.step == 2 {
                    mackRootView(ProfileCoverVC())
                }
                else if authUser?.user?.step == 3 {
                    mackRootView(YouInterestedVC())
                }
                else if authUser?.user?.step == 4 {
                    mackRootView(SubscribeVC())
                }
                else {
                    mackRootView(HomeVC())
                }
            }
            else {
                mackRootView(HomeVC())
            }
        } else {
            mackRootView(LoginVC())
        }
    }
    
    
    @objc func resetBalloons() {
        
        self.smallRedBalloon.center.y = self.view.bounds.height
        self.smallGreenBalloon.center.y = self.view.bounds.height
        self.smallBlueBalloon.center.y = self.view.bounds.height
        
    }
    
    //Balloon flight methods
    
        func animateBalloon(_ balloon: UIImageView){
            let velocity = 45.0/view.frame.size.height
            let duracao = (view.frame.size.height - balloon.frame.origin.y) * velocity*1.5
            UIView.animate(withDuration: TimeInterval(duracao),delay:0.0, options:[.curveEaseOut], animations: {
                balloon.frame.origin.y = -self.view.frame.size.height
                },  completion: {_ in
                    //balloon return to screen
                    balloon.frame.origin.y = balloon.frame.size.height*3.5
                    self.animateBalloon(balloon)
            })
        }
    
    
//    private func generateHapticFeedback(for hapticFeedback: HapticFeedback) {
//        switch hapticFeedback {
//        case .selection:
//            // Initialize Selection Feedback Generator
//            let feedbackGenerator = UISelectionFeedbackGenerator()
//
//            // Trigger Haptic Feedback
//            feedbackGenerator.selectionChanged()
//        case .impact(let feedbackStyle):
//            // Initialize Impact Feedback Generator
//            let feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
//
//            // Trigger Haptic Feedback
//            feedbackGenerator.impactOccurred()
//        case .notification(let feedbackType):
//            // Initialize Notification Feedback Generator
//            let feedbackGenerator = UINotificationFeedbackGenerator()
//
//            // Trigger Haptic Feedback
//            feedbackGenerator.notificationOccurred(feedbackType)
//        }
//    }
    

    

}
