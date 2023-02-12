using Ap.DI_using_Property.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.DI_using_Property.Client
{
    public class Client
    {
        private IService _service;

        //Setter Property
        public IService Service
        {
            set { this._service = value; }
        }

        public void ServeMethod()
        {
            this._service.Serve();
        }

    }
}
