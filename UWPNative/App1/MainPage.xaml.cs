using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace App1
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        public MainPage()
        {
            this.InitializeComponent();
        }

        private async void ButtonBase_OnClick(object sender, RoutedEventArgs e)
        {
            Output.Text = "Running benchmarks...";
            string result = await Task.Run(() => RunBenchmarks());
            Output.Text = result;
        }
        private long TestDict()
        {
            var sw = Stopwatch.StartNew();
            string line;
            var dict = new Dictionary<string, int>();

            using (var stream = File.OpenRead("5million.txt"))
            using (var reader = new StreamReader(stream))
            {
                while ((line = reader.ReadLine()) != null)
                {
                    dict.TryGetValue(line, out var count);
                    dict[line] = count + 1;
                }
            }
            sw.Stop();
            return sw.ElapsedMilliseconds;
        }

        private long TestPatmch1()
        {
            var sw = Stopwatch.StartNew();
            string line;
            var re = new Regex("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)");

            using (var stream = File.OpenRead("howto"))
            using (var reader = new StreamReader(stream))
            {
                while ((line = reader.ReadLine()) != null)
                {
                    re.IsMatch(line);
                }
            }
            sw.Stop();
            return sw.ElapsedMilliseconds;
        }

        private long TestPatmch2()
        {
            var sw = Stopwatch.StartNew();
            string line;
            var re = new Regex("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)|([^ @]+)@([^ @]+)");

            using (var stream = File.OpenRead("howto"))
            using (var reader = new StreamReader(stream))
            {
                while ((line = reader.ReadLine()) != null)
                {
                    re.IsMatch(line);
                }
            }
            sw.Stop();
            return sw.ElapsedMilliseconds;
        }

        private long TestMatMul()
        {
            var sw = Stopwatch.StartNew();
            const int n = 1000;
            var a = Matgen(n);
            var b = Matgen(n);
            var c = Matmul(a, b);
            sw.Stop();
            return sw.ElapsedMilliseconds;
        }

        private double[,] Matgen(int n)
        {
            double[,] a = new double[n, n];
            double tmp = 1.0 / n / n;
            for (int i = 0; i < n; ++i)
                for (int j = 0; j < n; ++j)
                    a[i, j] = tmp * (i - j) * (i + j);
            return a;
        }
        private double[,] Matmul(double[,] a, double[,] b)
        {
            int m = a.GetLength(0), n = a.GetLength(1), p = b.GetLength(0);
            double[,] x = new double[m, p];
            double[,] c = new double[p, n];
            for (int i = 0; i < n; ++i) // transpose
                for (int j = 0; j < p; ++j)
                    c[j, i] = b[i, j];
            for (int i = 0; i < m; ++i)
                for (int j = 0; j < p; ++j)
                {
                    double s = 0.0;
                    for (int k = 0; k < n; ++k)
                        s += a[i, k] * c[j, k];
                    x[i, j] = s;
                }
            return x;
        }

        private string RunBenchmarks()
        {
            StringBuilder sb = new StringBuilder();
            const int ITERATIONS = 10;

            long matmul = 0;
            for (int i = 0; i < ITERATIONS; ++i)
            {
                matmul += TestMatMul();
            }
            sb.AppendLine($"matmul:t: {((double)matmul) / 1000 / ITERATIONS}s");

            long patmch1 = 0;
            for (int i = 0; i < ITERATIONS; ++i)
            {
                patmch1 += TestPatmch1();
            }
            sb.AppendLine($"patmch:1t: {((double)patmch1) / 1000 / ITERATIONS}s");

            long patmch2 = 0;
            for (int i = 0; i < ITERATIONS; ++i)
            {
                patmch2 += TestPatmch2();
            }
            sb.AppendLine($"patmch:2t: {((double)patmch2) / 1000 / ITERATIONS}s");

            long dict = 0;
            for (int i = 0; i < ITERATIONS; ++i)
            {
                dict += TestDict();
            }
            sb.AppendLine($"dict:t: {((double)dict) / 1000 / ITERATIONS}s");

            return sb.ToString();
        }
    }
}
