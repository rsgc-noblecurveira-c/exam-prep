//: Playground - noun: a place where people can play

import UIKit

extension UIView
{
    func centerHorizontallyInSuperview()
    {
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self,
                                                       attribute: NSLayoutAttribute.CenterX,
                                                       relatedBy: NSLayoutRelation.Equal,
                                                       toItem: self.superview,
                                                       attribute: NSLayoutAttribute.CenterX,
                                                       multiplier:1,
                                                       constant: 0)
        
        // Add this constraint to the superview
        self.superview?.addConstraint(c)
    }
}
class ViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    let inputGiven = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    let descriptionTitle = UILabel()
    //    let countryPicker = UIPickerViewDelegate()
    // make variables to store the info
    var jsonCurrency = ""
    var jsonRate = ""
    let frontURL = "https://api.coindesk.com/v1/bpi/currentprice/"
    var pickerData: [String] = ["pee"]
    
    
    //    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    //    {
    //        return 1
    //    }
    //    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    //    {
    //        return pickerData.count
    //    }
    //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    //    {
    //        return pickerData[row]
    //    }
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // Print the provided data
        print("")
        print("====== the data provided to parseMyJSON is as follows ======")
        print(theData)
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // https://api.coindesk.com/v1/bpi/currentprice/<CODE>.json
            // Try to parse the whole thing as an AnyObject
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments)
            
            // Print retrieved JSON
            print("")
            print("====== the retrieved JSON is as follows ======")
            print(json)
            
            // Now we can parse this...
            print("")
            print("Now, add your parsing code here...")
            
            // cast AnyObject into a dictionary with a key that is a String and value of AnyObject
            if let data = json as? [String : AnyObject]
            {
                // if this worked we have a dictionary
                print("The value for the bpi key is")
                print(data["bpi"])
                //now we must go deeper to find the actual value of bitcoins
                if let exchangeRate = data["bpi"] as? [String : AnyObject]
                {
                    //if it worked we can now go into each currency and find the value
                    print("Canadian dollar amount")
                    print(exchangeRate[inputGiven.text!])
                    // keep going deeper
                    if let individualRate = exchangeRate[inputGiven.text!] as? [String : AnyObject]
                    {
                        // if this worked, we can use this to find the dollar amount
                        // get the data into variables
                        print("====== the variables ======")
                        if let currency = individualRate["description"]
                        {
                            print("\(currency)")
                            jsonCurrency = currency as! String
                        } else {
                            print("not a vaild variable")
                        }
                        
                        if let rate = individualRate["rate"]
                        {
                            print("$\(rate)")
                            jsonRate = rate as! String
                        } else {
                            print("not a vaild variable")
                        }
                        
                    } else {
                        print("could not find the currency")
                    }
                } else {
                    print("could not convert bpi data into a dictionary")
                }
            } else {
                print("could not convert to dictionary of String:AnyObject")
            }
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue())
            {
                self.jsonResult.text = "The currency is the \(self.jsonCurrency)\nand one BitCoin is \(self.jsonRate) \(self.jsonCurrency)'s"
            }
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerData[row]
    }
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON()
    {
        
        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void =
            {
                
                (data, response, error) in
                
                // This is the code run when the network request completes
                // When the request completes:
                //
                // data - contains the data from the request
                // response - contains the HTTP response code(s)
                // error - contains any error messages, if applicable
                
                // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
                if let r = response as? NSHTTPURLResponse
                {
                    
                    // If the request was successful, parse the given data
                    if r.statusCode == 200
                    {
                        
                        // Show debug information (if a request was completed successfully)
                        print("")
                        print("====== data from the request follows ======")
                        print(data)
                        print("")
                        print("====== response codes from the request follows ======")
                        print(response)
                        print("")
                        print("====== errors from the request follows ======")
                        print(error)
                        
                        if let d = data {
                            
                            // Parse the retrieved data
                            self.parseMyJSON(d)
                            
                        }
                        
                    }
                    
                }
                
        }
        
        func createURL() -> String
        {
            if inputGiven.text! == ""
            {
                self.jsonResult.text = "Please enter a vaild currency code"
                return ""
            } else if let url: String = frontURL + inputGiven.text! + ".json"
            {
                return url
            }
        }
        
        // Define a URL to retrieve a JSON file from
        if let address : String = createURL()
        {
            if let url = NSURL(string: address) {
                
                // We have an valid URL to work with
                print(url)
                
                // Now we create a URL request object
                let urlRequest = NSURLRequest(URL: url)
                
                // Now we need to create an NSURLSession object to send the request to the server
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                
                // Now we create the data task and specify the completion handler
                let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
                
                // Finally, we tell the task to start (despite the fact that the method is named "resume")
                task.resume()
                
            } else {
                self.jsonResult.text = "Please enter a vaild currency code"
                
            }
        } else {
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        super.viewDidLoad()
        
        // Make the view's background be yellow
        view.backgroundColor = UIColor.yellowColor()
        
        /*
         * Further define label that will show JSON data
         */
        
        // Set the label text and appearance
        jsonResult.text = "..."
        jsonResult.font = UIFont.systemFontOfSize(12)
        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        
        // e.g.: multiple lines will show up
        jsonResult.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonResult)
        
        /*
         * Define the label
         */
        
        // Set font and text
        descriptionTitle.text = "Enter currency code here."
        descriptionTitle.font = UIFont.systemFontOfSize(18)
        descriptionTitle.numberOfLines = 0
        
        // Set alignment
        descriptionTitle.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        descriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to the superview
        view.addSubview(descriptionTitle)
        
        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("How much does a bitcoin cost?", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the button color
        getData.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        // Add the button into the super view
        view.addSubview(getData)
        
        /*
         * Add a textfield
         */
        inputGiven.borderStyle = UITextBorderStyle.RoundedRect
        inputGiven.font = UIFont.systemFontOfSize(15)
        inputGiven.placeholder = "ex: USD"
        inputGiven.backgroundColor = UIColor.whiteColor()
        inputGiven.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        inputGiven.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this field
        inputGiven.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the amount text field into the superview
        view.addSubview(inputGiven)
        
        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "title": jsonResult,
            "getData": getData,
            "input": inputGiven,
            "textLabel": descriptionTitle]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-200-[textLabel]-25-[input]-25-[getData]-25-[title]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // center all of the views horizontally
        jsonResult.centerHorizontallyInSuperview()
        getData.centerHorizontallyInSuperview()
        inputGiven.centerHorizontallyInSuperview()
        descriptionTitle.centerHorizontallyInSuperview()
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
    }
    
}