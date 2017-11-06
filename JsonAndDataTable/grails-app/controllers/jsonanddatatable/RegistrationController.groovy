package jsonanddatatable

import com.students.command.RegistrationCommand
import grails.converters.JSON
import grailslab.CommonUtils

class RegistrationController {
    def registrationService

    def index() {}

    def serversid(){ }

    def save(RegistrationCommand command) {
        if (!request.method.equals('POST')) {
            redirect(action: 'index')
            return
        }
        LinkedHashMap result = new LinkedHashMap()
        String outPut
        if (command.hasErrors()) {
            result.put(CommonUtils.MESSAGE, "Require field not be empty")
            result.put(CommonUtils.IS_ERROR, true)
            outPut = result as JSON
            render outPut
            return
        }
        if(!command.id){
            result = registrationService.checkRegistration(command.roll)
            if(result.isError == true){
                outPut =  result as JSON
                render outPut
                return
            }
        }
        result = registrationService.saveData(command)
        outPut = result as JSON
        render outPut
    }
    def test() {
        println(params)
        List gridData = new ArrayList()
        String result
        gridData = Registration.list()

        if (!gridData) {
            result = gridData as JSON
            render result
            return
        }
        result = gridData as JSON
        render result
    }
    def list(){
        LinkedHashMap gridData = new LinkedHashMap()
        String result
        gridData = registrationService.regPaginateList(params)
        if(!gridData || gridData.totalCount== 0){
            gridData = [iTotalRecords: 0, iTotalDisplayRecords: 0, aaData: []]
            result = gridData as JSON
            render result
            return
        }
        int totalCount = gridData.totalCount
        gridData = [iTotalRecords: totalCount, iTotalDisplayRecords: totalCount, aaData: gridData.results]
        result = gridData as JSON
        render result
    }

    def edit(Long id) {
        if (!request.method.equals('POST')) {
            redirect(action: 'index')
            return
        }
        LinkedHashMap result = new LinkedHashMap()
        String outPut
        Registration registration = Registration.read(id)
        if (!registration) {
            result.put(CommonUtils.MESSAGE, "User not found")
            result.put(CommonUtils.IS_ERROR, true)
            outPut = result as JSON
            render outPut
            return
        }

        result.put(CommonUtils.OBJ, registration)
        result.put(CommonUtils.IS_ERROR, false)
        outPut = result as JSON
        render outPut
    }

    def delete(Long id){
        LinkedHashMap result = new LinkedHashMap()
        String outPut
        result = registrationService.delete(id)
        outPut = result as JSON
        render outPut
    }




}