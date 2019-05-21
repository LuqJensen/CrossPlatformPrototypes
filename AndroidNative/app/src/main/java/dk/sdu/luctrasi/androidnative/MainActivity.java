package dk.sdu.luctrasi.androidnative;

import android.content.res.AssetManager;
import android.icu.util.Output;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.time.Duration;
import java.time.Instant;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MainActivity extends AppCompatActivity {

    TextView output;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        output = (TextView) findViewById(R.id.textViewOutput);
        Button buttonBenchmarks = (Button) findViewById(R.id.buttonBenchmarks);
        buttonBenchmarks.setOnClickListener( new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                try {
                    runBenchmarks();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private void runBenchmarks() throws Exception {
        output.setText("Running benchmarks...");
        StringBuilder sb = new StringBuilder();
        int iterations = 10;

        long matmul = 0;
        for (int i = 0; i < iterations; ++i) {
            matmul += testMatMul();
        }
        sb.append("matmul:t:" + ((double)matmul) / iterations + "\n");

        long patmch1 = 0;
        for (int i = 0; i < iterations; ++i) {
            patmch1 += testPatmch1();
        }
        sb.append("patmch:1t:" + ((double)patmch1) / iterations + "\n");

        long patmch2 = 0;
        for (int i = 0; i < iterations; ++i) {
            patmch2 += testPatmch2();
        }
        sb.append("patmch:2t:" + ((double)patmch2) / iterations + "\n");

        long dict = 0;
        for (int i = 0; i < iterations; ++i) {
            dict += testDict();
        }
        sb.append("dict:t:" + ((double)dict) / iterations + "\n");


        output.setText(sb.toString());
    }

    private long testPatmch1() throws Exception {
        Instant starts = Instant.now();

        InputStream is = getResources().getAssets().open("howto");
        BufferedReader stdin = new BufferedReader(new InputStreamReader(is));
        String line;

        Pattern re = Pattern.compile("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)");
        while ((line = stdin.readLine()) != null) {
            Matcher m = re.matcher(line);
        }
        Instant ends = Instant.now();
        return Duration.between(starts, ends).getSeconds();
    }

    private long testPatmch2() throws Exception {
        Instant starts = Instant.now();

        InputStream is = getResources().getAssets().open("howto");
        BufferedReader stdin = new BufferedReader(new InputStreamReader(is));
        String line;

        Pattern re = Pattern.compile("([a-zA-Z][a-zA-Z0-9]*)://([^ /]+)(/?[^ ]*)|([^ @]+)@([^ @]+)");
        while ((line = stdin.readLine()) != null) {
            Matcher m = re.matcher(line);
        }
        Instant ends = Instant.now();
        return Duration.between(starts, ends).getSeconds();
    }

    private long testDict() throws Exception {
        Instant starts = Instant.now();

        InputStream is = getResources().getAssets().open("5million.txt");
        BufferedReader stdin = new BufferedReader(new InputStreamReader(is));
        HashMap<String, Integer> h = new HashMap<String, Integer>();
        String l;
        int max = 0;
        while ((l = stdin.readLine()) != null) {
            int x = 1;
            if (h.containsKey(l)) {
                x = h.get(l) + 1;
                h.put(l, x);
                if (x > max) max = x;
            } else h.put(l, 1);
        }
        Instant ends = Instant.now();
        return Duration.between(starts, ends).getSeconds();
    }

    private long testMatMul() {
        Instant starts = Instant.now();
        int n = 1000;
        double[][] a = matgen(n);
        double[][] b = matgen(n);
        double[][] c = matmul(a, b);
        Instant ends = Instant.now();
        return Duration.between(starts, ends).getSeconds();
    }

    private double[][] matgen(int n) {
        double[][] a = new double[n][n];
        double tmp = 1. / n / n;
        for (int i = 0; i < n; ++i)
            for (int j = 0; j < n; ++j)
                a[i][j] = tmp * (i - j) * (i + j);
        return a;
    }
    private double[][] matmul(double[][] a, double[][] b) {
        int m = a.length, n = a[0].length, p = b[0].length;
        double[][] x = new double[m][p];
        double[][] c = new double[p][n];
        for (int i = 0; i < n; ++i) // transpose
            for (int j = 0; j < p; ++j)
                c[j][i] = b[i][j];
        for (int i = 0; i < m; ++i)
            for (int j = 0; j < p; ++j) {
                double s = 0.0;
                for (int k = 0; k < n; ++k)
                    s += a[i][k] * c[j][k];
                x[i][j] = s;
            }
        return x;
    }
}
