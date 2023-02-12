using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.DI_using_Property.Services
{
    public class Service2 : IService
    {
        public void Serve()
        {
            Console.WriteLine("Service2 Called");
        }
    }
}
