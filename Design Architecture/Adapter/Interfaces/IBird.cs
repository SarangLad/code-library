using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ap.Adapter.Interfaces
{
    public interface IBird
    {
        // birds implement Bird interface that allows
        // them to fly and make sounds adaptee interface
        void Fly();
        void MakeSound();
    }
}
