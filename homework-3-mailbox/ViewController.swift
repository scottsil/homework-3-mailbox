//
//  ViewController.swift
//  homework-3-mailbox
//
//  Created by Scott Silverman on 2/21/15.
//  Copyright (c) 2015 Scott Silverman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageListScrollView: UIScrollView!
    @IBOutlet weak var messageFeedView: UIView!
    @IBOutlet weak var firstMessageImageView: UIImageView!
    @IBOutlet weak var firstMessageView: UIView!
    @IBOutlet weak var leftActionIcon: UIView!
    @IBOutlet weak var rightActionIcon: UIView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var messageFeedImageView: UIImageView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var mailboxView: UIView!
    
    var messageStartingCenter: CGPoint!
    var primaryMessageAction: CGFloat!
    var secondaryMessageAction: CGFloat!
    var leftActionIconStartingCenter: CGPoint!
    var rightActionIconStartingCenter: CGPoint!
    var leftActionCompletePosition: CGPoint!
    var rightActionCompletePosition: CGPoint!
    var messageFeedImageViewStartingCenter: CGPoint!
    var mailboxViewStartingCenter: CGPoint!
    var firstMessageHidden: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        messageListScrollView.contentSize = messageFeedView.frame.size
        primaryMessageAction = 60
        secondaryMessageAction = 260
        archiveIcon.alpha = 0
        deleteIcon.alpha = 0
        listIcon.alpha = 0
        laterIcon.alpha = 0
        listImageView.hidden = true
        rescheduleImageView.hidden = true
        firstMessageHidden = false
        
        // Programatically add edge pan gesture to mailbox view
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mailboxView.addGestureRecognizer(edgeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            messageStartingCenter = firstMessageImageView.center
            leftActionIconStartingCenter = leftActionIcon.center
            rightActionIconStartingCenter = rightActionIcon.center
        } else if (sender.state == UIGestureRecognizerState.Changed){
            firstMessageImageView.center = CGPoint(x: messageStartingCenter.x + translation.x, y: messageStartingCenter.y)
            println("\(translation)")
            var offset = Float(translation.x)
            var leftIconOpacity = convertValue(offset, 20, 60, 0, 1)
            var rightIconOpacity = convertValue(offset, -60, -20, 1, 0)
            archiveIcon.alpha = CGFloat(leftIconOpacity)
            laterIcon.alpha = CGFloat(rightIconOpacity)
            if (translation.x > primaryMessageAction && translation.x < secondaryMessageAction) {
                firstMessageView.backgroundColor = UIColor(red:0.404, green:0.843, blue:0.408, alpha: 1)
                archiveIcon.alpha = 1
                deleteIcon.alpha = 0
                leftActionIcon.center = CGPoint(x: leftActionIconStartingCenter.x + (translation.x - primaryMessageAction), y: leftActionIconStartingCenter.y)
            } else if (translation.x >= secondaryMessageAction) {
                firstMessageView.backgroundColor = UIColor(red:0.929, green:0.333, blue:0.129, alpha: 1)
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
                leftActionIcon.center = CGPoint(x: leftActionIconStartingCenter.x + (translation.x - primaryMessageAction), y: leftActionIconStartingCenter.y)
            } else if (translation.x < -primaryMessageAction && translation.x > -secondaryMessageAction) {
                firstMessageView.backgroundColor = UIColor(red:0.996, green:0.824, blue:0.231, alpha: 1)
                laterIcon.alpha = 1
                listIcon.alpha = 0
                rightActionIcon.center = CGPoint(x: rightActionIconStartingCenter.x + (translation.x + primaryMessageAction), y: rightActionIconStartingCenter.y)
            } else if (translation.x <= -secondaryMessageAction) {
                firstMessageView.backgroundColor = UIColor(red:0.843, green:0.647, blue:0.471, alpha: 1)
                laterIcon.alpha = 0
                listIcon.alpha = 1
                rightActionIcon.center = CGPoint(x: rightActionIconStartingCenter.x + (translation.x + primaryMessageAction), y: rightActionIconStartingCenter.y)
            } else {
                firstMessageView.backgroundColor = UIColor(red:0.890, green:0.890, blue:0.890, alpha: 1)
            }
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            leftActionCompletePosition = CGPoint(x: messageStartingCenter.x + 320, y: messageStartingCenter.y)
            rightActionCompletePosition = CGPoint(x: messageStartingCenter.x - 320, y: messageStartingCenter.y)
            if (translation.x > primaryMessageAction && translation.x < secondaryMessageAction) {
                println("message action 1")
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
                    self.firstMessageImageView.center = self.leftActionCompletePosition
                    self.leftActionIcon.center = self.leftActionCompletePosition
                }, completion: { (Bool) -> Void in
                    self.hideFirstMessageRow()
                })
            } else if (translation.x >= secondaryMessageAction) {
                println("message action 2")
                UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
                    self.firstMessageImageView.center = self.leftActionCompletePosition
                    self.leftActionIcon.center = self.leftActionCompletePosition
                    }, completion: { (Bool) -> Void in
                        self.hideFirstMessageRow()
                })
            } else if (translation.x < -primaryMessageAction && translation.x > -secondaryMessageAction) {
                println("message action 3")
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
                    self.firstMessageImageView.center = self.rightActionCompletePosition
                    self.rightActionIcon.center = self.rightActionCompletePosition
                    }, completion: { (Bool) -> Void in
                        self.rescheduleImageView.hidden = false
                })
            } else if (translation.x <= -secondaryMessageAction) {
                println("message action 4")
                UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
                    self.firstMessageImageView.center = self.rightActionCompletePosition
                    self.rightActionIcon.center = self.rightActionCompletePosition
                    }, completion: { (Bool) -> Void in
                        self.listImageView.hidden = false
                })
            } else {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
                    self.firstMessageImageView.center = self.messageStartingCenter
                }, completion: { (Bool) -> Void in
                    //
                })
            }
            
        }
        
    }

    @IBAction func didTapRescheduleView(sender: UITapGestureRecognizer) {
        rescheduleImageView.hidden = true
        hideFirstMessageRow()
    }
    
    @IBAction func didTapListView(sender: UITapGestureRecognizer) {
        listImageView.hidden = true
        hideFirstMessageRow()
    }
    
    func hideFirstMessageRow() {
        println("hide first message")
        messageFeedImageViewStartingCenter = messageFeedImageView.center
        UIView.animateWithDuration(0.6, delay: 0.1, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.messageFeedImageView.center = CGPoint(x: self.messageFeedImageViewStartingCenter.x, y: self.messageFeedImageViewStartingCenter.y - self.firstMessageImageView.frame.height)
        }) { (Bool) -> Void in
            self.resetFirstMessageRow()
            self.firstMessageHidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            if (firstMessageHidden == true) {
                var alert: UIAlertView = UIAlertView()
                
                alert.delegate = self
                
                alert.title = "Undo Action"
                alert.addButtonWithTitle("Cancel")
                alert.addButtonWithTitle("Undo")
                alert.show()
            } else {
                
            }


        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 1:
            NSLog("Undo");
            self.unhideFirstMessageRow()
            break;
        case 0:
            NSLog("Cancel");
            break;
        default:
            NSLog("Default");
            break;
        }
    }
    
    func resetFirstMessageRow() {
        println("reset first message")
        firstMessageImageView.center = CGPoint(x: 160, y: 43)
        leftActionIcon.center = CGPoint(x: 30.5, y: 42.5)
        rightActionIcon.center = CGPoint(x: 289.5, y: 42.5)
        firstMessageView.backgroundColor = UIColor(red:0.890, green:0.890, blue:0.890, alpha: 1)
        archiveIcon.alpha = 0
        deleteIcon.alpha = 0
        laterIcon.alpha = 0
        listIcon.alpha = 0
    }
    
    func unhideFirstMessageRow() {
        messageFeedImageViewStartingCenter = messageFeedImageView.center
        UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.messageFeedImageView.center = CGPoint(x: self.messageFeedImageViewStartingCenter.x, y: self.messageFeedImageViewStartingCenter.y + self.firstMessageImageView.frame.height)
        })
        firstMessageHidden = false
    }
    
    func onEdgePan(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        if (sender.state == UIGestureRecognizerState.Began) {
            mailboxViewStartingCenter = mailboxView.center
        } else if (sender.state == UIGestureRecognizerState.Changed){
            mailboxView.center = CGPoint(x: mailboxViewStartingCenter.x + translation.x, y: mailboxViewStartingCenter.y)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (velocity.x > 0) {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mailboxView.center = CGPoint(x: self.mailboxViewStartingCenter.x + 280, y: self.mailboxViewStartingCenter.y)
                })
            } else if (velocity.x <= 0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                     self.mailboxView.center = CGPoint(x: self.mailboxViewStartingCenter.x, y: self.mailboxViewStartingCenter.y)
                })
            }
        }
    }

}

