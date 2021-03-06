<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeDetails.aspx.cs" Inherits="LearnApp2.EmployeeDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Master</title>
    <link rel="stylesheet" href="https://kendo.cdn.telerik.com/2021.1.224/styles/kendo.bootstrap-v4.min.css" />
    <script src="https://kendo.cdn.telerik.com/2021.1.224/js/jquery.min.js"></script>
    <script src="https://kendo.cdn.telerik.com/2021.1.224/js/kendo.all.min.js"></script>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
        }
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 16px;
            padding: 16px;
            z-index: 0;
        }
        .controls {
            align-self: center;
            width: 80%;
            margin: 24px;
            display: flex;
            flex-direction: row;
            justify-content: flex-end;
        }
        #grid {
            width: 80%;
        }
        h2 {
            align-self: flex-start;
            width: 50%;
            padding: 8px;
            border-bottom: 2px solid Highlight;
        }
        button {
            margin: 2px;
            padding: 8px 12px;
            background-color: Highlight;
            color: white;
            border: none;
            border-radius: 4px;
        }
        button:focus {
            outline: 0;
        }
        .modal {
            visibility: hidden;
            position: fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%; 
            height: 100%;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: white;
            padding: 24px;
            border-radius: 8px;
            width: 32%;
        }
        .form-control {
            border: 1px solid #ccc;
            height: 24px;
            width: 100%;
            margin: 6px;
        }
        .form-control:focus {
            outline: 0;
        }
        td button {
            margin: 12px;
        }
        .k-grid-content {
            max-height: 280px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Employee Details</h2>
        <div class="controls">
            <button onclick="open_add_emp_modal(1)">Add</button>
            <button onclick="open_add_emp_modal(2)">Edit</button>
            <button onclick="delete_selected_employees()">Delete</button>
        </div>
        <div id="grid">
        </div>
    </div>
    <div id="add_emp_modal" class="modal">
        <div class="modal-content">
            <table class="controls">
                <tr>
                    <td>Employee ID<sup>*</sup></td>
                    <td><input type="text" id="emp_id" class="form-control" disabled="disabled"/></td>
                </tr>
                <tr>
                    <td>Employee Name<sup>*</sup></td>
                    <td><input type="text" id="emp_name" class="form-control"/></td>
                </tr>
                <tr>
                    <td>Joining Date<sup>*</sup></td>
                    <td><input type="date" id="join_date" class="form-control"/></td>
                </tr>
                <tr>
                    <td>Project<sup>*</sup></td>
                    <td><input type="text" id="project" class="form-control"/></td>
                </tr>
                <tr>
                    <td>Division<sup>*</sup></td>
                    <td><select id="division_select" onchange="populateManagers(this.value)" class="form-control"></select></td>
                </tr>                
                <tr>
                    <td>Manager<sup>*</sup></td>
                    <td><select id="manager_select" class="form-control"></select></td>
                </tr> 
                <tr>
                    <td colspan="2" ><button onclick="save_emp()">Save</button> <button onclick="close_add_emp_modal()">Close</button></td>
                </tr>
            </table>
        </div>
    </div>
<script>
    var grid;
    var selected_cells = []; //JSON of selected table rows

    $(document).ready(function () {
        // Initialising the Grid
        grid = $("#grid").kendoGrid({
            pageable: false,
            scrollable: true,
            persistSelection: true,
            sortable: true,
            change: gridOnChange,
            columns: [
                { selectable: true, width: "50px" },
                { field: "EmployeeName", title: "Employee Name" },
                { field: "JoiningDate", title: "Date Joined"},
                { field: "Project", title: "Project" },
                { field: "Division.DivisionName", title:"Division" },
                { field: "Manager.ManagerName", title:"Manager"}]
        }).data("kendoGrid");;
        fetchEmployees(); 
        fetchDivisions();
    });
    function gridOnChange() {
        // Table checkbox selected/unselected
        selected_cells = [];
        var selectedCells = this.select();
        for (i = 0; i < selectedCells.length; i++) {
            selected_cells.push(this.dataItem(selectedCells[i].closest('tr')));
        }
    }
    function fetchEmployees() {
        $.ajax({
            type: "POST",
            url: "EmployeeDetails.aspx/GetEmployees",
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                let _employees = JSON.parse(data.d);
                console.log(_employees);
                var dataSource = new kendo.data.DataSource({
                    data: _employees
                });
                grid.setDataSource(dataSource);
            }
        });
    }
    function fetchDivisions() {
        $.ajax({
            type: "POST",
            url: "EmployeeDetails.aspx/GetDivisions",
            data: "{}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                division_select.innerHTML = '';
                let _divisions = JSON.parse(data.d);
                for (_div of _divisions) {
                    let opt = document.createElement('option');
                    opt.value = _div.DivisionId;
                    opt.text = _div.DivisionName;
                    division_select.appendChild(opt);
                }
            }
        });
    }
    /*function populateManagers(_divisionId, callback=null) {
        // alert("PopulateManager Function");
        $.ajax({
            type: "POST",
            url: "EmployeeDetails.aspx/PopulateManagers",
            data: "{divisionId:" + _divisionId+"}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                manager_select.innerHTML = '';
                let _managers = JSON.parse(data.d);
                for (manager of _managers) {
                    let opt = document.createElement('option');
                    opt.value = manager.ManagerId;
                    opt.text = manager.ManagerName;
                    manager_select.appendChild(opt);
                }
                if (callback != null) {
                    callback();
                }
                
            }
        });
    }*/

    function populateManagers(_divisionId) {
        return new Promise(function (resolve, reject) {
            $.ajax({
                type: "POST",
                url: "EmployeeDetails.aspx/PopulateManagers",
                data: "{divisionId:" + _divisionId + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    manager_select.innerHTML = '';
                    let _managers = JSON.parse(data.d);
                    for (manager of _managers) {
                        let opt = document.createElement('option');
                        opt.value = manager.ManagerId;
                        opt.text = manager.ManagerName;
                        manager_select.appendChild(opt);
                    }
                    resolve();
                },
                error: (e) => {
                    reject(e);
                }
            });
        });
    }
    /*function selectManager() {
        manager_select.value = selected_cells[0].Manager.ManagerId;
    }*/
    function open_add_emp_modal(key) {
        //Opens the employee save modal
        reset_fields();
        if (key == 1) {
            // Adding an employee
            emp_id.value = 'new';
            add_emp_modal.style.visibility = 'visible';
        } else if (key == 2) {
            // Editing an existing employee
            if (selected_cells.length == 1) {
                let employee = selected_cells[0];
                emp_id.value = employee.EmployeeID;
                emp_name.value = employee.EmployeeName;
                let date = new Date(employee.JoiningDate);
                join_date.value = date.getFullYear() + '-' + date.getMonth() + 1 + '-' + ('0' + date.getDate()).slice(-2);
                project.value = employee.Project;
                division_select.value = employee.Division.DivisionId;
                populateManagers(employee.Division.DivisionId).then(function() {
                    // Selecting manager once all the managers are fetched
                    manager_select.value = employee.Manager.ManagerId;
                }).catch(function(e) {
                    alert("Error");
                });
                add_emp_modal.style.visibility = 'visible';
            } else {
                alert((selected_cells.length > 1) ? "Can't Edit Multiple Fields Simultaneously..!" : "Select a row to edit!");
            }
        }
    }
    function close_add_emp_modal() {
        //Closes the save employee modal
        add_emp_modal.style.visibility = 'hidden';
    }
    function reset_fields() {
        //reset the form
        emp_id.value = '';
        emp_name.value = '';
        join_date.value = '';
        project.value = '';
        division_select.value = '';
        manager_select.value = '';
    }
    function save_emp() {
        // Saves the employee Details
        if (validate_inputs()) {
            $.ajax({
                type: "POST",
                url: "EmployeeDetails.aspx/SaveEmp",
                data: "{_id:'" + (emp_id.value != 'new' ? emp_id.value : '-1') + "', _name:'" + emp_name.value + "', _date:'" + join_date.value + "', _project:'" + project.value + "', _division:" + division_select.value + ", _manager:" + manager_select.value + "}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    fetchEmployees();
                    close_add_emp_modal();
                    alert(data.d);
                }
            });
        }
    }
    function delete_selected_employees() {
        // Delete selected employees
        let emp_ids = [];
        for (emp of selected_cells) {
            emp_ids.push(emp.EmployeeID);
        }
        $.ajax({
            type: "POST",
            url: "EmployeeDetails.aspx/DeleteEmp",
            data: "{_employee_ids:'" + (emp_ids.join(',')) + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                alert(data.d);
                fetchEmployees();
            }
        });
    }
    function validate_inputs() {
        // Validating inputs
        if (emp_name.value == '' || join_date.value == '' || project.value == '' || division_select.value == '' || manager_select.value == '') {
            alert("Kindly fill all fields");
            return false;
        } 
        return true;
    }
</script>
</body>
</html>
