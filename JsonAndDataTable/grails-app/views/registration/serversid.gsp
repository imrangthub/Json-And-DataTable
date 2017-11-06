<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Student | Home</title>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico" />
</head>
<body>
<div class="content">
    <div class="row" id="list-table">
        <div class="col-md-12" style="margin-top: 50px;">
            <div class="pull-right">
                <button class="btn btn-primary"  id="addNewStd">Add new student</button>
            </div>
        </div>
        <div class="col-md-8 col-md-offset-2">
            <section class="panel">
                <header class="panel-heading">
                    Student List
                </header>
                <div class="panel-body" id="panelBody">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover table-bordered" id="listTable">
                            <thead>
                            <tr>
                                <th>S-NO</th>
                                <th>Name</th>
                                <th>Roll</th>
                                <th>Birthday</th>
                                <th>Department</th>
                                <th>Action</th>
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
                <h4 class="modal-title" id="modalTitle"></h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-12">
                        <form class="form-horizontal simple-horizontal-form" id="regForm">
                            <g:hiddenField name="id" id="id"/>
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
        var regTable = $('#listTable').dataTable({
            "bAutoWidth": true,
            "bServerSide": true,
            "iDisplayLength": 10,
            "aaSorting": [0,'asc'],
            "sAjaxSource": "${g.createLink(controller: 'registration',action: 'list')}",
            "fnRowCallback": function (nRow, aData, iDisplayIndex) {
                if (aData.DT_RowId == undefined) {
                    return true;
                }
                $('td:eq(5)', nRow).html(getActionButtons(nRow, aData));
                return nRow;

            },

            "aoColumns": [
                null,
                null,
                null,
                { "bSortable": false },
                null,
                { "bSortable": false }
            ]
        });

        $("#addNewStd").click(function(e){
            $('#modalTitle').text("Add student");
            clearForm("#regForm");
            $('#regFromModal').modal('show');
            e.preventDefault();
        });

        $('#regForm').submit(function(){
            showLoading("#panelBody");
            jQuery.ajax({
                type: 'POST',
                dataType:'JSON',
                data: $('#regForm').serialize(),
                url: "${createLink(controller: 'registration', action: 'save')}",
                success: function(data){
                    if(data.isError == false){
                        showSuccessMsg(data.message);
                        $('#listTable').DataTable().ajax.reload();
                        $('#regFromModal').modal('hide');
                    }else{
                         showErrorMsg(data.message);
                        $('#regFromModal').modal('hide');
                    }
                    hideLoading("#panelBody");
                }
            });
            return false; // for prevint actual submit
        });
        $('#list-table').on('click', 'a.edit-reference', function (e) {
            var control = this;
            var referenceId = $(control).attr('referenceId');
            jQuery.ajax({
                type: 'POST',
                dataType: 'JSON',
                url: "${g.createLink(controller: 'registration',action: 'edit')}?id=" + referenceId,
                success: function (data, textStatus) {
                    if (data.isError == false) {
                        $('#id').val(data.obj.id);
                        $('#name').val(data.obj.name);
                        $('#roll').val(data.obj.roll);
                        $('#birthday').val(data.obj.birthday);
                        $('#department').val(data.obj.department);
                        $('#modalTitle').text("Update Information");
                        $('#regFromModal').modal('show');
                    } else {
                        alert(data.message);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
            e.preventDefault();
        });

        $('#listTable').on('click', 'a.delete-reference', function (e) {
            var selectRow = $(this).parents('tr');
            var confirmDel = confirm("Are you sure delete Exam?");
            if (confirmDel == true) {
                showLoading("#panelBody");
                var control = this;
                var referenceId = $(control).attr('referenceId');
                jQuery.ajax({
                    type: 'POST',
                    dataType: 'JSON',
                    url: "${g.createLink(controller: 'registration',action: 'delete')}?id=" + referenceId,
                    success: function (data) {
                        hideLoading("#panelBody");
                        if (data.isError == false) {
                            showSuccessMsg(data.message);
                            $("#listTable").DataTable().row(selectRow).remove().draw(false);
                        } else {
                            showErrorMsg(data.message);
                        }
                    }
                });

            }
            e.preventDefault();
        });

    });

    function getActionButtons(nRow, aData) {
        var actionButtons = "";

        /*actionButtons += 'Edit';*/
        actionButtons += '<span class="col-md-3 no-padding"><a href=" " referenceId="' + aData.DT_RowId + '" class="edit-reference" title="Edit date" >';
        actionButtons += '<span  class="glyphicon glyphicon-edit">';
        actionButtons += '</a></span>';

        /* actionButtons += 'Delete';*/
        actionButtons += '<span class="col-md-3 no-padding"><a href="" referenceId="' + aData.DT_RowId + '" class="delete-reference" title="Delete date">';
        actionButtons += '<span class="glyphicon glyphicon-trash">';
        actionButtons += '</a></span>';

        return actionButtons;
    }

</script>
</body>
</html>





