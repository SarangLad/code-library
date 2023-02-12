using Ap.Dependency_Injection.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.Dependency_Injection.Client
{
    public class Client
    {
        private IService _service;
        public Client(IService service)
        {
            this._service = service;
        }

        public void ServeMethod()
        {
            this._service.Serve();
        }
    }
}
