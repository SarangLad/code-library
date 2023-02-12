using Ap.Adapter.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.Adapter.Classes
{
    public class Sparrow : IBird
    {
        // a concrete implementation of bird
        public void Fly()
        {
            Console.WriteLine("Flying");
        }
        public void MakeSound()
        {
            Console.WriteLine("Chirp Chirp");
        }
    }
}
