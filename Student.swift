

//The foundation library provides some new features that are not available in the Objective-C API.
import Foundation

//This is an extension for doubles that provides an output formatting method. It is used in the returnRate method in this class.
extension Double {
    func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

/* This is the Student class which holds data based on the user's selected degree and loan information. It acts as a "contoller" within the model because the View Controller interacts with this class which interacts with the other model classes. It is a layer between the actual controller and the model to provide further encapsulation of data in the model and a higher level of abstraction.
*/
class Student{
    
    //These are the Loan and Degree instance variables for this class to manage associated data.
    var loan = Loan()
    var degree = Degree()
    
    //This is an NSNumberFormatter object used to format output in the displayComparison method in this class.
    var formatter = NumberFormatter()
    
    //This is a computed property for the annual rate of return
    var annualReturnRate:Double{
        get{
            return ((degree.avgSalary)/(4*loan.futureValue))*100
        }
    }
    
    /*This is the method that returns a formatted String of the annual rate of return or displays "nonexistent" if th ARR is zero or lower.
    */
    func returnRate()->String{
        if self.annualReturnRate>0{
            return self.annualReturnRate.format("0.3") + "%"
        }
        else{
            return "nonexistent"
        }
    }
    /*This method returns a level of risk based on what percentage of the user's income will go towards paying loans.
    */
    func riskLevel()->String{
        let level:Double = self.loan.monthlyPayments/(Double(degree.avgSalary)/12)
        if(level<0.08){
            return"Low Risk"
        }
        else if(level>0.08 && level<0.17){
            return"Moderate Risk"
        }
        else if(level>0.17&&level<0.26){
            return"High Risk"
        }
        else if(level>0.26){
            return"Unfeasible"
        }
        else{
            return"Impossible"
        }
        
    }
    
    /* This method displays whether or not the user would have more income if the user started working after high school making slightly more than minimum wage and working 40 hours per week, and by exactly how much either way (per year).
    */
    func displayComparison()->String{
        var salDiff:Double = 2500-(Double(degree.avgSalary)/12-loan.monthlyPayments*4)
        formatter.numberStyle = .currency
        if(salDiff<0){
            return"You would be " + formatter.string(from: -salDiff)! + " safer by"
        }
        else{
            return"You would be " + formatter.string(from: NSNumber(salDiff))! + " safer by not"
        }
    }
    
    /*This is the initializer method for the degree object. It is necessary for a degree object to be instantiated. However, it takes no parameters and has no body.*/
    init(){
        
    }
    
}
