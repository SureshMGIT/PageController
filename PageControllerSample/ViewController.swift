//
//  ViewController.swift
//  PageControllerSample
//
//  Created by Suresh Murugaiyan on 7/13/17.
//  Copyright © 2017 dreamorbit. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate {

    var pageVC:UIPageViewController?
    var vcArr:[UIViewController]?
    var lableMovableLength:CGFloat?
    var currentVCIndex:Int?
    
    var firstVal:CGFloat?
    var secondVal:CGFloat?
    var isMovableLengthCalculated,isScrolling:Bool?
    
    var firstVC:UIViewController?
    var secondVC:UIViewController?
    var thirdVC:UIViewController?
    var fourthVC:UIViewController?
    
    
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var lbl_Indicator: UILabel!
    @IBOutlet weak var viewParent: UIView!
    
    @IBAction func fourthAction(_ sender: Any) {
        
        if currentVCIndex != 3 {
            let btn:UIButton = sender as! UIButton
            pageVC?.setViewControllers([fourthVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            indicatorMoveWithAnimation(movableValue: btn.frame.origin.x, isFromButtonAction: true)
            currentVCIndex=3
        }
    }
    @IBOutlet weak var btn_Fourth: UIButton!
    @IBAction func thirdAction(_ sender: Any) {
        
        if currentVCIndex != 2 {
            let btn:UIButton = sender as! UIButton
            if currentVCIndex! < 2 {
                pageVC?.setViewControllers([thirdVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }else{
                pageVC?.setViewControllers([thirdVC!], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
            }
            
            indicatorMoveWithAnimation(movableValue: btn.frame.origin.x, isFromButtonAction: true)
            currentVCIndex=2
        }
    }
    @IBOutlet weak var btn_Third: UIButton!
    @IBAction func secondAction(_ sender: Any) {
        
        if currentVCIndex != 1 {
            let btn:UIButton = sender as! UIButton
            if currentVCIndex! < 1 {
                pageVC?.setViewControllers([secondVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }else{
                pageVC?.setViewControllers([secondVC!], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
            }
            
            indicatorMoveWithAnimation(movableValue: btn.frame.origin.x, isFromButtonAction: true)
            currentVCIndex=1
        }
        
    }
    @IBOutlet weak var btn_Second: UIButton!
    @IBAction func firstAction(_ sender: Any) {
        if currentVCIndex != 0 {
            let btn:UIButton = sender as! UIButton
            pageVC?.setViewControllers([firstVC!], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
            indicatorMoveWithAnimation(movableValue: btn.frame.origin.x, isFromButtonAction: true)
            currentVCIndex=0
        }
    }
    @IBOutlet weak var btn_First: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isMovableLengthCalculated=false
        createPageViewController()
        currentVCIndex=0
        isScrolling=false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isMovableLengthCalculated! {
            self.view.layoutIfNeeded()
            isMovableLengthCalculated=true
            let indicatorWidth = lbl_Indicator.frame.size.width
            lableMovableLength = indicatorWidth/self.view.frame.size.width
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func createPageViewController(){
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        firstVC = storyboard.instantiateViewController(withIdentifier: "FirstController") as! FirstController
        secondVC = storyboard.instantiateViewController(withIdentifier: "SecondController") as! SecondController
        thirdVC = storyboard.instantiateViewController(withIdentifier: "ThirdController") as! ThirdController
        fourthVC = storyboard.instantiateViewController(withIdentifier: "FourthController") as! FourthController
        vcArr = [firstVC!,secondVC!,thirdVC!,fourthVC!]
        
        pageVC=UIPageViewController.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        pageVC?.dataSource=self
        pageVC?.delegate=self
        
        
        pageVC?.setViewControllers([firstVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        self.addChildViewController(pageVC!)
        pageVC?.view.frame=CGRect(x: 0, y: 53.0, width: self.view.frame.size.width, height: self.view.frame.size.height-53.0)
        self.view.addSubview((pageVC?.view)!)
        
        let pgvSubviews = pageVC?.view.subviews
        for scrol in pgvSubviews! {
            if scrol is UIScrollView {
                let scrolPage = scrol as! UIScrollView
                scrolPage.delegate=self
                break
            }
        }
        
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        
        let vCS = pageViewController.viewControllers
        let topVC:UIViewController? = vCS?[0]
        
            var index = vcArr?.index(of: topVC!)
            if index!>=1 && index!<=3 {
                index! -= 1
                let nextVC:UIViewController? = vcArr?[index!]
                return nextVC!
            }
         return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        
        let vCS = pageViewController.viewControllers
        let topVC:UIViewController? = vCS?[0]
        
        
            var index = vcArr?.index(of: topVC!)
            if index!>=0 && index!<3 {
                index! += 1
                let nextVC:UIViewController? = vcArr?[index!]
                return nextVC!
            }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let tempVC = pageViewController.viewControllers?[0]
        let tempIndex = vcArr?.index(of: tempVC!)
        currentVCIndex=tempIndex
        isScrolling=false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isScrolling!==true {
            
            secondVal = scrollView.contentOffset.x
            if secondVal != self.view.frame.size.width {
                let tempVal2 = secondVal!-firstVal!
                if currentVCIndex==0 && tempVal2<0 && secondVal!<self.view.frame.size.width {
                    return
                }
                if currentVCIndex==3 && tempVal2>0 && secondVal!>self.view.frame.size.width {
                    return
                }
                
                indicatorMoveWithAnimation(movableValue: tempVal2,isFromButtonAction: false)
                firstVal=secondVal!
            }
        }
}
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        firstVal=scrollView.contentOffset.x
        isScrolling=true
    }
    
    func indicatorMoveWithAnimation(movableValue diffVal:CGFloat,isFromButtonAction:Bool) -> Void {
        var movableVal:CGFloat?
        if isFromButtonAction==false {
            let tempVal = diffVal*lableMovableLength!
            let tempVal2 = constraintLeading.constant
            movableVal=tempVal2+tempVal
        }else{
            movableVal=diffVal
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.constraintLeading.constant=movableVal!
        })
    }
}

