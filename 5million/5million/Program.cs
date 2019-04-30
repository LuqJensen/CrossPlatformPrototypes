using System;
using System.IO;

namespace _5million
{
    class Program
    {
        static void Main(string[] args)
        {
            Random r = new Random();
            var strings = new string[5000000];
            for (int i = 0; i < 5000000; ++i)
            {
                strings[i] = ((r.Next() % (5000000 / 4)) * 271828183).ToString();
            }
            File.WriteAllLines("5million.txt", strings);
        }
    }
}
