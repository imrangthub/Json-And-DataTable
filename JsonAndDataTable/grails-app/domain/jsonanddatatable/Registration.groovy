package jsonanddatatable

class Registration {

    String roll
    String name
    String birthday
    String department

    static constraints = {
        roll unique:true
    }
}
