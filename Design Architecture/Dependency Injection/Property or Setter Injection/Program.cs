
using Ap.DI_using_Property.Client;
using Ap.DI_using_Property.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //creating object
            Service1 s1 = new Service1();

            Client client = new Client();
            //passing dependency
            
            client.Service = s1; 
            
            //TO DO:
            client.ServeMethod();

            Service2 s2 = new Service2();
            //passing dependency
            client.Service = s2; 

            //TO DO:
            client.ServeMethod();

        }
    }
}
