Stopwatch sw =new Stopwatch();
sw.Start();
for (int i = 0; i < Count.Count; i++)
{
    lst1.Add(i);
}

sw.Stop();
Console.Write("For Loop :- "+ sw.ElapsedTicks+"\n");
//output: For Loop :- 72



sw.Restart();
foreach (int a in Count)
{
    lst2.Add(a);
}
sw.Stop();
Console.Write("Foreach Loop:- " +  sw.ElapsedTicks);
//output: For Loop :- 109