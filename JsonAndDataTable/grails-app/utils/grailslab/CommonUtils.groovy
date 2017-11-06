package grailslab


/**
 * Created by aminul on 1/25/2015.
 */
class CommonUtils {

    public static final String SORT_ORDER_ASC = 'asc'
    public static final String SORT_ORDER_DESC = 'desc'
    public static final int DEFAULT_PAGINATION_START = 0
    public static final int DEFAULT_PAGINATION_LENGTH = 25
    public static final int MAX_PAGINATION_LENGTH = 100
    public static final String DEFAULT_PAGINATION_SORT_ORDER = 'desc'
    public static final String DEFAULT_PAGINATION_SORT_COLUMN = 'id'
    public static final int DEFAULT_PAGINATION_SORT_IDX = 0
    public static final String PERCENTAGE_SIGN = '%'

    public static final String IS_ERROR ="isError"
    public static final String MESSAGE ="message"
    public static final String OBJ ="obj"


    public static String getSortColumn(String[] sortColumns, int idx) {
        if (!sortColumns || sortColumns.length < 1)
            return DEFAULT_PAGINATION_SORT_COLUMN
        int columnCounts = sortColumns.length
        if (idx > 0 && idx < columnCounts) {
            return sortColumns[idx]
        }
        return sortColumns[DEFAULT_PAGINATION_SORT_IDX]
    }




}