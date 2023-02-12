using Ap.Adapter.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.Adapter.Classes
{
    public class BirdAdapter: IToyDuck
    {
        // You need to implement the interface your
        // client expects to use.
        IBird bird;
        public BirdAdapter(IBird bird)
        {
            // we need reference to the object we
            // are adapting
            this.bird = bird;
        }

        public void squeak()
        {
            // translate the methods appropriately
            bird.MakeSound();
        }
    }
}
