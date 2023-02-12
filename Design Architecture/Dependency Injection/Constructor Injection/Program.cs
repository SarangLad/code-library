using Ap.Adapter.Classes;
using Ap.Adapter.Interfaces;
using Ap.Dependency_Injection.Client;
using Ap.Dependency_Injection.Services;
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
            //Creating object
            Service1 s1 = new Service1();
            
            //Passing dependency
            Client c1 = new Client(s1);
            
            //TO DO:
            c1.ServeMethod();

            Service2 s2 = new Service2();
            //passing dependency
            c1 = new Client(s2);
            //TO DO:
            c1.ServeMethod();

        }
    }
}
