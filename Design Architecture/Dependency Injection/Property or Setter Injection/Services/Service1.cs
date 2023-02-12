using Ap.DI_using_Property.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.DI_using_Property.Services
{
    public class Service1 : IService
    {
        public void Serve()
        {
            Console.WriteLine("Service1 Called");
        }
    }
}
