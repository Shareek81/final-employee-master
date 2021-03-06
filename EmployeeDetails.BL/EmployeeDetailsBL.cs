using EmployeeDetails.DL;
using EmployeeDetails.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmployeeDetails.BL
{
    public class EmployeeDetailsBL
    {
        EmployeeDetailsDL edl;
        public EmployeeDetailsBL()
        {
            edl = new EmployeeDetailsDL();
        }
        public List<EmployeeDTO> GetAllEmployees()
        {
            return edl.GetAllEmployees();
        }
        public List<DivisionDTO> GetAllDivisions()
        {
            return edl.GetAllDivisions();
        }
        public List<ManagerDTO> PopulateManagers(int divisionId)
        {
            return edl.PopulateManagers(divisionId);
        }
        public string SaveEmp(EmployeeDTO emp)
        {
            return edl.SaveEmp(emp);
        }
        public string DeleteEmp(List<string> emp_ids)
        {
            return edl.DeleteEmp(emp_ids);
        }
    }
}
