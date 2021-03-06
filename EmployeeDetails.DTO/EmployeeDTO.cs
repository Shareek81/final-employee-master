using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmployeeDetails.DTO
{
    public class EmployeeDTO
    {
        public int EmployeeID { get; set; }
        public string EmployeeName { get; set; }
        public string JoiningDate { get; set; }
        public string Project { get; set; }
        public DivisionDTO Division { get; set; }
        public ManagerDTO Manager { get; set; }
        public EmployeeDTO()
        {
            this.Division = new DivisionDTO();
            this.Manager = new ManagerDTO();
        }
    }
}
