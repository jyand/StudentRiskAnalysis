//The foundation library provides some new features that are not available in the Objective-C API.
import Foundation

/*This is the Degree class which stores data about both the title and average salary of a user's selected degree. */
class Degree{
    
    /*This is the dictionary that holds degree titles with their associated average salaries. Because this array is hardcoded, only majors offered at TCNJ were used. The data is taken from here: http://www.payscale.com/college-salary-report-2014/majors-that-pay-you-back
    */
    let degreeData = ["Accounting and Finance":51400.0, "Art: History":39100.0, "Biology":40700.0, "Biomedical Engineering":59600.0, "Chemistry":44200.0, "Civil Engineering":55100.0, "Communications":41000.0, "Computer Engineering":67300.0, "Computer Science":61600.0, "Criminology":37900.0, "Economics":51000.0, "Electrical Engineering":69500.0, "Elementary Education":33600.0, "English":38500.0, "Health and Exercise Science":38300.0, "History":40500.0, "Mathematics":50300.0, "Mechanical Engineering":62100.0, "Music":37500.0, "Nursing":56900.0, "Philosophy":40700.0, "Physics":57200.0, "Political Science":42800.0, "Psychology":38600.0, "Sociology":37300.0, "Spanish":37600.0]
    
    /* The following computed properties are arrays of the degree names and average salaries, respectively, derived from the dictionary. This is to make manipulation  of the picker in the View Controller simpler.
    */
    var nameList:[String]{
        get{
            return Array(degreeData.keys)
        }
    }
    var numList:[Double]{
        get{
            return Array(degreeData.values)
        }
    }
    
    /*This is the variable for the average salary initialized to the first name in the picker. It is updated once the user selects a different degree name.
    */
    var avgSalary = 69500.0
    
    /*This is the initializer method for the degree object. It is necessary for a degree object to be instantiated. However, it takes no parameters and has no body.*/
    init(){
    }
}