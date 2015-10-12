import UIKit
import Alamofire

class ViewController: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate
{
    @IBOutlet weak var btnClickMe: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker!.delegate=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnImagePickerClicked(sender: AnyObject)
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
            
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
            
        }

        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    func openGallery()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        let imageFile = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = imageFile
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        // upload image
        let parameters = [
            "filename": "besttestfile.png",
            "encodedFile": convertImageToBase64(imageFile!)
        ]
        Alamofire.request(Method.POST, "http://account-home.netcredit.10.226.32.112.xip.io/attachments", parameters: parameters).responseJSON { response in
            debugPrint(response)
        }
        
        
//        Alamofire.upload(Method.POST,"http://account-home.netcredit.10.226.32.112.xip.io/attachments",
//            multipartFormData: { multipartFormData in
//                multipartFormData.appendBodyPart(
//                    data: imageFileJPG!,
//                    name: "testfile.jpg"
//                )
//            }, encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    NSLog("Encoding Success!")
//                    upload.responseJSON { _, _, JSON in
//                        NSLog("Success Upload")
//                        print(JSON)
//                    }
//                case .Failure(let encodingError):
//                    print(encodingError)
//                    NSLog("Encoding Failure")
//                }
//            }
//            )
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func convertImageToBase64(image: UIImage) -> String {
        let imageDataJPG = UIImagePNGRepresentation(image)
        let base64String = imageDataJPG!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        return base64String
    }
    
    
}

