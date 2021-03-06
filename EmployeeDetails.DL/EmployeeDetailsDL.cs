using EmployeeDetails.DTO;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmployeeDetails.DL
{
    public class EmployeeDetailsDL
    {
        private SqlConnection con;
        public EmployeeDetailsDL()
        {
            string conStr = "Data Source=MSHAREE-IN-LE01\\SQLEXPRESS;Initial Catalog=shareek_learn;Integrated Security=True";
            con = new SqlConnection(conStr);
        }

        /*Returns List of all Employee Objects*/
        public List<EmployeeDTO> GetAllEmployees()
        {
            con.Open();
            SqlCommand sql = new SqlCommand("Select *,(Select DivisionName from Division where DivisionID = Division) as DivisionName,(Select ManagerName from Manager where ManagerID = Manager) as ManagerName from Employees", con);
            List<EmployeeDTO> _empoyees = new List<EmployeeDTO>();
            SqlDataReader data = sql.ExecuteReader();
            while (data.Read())
            {
                EmployeeDTO _emp = new EmployeeDTO();
                _emp.EmployeeID = data.GetInt32(0);
                _emp.EmployeeName = data.GetString(1);
                _emp.JoiningDate = data.GetDateTime(2).ToString("dd MMM yyyy");
                _emp.Project = data.GetString(3);
                _emp.Division.DivisionId = data.GetInt32(4);
                _emp.Division.DivisionName = data.GetString(6);
                _emp.Manager.ManagerId = data.GetInt32(5);
                _emp.Manager.ManagerName = data.GetString(7);
                _empoyees.Add(_emp);
            }
            con.Close();
            return _empoyees;
        }

        /*Returns List of all Division Objects*/
        public List<DivisionDTO> GetAllDivisions()
        {
            con.Open();
            List<DivisionDTO> _divisions = new List<DivisionDTO>();
            SqlCommand sql = new SqlCommand("Select * from Division", con);
            SqlDataReader data = sql.ExecuteReader();
            while (data.Read())
            {
                DivisionDTO div = new DivisionDTO();
                div.DivisionId = data.GetInt32(0);
                div.DivisionName = data.GetString(1);
                _divisions.Add(div);
            }
            con.Close();
            return _divisions;
        }


        /*Returns List of all Manager Objects of a Particular Division*/
        public List<ManagerDTO> PopulateManagers(int divisionId)
        {
            con.Open();
            List<ManagerDTO> _managers = new List<ManagerDTO>();
            SqlCommand sql = new SqlCommand("Select * from Manager where Division like '"+divisionId+"'", con);
            SqlDataReader data = sql.ExecuteReader();
            while (data.Read())
            {
                ManagerDTO manager = new ManagerDTO();
                manager.ManagerId = data.GetInt32(0);
                manager.ManagerName = data.GetString(1);
                manager.Division.DivisionId = data.GetInt32(2);
                _managers.Add(manager);
            }
            con.Close();
            return _managers;
        }

        /* Insert/Update an Employee */
        public string SaveEmp(EmployeeDTO emp)
        {
            con.Open();
            string action = "Employee Not Saved";
            if(emp.EmployeeID == -1)
            {
                // New Employee
                try
                {
                    SqlCommand sql = new SqlCommand("Insert into Employees values('" + emp.EmployeeName + "','" + emp.JoiningDate + "','" + emp.Project + "'," + emp.Division.DivisionId + "," + emp.Manager.ManagerId + ")", con);
                    sql.ExecuteNonQuery();
                    action = "Employee Inserted";
                }
                catch(SqlException e)
                {
                    action = "Unable to insert Employee\n" + e.Message;
                }
            } 
            else
            {
                // Employee already there update details
                try
                {
                    SqlCommand sql = new SqlCommand("Update Employees set EmployeeName = '" + emp.EmployeeName + "', JoiningDate = '" + emp.JoiningDate + "', Project = '" + emp.Project + "', Division = " + emp.Division.DivisionId + ", Manager = " + emp.Manager.ManagerId + "where EmployeeID like '" + emp.EmployeeID + "'", con);
                    sql.ExecuteNonQuery();
                    action = "Employee Updated";
                }
                catch (SqlException e)
                {
                    action = "Unable to update Employee\n" + e.Message;
                }
            }
            con.Close();
            return action;
        }

        /*Delete an Employee*/
        public string DeleteEmp(List<string> emp_ids)
        {
            string response = "not deleted";
            con.Open();
            foreach(var id in emp_ids)
            {
                try
                {
                    SqlCommand sql = new SqlCommand("Delete from Employees where EmployeeID like '" + id + "'", con);
                    sql.ExecuteNonQuery();
                    response = "Employee(s) Deleted";
                }
                catch (SqlException e)
                {
                    response = "Problem with Deleting\n"+e.Message;
                }
                
            }
            con.Close();
            return response;
        }
    }
}
