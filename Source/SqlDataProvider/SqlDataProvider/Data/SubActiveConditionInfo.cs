// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.SubActiveConditionInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class SubActiveConditionInfo
  {
    public int ID { get; set; }

    public int ActiveID { get; set; }

    public int SubID { get; set; }

    public int ConditionID { get; set; }

    public int Type { get; set; }

    public string Value { get; set; }

    public int AwardType { get; set; }

    public string AwardValue { get; set; }

    public bool IsValid { get; set; }

    public int GetValue(string index)
    {
      Dictionary<string, string> dictionary = new Dictionary<string, string>();
      if (string.IsNullOrEmpty(this.Value))
        return 0;
      string[] strArray = this.Value.Split('-');
      for (int index1 = 1; index1 < strArray.Length; index1 += 2)
      {
        string key = strArray[index1 - 1];
        if (!dictionary.ContainsKey(key))
          dictionary.Add(key, strArray[index1]);
        else
          dictionary[key] = strArray[index1];
      }
      return dictionary.ContainsKey(index) ? int.Parse(dictionary[index]) : 0;
    }
  }
}
