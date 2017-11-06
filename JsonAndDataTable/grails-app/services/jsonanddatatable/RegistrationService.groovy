package jsonanddatatable

import com.students.command.RegistrationCommand
import grails.converters.JSON
import grails.transaction.Transactional
import grails.web.servlet.mvc.GrailsParameterMap
import grailslab.CommonUtils

@Transactional
class RegistrationService {


    static final String[] sortColumns = ['id','name','roll']

    LinkedHashMap regPaginateList(GrailsParameterMap params){


        int iDisplayStart = params.iDisplayStart ? params.getInt('iDisplayStart') : CommonUtils.DEFAULT_PAGINATION_START
        int iDisplayLength = params.iDisplayLength ? params.getInt('iDisplayLength') : CommonUtils.DEFAULT_PAGINATION_LENGTH
        String sSearch = params.sSearch ? params.sSearch : null
        String sSortDir = params.sSortDir_0 ? params.sSortDir_0 : CommonUtils.SORT_ORDER_ASC
        int iSortingCol = params.iSortCol_0 ? params.getInt('iSortCol_0') : CommonUtils.DEFAULT_PAGINATION_SORT_IDX

        if (sSearch) {
            sSearch = CommonUtils.PERCENTAGE_SIGN + sSearch + CommonUtils.PERCENTAGE_SIGN
        }

        String sortColumn = CommonUtils.getSortColumn(sortColumns,iSortingCol)
        List dataReturns = new ArrayList()

        def c = Registration.createCriteria()
        def results = c.list(max: iDisplayLength, offset: iDisplayStart) {

            if (sSearch) {
                or {
                    ilike('name', sSearch)
                }
            }
            order(sortColumn, sSortDir)
        }
        int totalCount = results.totalCount
        int serial = iDisplayStart;
        if (totalCount > 0) {
            if (sSortDir.equals(CommonUtils.SORT_ORDER_DESC)) {
                serial = (totalCount + 1) - iDisplayStart
            }

            for (Registration registration in results) {
                if (sSortDir.equals(CommonUtils.SORT_ORDER_ASC)) {
                    serial++
                } else {
                    serial--
                }
                dataReturns.add([DT_RowId: registration.id, 0:serial, 1: registration.name, 2: registration.roll, 3:registration.birthday, 4:registration.department , 5:''])
            }
        }
        println("Ajax  fired......!!");
        return [totalCount:totalCount,results:dataReturns]
    }


    def checkRegistration(String roll) {
        LinkedHashMap result = new LinkedHashMap()

        def isExists = Registration.findByRoll(roll)
        if(isExists){
            result.put(CommonUtils.MESSAGE, "This roll number already exists, check in Service.")
            result.put(CommonUtils.IS_ERROR, true)
        }
        result
    }

    def saveData(RegistrationCommand command){

        LinkedHashMap result = new LinkedHashMap()
        if(command.id){
            Registration registration = Registration.get(command.id)
            registration.name = command.name
            registration.roll = command.roll
            registration.department = command.department
            registration.birthday = command.birthday
            if(registration.save(flush: true)){
                result.put(CommonUtils.MESSAGE, "Successfully Update your date this msg from servicr..!!")
                result.put(CommonUtils.IS_ERROR, false)
                return result
            }

        }
        Registration registration = new Registration(name: command.name, roll: command.roll, birthday: command.birthday, department: command.department)
        if(registration.save(flush: true)){
            result.put(CommonUtils.MESSAGE, "Successfully save your date this msg from servicr..!!")
            result.put(CommonUtils.IS_ERROR, false)
        }
        result
    }
    def delete(Long id){
        LinkedHashMap resultMap = new LinkedHashMap()
        Registration registration = Registration.get(id)
        if(!registration){
            resultMap.put(CommonUtils.MESSAGE, "Some thing wrong, contact with admin.")
            resultMap.put(CommonUtils.IS_ERROR, true)
            return resultMap
        }
        registration.delete()
        resultMap.put(CommonUtils.MESSAGE, "Successfully deleted completed.")
        resultMap.put(CommonUtils.IS_ERROR, false)
        return resultMap
    }


}
