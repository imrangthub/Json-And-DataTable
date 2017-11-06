package com.students.command

import grails.validation.Validateable

/**
 * Created by USER on 19-Apr-17.
 */
class RegistrationCommand implements Validateable {
    Long id
    String name
    String roll
    String birthday
    String department

    static constraints = {
        id blank: true, nullable: true
        name blank: false, nullable: false
        roll blank: false, nullable: false
        birthday blank: false, nullable: false
        department blank: false, nullable: false
    }
}
