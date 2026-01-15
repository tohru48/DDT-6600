// Decompiled with JetBrains decompiler
// Type: Bussiness.ThreadSafeRandom
// Assembly: Bussiness, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 3C8934AE-6917-482F-905F-489DD4EC4ACA
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Bussiness.dll

using System;
using System.Collections.Generic;

#nullable disable
namespace Bussiness
{
  public class ThreadSafeRandom
  {
    private static Random random_0 = new Random();
    private Random random_1;

    public static int NextStatic()
    {
      int num;
      lock (ThreadSafeRandom.random_0)
        num = ThreadSafeRandom.random_0.Next();
      return num;
    }

    public static int NextStatic(int maxValue)
    {
      int num;
      lock (ThreadSafeRandom.random_0)
        num = ThreadSafeRandom.random_0.Next(maxValue);
      return num;
    }

    public static int NextStatic(int minValue, int maxValue)
    {
      int num;
      lock (ThreadSafeRandom.random_0)
        num = ThreadSafeRandom.random_0.Next(minValue, maxValue);
      return num;
    }

    public static void NextStatic(byte[] keys)
    {
      lock (ThreadSafeRandom.random_0)
        ThreadSafeRandom.random_0.NextBytes(keys);
    }

    public int Next()
    {
      int num;
      lock (this.random_1)
        num = this.random_1.Next();
      return num;
    }

    public int Next(int maxValue)
    {
      int num;
      lock (this.random_1)
        num = this.random_1.Next(maxValue);
      return num;
    }

    public int Next(int minValue, int maxValue)
    {
      int num;
      lock (this.random_1)
        num = this.random_1.Next(minValue, maxValue);
      return num;
    }

    public void ShufferList<T>(List<T> array)
    {
      for (int count = array.Count; count > 1; --count)
      {
        int index = this.random_1.Next(count);
        T obj = array[index];
        array[index] = array[count - 1];
        array[count - 1] = obj;
      }
    }

    public void Shuffer<T>(T[] array)
    {
      for (int length = array.Length; length > 1; --length)
      {
        int index = this.random_1.Next(length);
        T obj = array[index];
        array[index] = array[length - 1];
        array[length - 1] = obj;
      }
    }

    public static void ShufferStatic<T>(T[] array)
    {
      for (int length = array.Length; length > 1; --length)
      {
        int index = ThreadSafeRandom.random_0.Next(length);
        T obj = array[index];
        array[index] = array[length - 1];
        array[length - 1] = obj;
      }
    }

    public ThreadSafeRandom() => this.random_1 = new Random();
  }
}
