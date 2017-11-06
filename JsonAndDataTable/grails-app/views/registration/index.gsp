<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Student | Home</title>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico" />
</head>
<body>
<div class="content">
    <div class="col-md-8 col-md-offset-2">
        <div class="alert alert-block alert-success fade in">
            <button type="button" class="close" data-dismiss="alert"></button>
            <p style="color: green"; class="text-center" id="successMsg"></p>
            <p style="color: red"; class="text-center" id="errorMsg"></p>
        </div>
    </div>

    <div class="row" id="list-table">
        <div class="col-md-12" style="margin-top: 50px;">
            <div class="pull-right">
                <button class="btn btn-primary"  id="addNewStd">Add new student</button>
            </div>
        </div>

        <div class="col-md-8 col-md-offset-2">
            <span>Show and Hide Column: </span>
            <a class="showHideColumn btn btn-success" data-columnIndex="0">ID</a>
            <a class="showHideColumn btn btn-success" data-columnIndex="1">Name</a>
            <a class="showHideColumn btn btn-success" data-columnIndex="2">Roll</a>
            <a class="showHideColumn btn btn-success" data-columnIndex="3">Birthday</a>
            <a class="showHideColumn btn btn-success" data-columnIndex="4">Department</a>

        </div>
        <div class="col-md-8 col-md-offset-2">
                <section class="panel">
                    <header class="panel-heading">
                       Student List
                    </header>
                    <div class="panel-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover table-bordered" id="listTable">
                                <thead>
                                <tr>
                                    <th>S-NO</th>
                                    <th>Name</th>
                                    <th>Roll</th>
                                    <th>Birthday</th>
                                    <th>Department</th>
                                </tr>
                                </thead>

                            </table>
                        </div>
                    </div>
                </section>
        </div>
        </div>
    </div>


</div>

<!-- Modal -->
<div class="modal fade" id="regFromModal" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Modal title</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12">
                            <form class="form-horizontal simple-horizontal-form" id="regForm">
                                <div class="form-group clearfix">
                                    <div class="col-sm-4">
                                        <label for="name" class="control-label">Name</label>
                                    </div>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="name" name="name" placeholder="Your name">
                                    </div>
                                </div>
                                <div class="form-group">
                                   <div class="col-md-4">
                                       <label for="roll" class="control-label">Roll No</label>
                                   </div>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="roll" name="roll" placeholder="Roll no">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-md-4">
                                        <label for="birthday" class="control-label">Birth day</label>
                                    </div>
                                    <div class="col-sm-8">
                                        <input type="date" class="form-control" id="birthday" name="birthday">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-md-4">
                                        <label for="department" class="control-label">Department</label>
                                    </div>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="department" name="department">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-offset-4 col-sm-10">
                                        <button type="submit" class="btn btn-success">Submit</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-info" data-dismiss="modal">Cancle</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
%{--modal end--}%

<script>
    jQuery(function ($) {

        jQuery.ajax({
            type: 'POST',
            dataType:'JSON',
            url: "${createLink(controller: 'registration', action: 'test')}",
            success: function(data){
             var dataTableInstance =  $('#listTable').DataTable({
                    "data": data,
                    "columns": [
                        { 'data': 'id',
                           'render':function(id){
                               return "# "+ id;
                           },
                            'searchable': false
                        },
                        { 'data': 'name' },
                        { 'data': 'roll',
                            'searchable': false,
                            'sortable':false
                        },
                        { 'data': 'department',
                            'searchable': false,
                            'sortable':false
                        },
                        { 'data': 'birthday',
                            'searchable': false,
                            'sortable':false,
                            'render': function(birthday){
                                var mydate = new Date(birthday);
                                return mydate.getDate()+" / "+(mydate.getMonth()+1)+" / "+mydate.getFullYear();

                            }

                        },
                    ]
                });

                console.log(data);
                $('#list-table').on('click', 'a.showHideColumn', function () {
                   var selectColumn = dataTableInstance.column($(this).attr('data-columnIndex'));
                    selectColumn.visible(!selectColumn.visible());
                });
            }
        });

        $("#addNewStd").click(function(e){
            $('#regFromModal').trigger("reset");
            $('#regFromModal').modal('show');
            e.preventDefault();
        });

        $('#regForm').submit(function(){
            jQuery.ajax({
                type: 'POST',
                dataType:'JSON',
                data: $('#regForm').serialize(),
                url: "${createLink(controller: 'registration', action: 'save')}",
                success: function(data){
                    if(data.isError == false){
                        $('#successMsg').text(data.message);
                        $('#regFromModal').modal('hide');
                    }else{
                        $('#errorMsg').text(data.message);
                        $('#regFromModal').modal('hide');
                    }
                }
            });
          return false; // for prevint actual submit
        });

        $('#listTable').on('click', 'a.delete-reference', function (e) {
            var selectRow = $(this).parents('tr');
            var confirmDel = confirm("Are you sure delete Exam?");
            if (confirmDel == true) {
                var control = this;
                var referenceId = $(control).attr('referenceId');
                jQuery.ajax({
                    type: 'POST',
                    dataType: 'JSON',
                    url: "${g.createLink(controller: 'registration',action: 'delete')}?id=" + referenceId,
                    success: function (data) {
                        if (data.isError == false) {
                            $('#successMsg').text(data.message);
                             selectRow.remove();
                        } else {
                            $('#errorMsg').text(data.message);
                        }
                    }
                });

            }
            e.preventDefault();
        });


    });
</script>
</body>
</html>





