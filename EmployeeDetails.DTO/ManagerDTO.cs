using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmployeeDetails.DTO
{
    public class ManagerDTO
    {
        public int ManagerId;
        public string ManagerName;
        public DivisionDTO Division;

        public ManagerDTO()
        {
            Division = new DivisionDTO();
        }
    }
}
