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
            Sparrow sparrow = new Sparrow();
            IToyDuck toyDuck = new PlasticToyDuck();

            // Wrap a bird in a birdAdapter so that it 
            // behaves like toy duck
            IToyDuck birdAdapter = new BirdAdapter(sparrow);

            Console.WriteLine("Sparrow...");
            sparrow.Fly();
            sparrow.MakeSound();

            Console.WriteLine("ToyDuck...");
            toyDuck.squeak();

            // toy duck behaving like a bird 
            Console.WriteLine("BirdAdapter...");
            birdAdapter.squeak();

        }
    }
}
