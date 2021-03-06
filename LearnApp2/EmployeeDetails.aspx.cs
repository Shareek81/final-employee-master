using EmployeeDetails.BL;
using EmployeeDetails.DTO;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LearnApp2
{
    public partial class EmployeeDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /*Gets All the Employees*/
        [WebMethod]
        public static string GetEmployees()
        {
            return JsonConvert.SerializeObject(new EmployeeDetailsBL().GetAllEmployees());
        }

        /*Gets All the Divisions*/
        [WebMethod]
        public static string GetDivisions()
        {
            return JsonConvert.SerializeObject(new EmployeeDetailsBL().GetAllDivisions());
        }
        
        /*Gets all managers of a particular division*/
        [WebMethod]
        public static string PopulateManagers(int divisionId)
        {
            return JsonConvert.SerializeObject(new EmployeeDetailsBL().PopulateManagers(divisionId));
        }


        /*Makes save call*/
        [WebMethod]
        public static string SaveEmp(string _id, string _name, string _date, string _project, int _division, int _manager)
        {
            EmployeeDTO emp = new EmployeeDTO();
            emp.EmployeeID = Convert.ToInt32(_id);
            emp.EmployeeName = _name;
            emp.JoiningDate = _date;
            emp.Project = _project;
            emp.Division.DivisionId = _division;
            emp.Manager.ManagerId = _manager;
            return new EmployeeDetailsBL().SaveEmp(emp);
        }

        /*Makes delete call*/
        [WebMethod]
        public static string DeleteEmp(string _employee_ids)
        {
            List<string> emp_ids = _employee_ids.Split(',').ToList();
            return new EmployeeDetailsBL().DeleteEmp(emp_ids);
        }
    }
}