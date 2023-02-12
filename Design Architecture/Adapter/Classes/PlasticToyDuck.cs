using Ap.Adapter.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.Adapter.Classes
{
    public class PlasticToyDuck: IToyDuck
    {
        public void squeak()
        {
            Console.WriteLine("Squeak");
        }
    }
}
