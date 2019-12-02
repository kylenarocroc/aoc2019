using System;
using System.IO;

// Compiled and tested with:
// Mono JIT compiler version 6.4.0.198 (tarball Mon Sep 23 20:53:27 UTC 2019)

// Compile: csc d1.cs
// Run:     mono d1.exe

public class d1
{

    static void Main(string[] args)
    {
        long[] modules  = ParseFile("d1.txt");
        
        Console.WriteLine("Day 1 Part 1: {0}", p1(modules));

        Console.WriteLine("Day 1 Part 2: {0}", p2(modules));
    }

    static long p2(long[] modules)
    {
        long total = 0;

        foreach (long m in modules)
        {
            long f = Fuel(m);
            total += f;

            while ((Fuel(f)) > 0 )
            {
                total += Fuel(f);
                f = Fuel(f);
            }
        }

        return total;

    }

    static long p1(long[] modules)
    {
        long total = 0;

        foreach (long m in modules) 
        {
            total += Fuel(m);
        }
        
        return total;
    }

    static long Fuel(long module)
    {
        return -2+(long)Math.Floor((double)module/3);
    }

    static long[] ParseFile(string file)
    {
        string[] lines = File.ReadAllLines(file);
        int LineNum = lines.Length;

        long[] modules = new long[LineNum];

        for (int i = 0; i < LineNum; i++)
        {
            modules[i] = long.Parse(lines[i]);
        }

        return modules;
    }
    
}
