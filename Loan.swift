//The foundation library provides some new features that are not available in the Objective-C API.
import Foundation

/*This is the loan stucture that holds data based on parameters of the user's loan. It would function the same if it were a class but it contains no methods and only stores data as part of the model.*/
struct Loan{
    
    /* The following 4 variables are the Strings associated with repspective text fields. These are stored as strings initially for purposes of text field manipulation and converted to doubles for pruposes of calculation. There are initial values stored to avoid errors caused by the user pressing the button when there is no data.
    */
    var principal = "14000"
    var interest = "3"
    var interestDec = "4"
    var years = "15"
    
    /* The following 3 computed properties are Double conversions of the String properties associated with the textfields' text. This is where the interest resolves itself as a single value. The 2 subsequent computed properties are the future value of the loan the monthly payments, respectively.
    */
    var princ:Double{
        get{
            return (principal as NSString).doubleValue
        }
    }
    var intr:Double{
        get{
            return (interest as NSString).doubleValue + ((interestDec as NSString).doubleValue)/100
        }
    }
    var yrs:Double{
        get{
            return (years as NSString).doubleValue
        }
    }
    
    var futureValue:Double{
        get{
            return princ*pow((1+intr/100), yrs)
        }
    }
    
    var monthlyPayments: Double{
        get{
            return futureValue/12
        }
    }
}