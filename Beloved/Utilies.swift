//
//  Utilies.swift
//  Beloved
//
//  Created by Anas Belkhadir on 18/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit
import SystemConfiguration




extension UIColor {
    
    static func deepPurple() -> UIColor {
        return UIColor(red: 103, green: 58, blue: 183, alpha: 1.0)
    }
    static func extraDeepPurple() -> UIColor {
        return UIColor(red: 49.4, green: 34.1, blue: 76.1, alpha: 1.0)
    }
    static func extraGreen() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    }
}

extension UIImage {
    
    
     var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}




extension UIViewController {
    
    
    enum TypeAlert {
        case connectivity
        case server
        case unCompleteField
    }
    
    
    func showAlert(typeAlert: TypeAlert){
        var title = ""
        var message = ""
        let buttonTitle = "OK"
        switch typeAlert {
        case .connectivity:
            title = "Error connection"
            message = "Unable to connect, connection problem"
        case .server :
            title = "Error occu"
            message = "Try later"
        case .unCompleteField:
            title = "Uncomplete Field"
            message = "Please make sure to complete all field"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default, handler: {action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func imageEncodedBase64(imageProfile: UIImage?) -> String? {
        if let imageProfile = imageProfile {
            let img:NSData = UIImagePNGRepresentation(imageProfile)!
            let base64String = img.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            return base64String
        }
        return nil
    }
    
    
    func imageDecodeBase64(imageString: String?) -> UIImage? {
        if let imageString = imageString {
            let imageData = NSData(base64EncodedString: imageString,
                options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let decodedImage = UIImage(data:imageData!)
            return decodedImage
        }
        return nil
    }
    
    
    func configureButton(sender: UIButton) {
        

        sender.layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).CGColor
        sender.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        sender.layer.shadowOpacity = 1.0
        sender.layer.shadowRadius = 6.0
        
    }

    
    
    
    
    
}