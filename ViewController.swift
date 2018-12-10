
/*
John DeSalvo
CSC-415: Software Engineering
Student Risk Analysis
Language: Swift
Framework: Cocoa
Inegrated Development Environment: X-Code
Platform: iOS
This is an applciation where a user can enter information about a potential student loan as well as information about a potential degree. Based on that loan information and the average salary associated with that degree, it determines the annual rate of return (assuming the loan is the initial investment and the return is the salary), the risk level for the loan (based on how much of the user's income will be loan payments; it was determined that all necessary expenses for the user will take up about 74% of their income based on data taken from here: http://www.creditloan.com/blog/how-the-average-us-consumer-spends-their-paycheck/ ; this also assumes the user would not be living with his or her parents after college), and a comparison to a situation in which the student would begin working after high school.
*/

/*
This is the View Controller class for this application. In the MVC sowftware architecture this is the controller. There are
interface builder variables (IBOutlets) and methods (IBActions) which are connected to the main storyboard (which is basically 
a manifestation of the build file) through the IDE. Data associated with these IBOultets are in the model (the Student, Loan, and Degree classes) and are updated and manipulated (correctly) through the View Controller.
*/

/*The UIKit library contains all the objects and associated members for designing and building a user interface in the
Cocoa framework*/
import UIKit

/*
The class named UIViewController inherets data from the UIViewController class in the UIKit library. It also implements the UITextFieldDelegate, UIPickerViewDataSource, and UIPickerViewDelegate protocols (also part of the UIKit Library). To clear up confusion, ViewController is not a subclass of multiple classes. The Swift language does not support mulitple inheritance. Protocols help a class implement certain standardized methods.
*/
class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    /*
    The following 10 instance variables are all components of the user interface. Not that not all UILabels in Main.storyboard have associated outlets. There are some labels that display static text and do not have or need outlet variables and other labels (that are initially blank) and change based on the state of the system.
    */
    
    /*Textfield for the principal. Does not allow input for fractions of a dollar since it is not common or practial for a loan recipient to borrow such an exact amount*/
    @IBOutlet weak var principalTextField: UITextField!
    /*Textfield for the whole number component of the interest for the loan. The reason for separating the interest input into two separate textfields will be discussed in other parts of this program.
    */
    @IBOutlet weak var interestTextField: UITextField!
    /* This is textfield fot the fractional component of the interest. */
    @IBOutlet weak var interestDecTextField: UITextField!
    /*The textfield for the number of years or the payment period for the loan.*/
    @IBOutlet weak var yearsTextField: UITextField!
    /*This is the button to display all output results based on the input data and the algorithm. The button is always enabled since there are default values for input parameters. Refer to the loan class for more explanation of how this is an error-handling technique.
    */
    @IBOutlet weak var button: UIButton!
    /*This is the label that displays the calculated annual rate of return. The label is initially blank and changes based on the state of the system.*/
    @IBOutlet weak var arrLabel: UILabel!
    /*This is the label that displays the user's computed risk level. The label is initially blank and changes based on the state of the system.*/
    @IBOutlet weak var riskLabel: UILabel!
    /*This is the label that displays a comparison to a situation in which the user does not attend college and starts working after high school. The label is initially blank and changes based on the state of the system.*/
    @IBOutlet weak var compareLabel: UILabel!
    /* This is the other part of the comparison label. It is initially blank and changes only once after the button is pressed because it is valid for all follwing states. This label was really only necessary because of the screen size.
    */
    @IBOutlet weak var otherCompareLabel: UILabel!
    /* This is the picker component of the User Interface. Its displays a list of possible majors that the user can scroll through. The names of these degrees are displayed in the table but the average salaries for each degree are not. In fact, the average salaries are never shown to the user anywhere in the program. This is an example of information hiding that sets the level of abstraction.
    */
    @IBOutlet weak var picker: UIPickerView!
    
    /* This is an instance of a Student object that manages all data in the model. The View Controller manages data for the student object which data for the Degree and Loan classes. Refer to the student class for further explanation about its purposes.
    */
    var student = Student()
    /*Though the student has its own degree variable, the View Controller has its own degree object. However, this one is a constant. This is so the View Controller populates the picker directly from degree data rather than through the student. This is important because the values in the picker (both the Strings and Doubles) do not change in the view. In the model (in the student class), the only value that is updated in the degree object is the variable that holds the average salary. This also provides further encapsulation for classes in this program.
    */
    let degree = Degree()
    
    
    /*This is the viewDidLoad method which is necessary for any View Controller in an iOS application. It sets the scene for the view when the application executes. It is the first method in the View Controller that gets called. In the Cocoa framework, delegation is the process by which an object interacts with another object. The textfields and the picker each delegate to this View Controller object because these are the view components that actually manage user input. All textfields have the keyboard set to NumberPad so only numeric digits can be input. This is a simple and efficient way to handle user errors and it is why there are two separate fields for interest. Before discovering different keyboard type settings I implemented a method from a String extension called isNumeric(). Using this, I designed this class so that the button would only be activated when all textfields contain legitimate numeric values. This unfortunately overcomplicates the flow of control of the program and leaves it more prone to bugs, known or unknown. There is another keyboard type that accepts numbers and punctuation so decimal points and mathematical operators could be used. However, this would also require an input validation technnique such as isNumeric() so having two separate fields for interest and only allowing NumberPad for all fields was the simplest most efficient way to deal with this that does not restict any features of the application. Visually larger fields were aligned to the right for aesthetic pruposes and the picker's data source was assigned to this View Controller object.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        principalTextField.delegate = self
        principalTextField.keyboardType = UIKeyboardType.numberPad
        principalTextField.text = student.loan.principal
        principalTextField.textAlignment = .right
        interestTextField.delegate = self
        interestTextField.keyboardType = UIKeyboardType.numberPad
        interestTextField.text = student.loan.interest
        interestDecTextField.delegate = self
        interestDecTextField.keyboardType = UIKeyboardType.numberPad
        interestDecTextField.text = student.loan.interestDec
        yearsTextField.delegate = self
        yearsTextField.keyboardType = UIKeyboardType.numberPad
        yearsTextField.text = student.loan.years
        yearsTextField.textAlignment = .right
        picker.dataSource = self
        picker.delegate = self
    }
    /*This is the button method for the button attribute of this class. It is essentially the "heart" of the view controller because it is the main control for the state of the system. When the button is pressed, not only does it update the model by setting all data associated with text fields equal to the text in the fields when they are changed by the user, but it also calls the student object's methods to display output. During earlier development, instead of using the button to display output, I had labels change dynamically while the user input changed. This is not only considered bad UI design, but some calculations were erroneous. Implementing a button to change the state of the system is an efficient and user friendly way to display or change output.
    */
   @IBAction func button(_ sender: AnyObject) {
        student.loan.principal = principalTextField.text!
        student.loan.interest = interestTextField.text!
        student.loan.interestDec = interestDecTextField.text!
        student.loan.years = yearsTextField.text!
    
        arrLabel.text = student.returnRate()
        riskLabel.text = student.riskLevel()
        compareLabel.text = student.displayComparison()
        otherCompareLabel.text = "going to college."
    }
    /* These are some standardized methods for the picker in this class. numberOfComponenetsInPickerView sets the number of columns to 1 since it is just a list.
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    //This sets the number of rows in the picker equal to the number of possible degrees.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.degree.nameList.count
        
    }
    //This sets the content of the list to the names of degrees.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.degree.nameList[row]
        
    }
    /*This updates the model by setting the avgSalary variable used for calculation equal to the number associated with the current name in the picker.
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        student.degree.avgSalary = self.degree.numList[row]
    }
    /* These are some standardized textfield methods that apply to all field attributes in this class.
    */
    //This changes the text of textfield (changes the data in the UITextField object) when the user enters text.
    func textField(_ paramTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        return true
    }
    //This changes the textfield from being the first responder to input when the user is done editing text.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.resignFirstResponder()
    }
    //This lets the textfield update the data in the model via the View Controller.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
   
}

