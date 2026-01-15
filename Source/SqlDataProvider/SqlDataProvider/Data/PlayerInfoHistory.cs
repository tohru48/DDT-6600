// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.PlayerInfoHistory
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class PlayerInfoHistory : DataObject
  {
    private DateTime dateTime_0;
    private DateTime dateTime_1;
    private int int_0;
    private Dictionary<int, int> QGIDVZWLFC;
    private object object_0;
    private string string_0;
    private static readonly int int_1 = 15;

    public string ComposeStateString
    {
      get
      {
        this.string_0 = this.method_1(this.QGIDVZWLFC);
        if (this.string_0.Length > 200)
        {
          this.method_0();
          this.string_0 = this.method_1(this.QGIDVZWLFC);
          if (this.string_0.Length > 200)
            throw new ArgumentOutOfRangeException("the compose state string is too long, to fix the error you should clean the column Sys_Users_History.ComposeState in DB");
        }
        return this.string_0;
      }
      set
      {
        this.string_0 = value;
        this.QGIDVZWLFC = this.method_2(this.string_0);
      }
    }

    public DateTime LastQuestsTime
    {
      get => this.dateTime_0;
      set => this.dateTime_0 = value;
    }

    public DateTime LastTreasureTime
    {
      get => this.dateTime_1;
      set => this.dateTime_1 = value;
    }

    public int UserID
    {
      get => this.int_0;
      set => this.int_0 = value;
    }

    private void method_0()
    {
      int[] array = new int[this.QGIDVZWLFC.Keys.Count];
      this.QGIDVZWLFC.Keys.CopyTo(array, 0);
      Array.Sort<int>(array);
      int int1 = PlayerInfoHistory.int_1;
      for (int index = array.Length - 1; index >= 0; --index)
      {
        --int1;
        if (int1 < 0)
          this.QGIDVZWLFC.Remove(array[index]);
      }
    }

    public int ComposeStateLockIncrement(int key)
    {
      int num;
      lock (this.object_0)
      {
        this._isDirty = true;
        if (!this.QGIDVZWLFC.ContainsKey(key))
          this.QGIDVZWLFC.Add(key, 0);
        Dictionary<int, int> qgidvzwlfc;
        (qgidvzwlfc = this.QGIDVZWLFC)[key] = qgidvzwlfc[key] + 1;
        num = this.QGIDVZWLFC[key];
      }
      return num;
    }

    private string method_1(Dictionary<int, int> stateDict)
    {
      List<string> stringList = new List<string>();
      Dictionary<int, int>.Enumerator enumerator = this.QGIDVZWLFC.GetEnumerator();
      while (enumerator.MoveNext())
      {
        KeyValuePair<int, int> current1 = enumerator.Current;
        KeyValuePair<int, int> current2 = enumerator.Current;
        stringList.Add(string.Format("{0}-{1}", (object) current2.Key, (object) current2.Value));
      }
      return string.Join(",", stringList.ToArray());
    }

    private Dictionary<int, int> method_2(string string_1)
    {
      Dictionary<int, int> dictionary = new Dictionary<int, int>();
      string str1 = string_1;
      char[] chArray1 = new char[1]{ ',' };
      foreach (string str2 in str1.Split(chArray1))
      {
        char[] chArray2 = new char[1]{ '-' };
        string[] strArray = str2.Split(chArray2);
        if (strArray.Length == 2)
        {
          int key = int.Parse(strArray[0]);
          if (!dictionary.ContainsKey(key))
            dictionary.Add(key, int.Parse(strArray[1]));
        }
      }
      return dictionary;
    }

    public PlayerInfoHistory() => this.object_0 = new object();
  }
}
