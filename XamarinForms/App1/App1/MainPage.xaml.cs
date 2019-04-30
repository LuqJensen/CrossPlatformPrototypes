using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using MathFuncs;
using Xamarin.Forms;

namespace App1
{
    public partial class MainPage : ContentPage
    {

        public MainPage()
        {
            InitializeComponent();
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            //var assembly = IntrospectionExtensions.GetTypeInfo(typeof(MainPage)).Assembly;
            /*foreach (var res in assembly.GetManifestResourceNames())
            {
                System.Diagnostics.Debug.WriteLine("Found resource: " + res);
            */
        }

        protected override void OnDisappearing()
        {
            base.OnDisappearing();
        }

        private string TestCPP()
        {
            StringBuilder sb = new StringBuilder();
            using (var myMathFuncs = new MyMathFuncs())
            {
                var numberA = 1;
                var numberB = 2;

                // Test Add function
                var addResult = myMathFuncs.Add(numberA, numberB);

                // Test Subtract function
                var subtractResult = myMathFuncs.Subtract(numberA, numberB);

                // Test Multiply function
                var multiplyResult = myMathFuncs.Multiply(numberA, numberB);

                // Test Divide function
                var divideResult = myMathFuncs.Divide(numberA, numberB);

                // Output results
                sb.AppendLine($"{numberA} + {numberB} = {addResult}");
                sb.AppendLine($"{numberA} - {numberB} = {subtractResult}");
                sb.AppendLine($"{numberA} * {numberB} = {multiplyResult}");
                sb.AppendLine($"{numberA} / {numberB} = {divideResult}");
            }
            return sb.ToString();
        }

        private long TestDict()
        {
            var sw = Stopwatch.StartNew();
            string line;
            var dict = new Dictionary<string, int>();

            using (var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("App1.5million.txt"))
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

            using (var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("App1.howto"))
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

            using (var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("App1.howto"))
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

        private async void Button_Benchmarks(object sender, EventArgs e)
        {
            Output.Text = "Running benchmarks...";
            string result = await Task.Run(() => RunBenchmarks());
            Output.Text = result;
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

        private void Button_CPP(object sender, EventArgs e)
        {
            Output.Text = TestCPP();
        }
    }
}
