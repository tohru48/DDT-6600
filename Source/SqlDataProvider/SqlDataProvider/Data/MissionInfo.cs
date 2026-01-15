// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.MissionInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class MissionInfo
  {
    private int int_0;
    private string string_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private string string_1;
    private string string_2;
    private string string_3;
    private string string_4;
    private int int_5;
    private int int_6;
    private int int_7;
    private int int_8;
    private string string_5;

    public int Id
    {
      get => this.int_0;
      set => this.int_0 = value;
    }

    public string Name
    {
      get => this.string_0;
      set => this.string_0 = value;
    }

    public int TotalCount
    {
      get => this.int_1;
      set => this.int_1 = value;
    }

    public int TotalTurn
    {
      get => this.int_2;
      set => this.int_2 = value;
    }

    public int IncrementDelay
    {
      get => this.int_3;
      set => this.int_3 = value;
    }

    public int Delay
    {
      get => this.int_4;
      set => this.int_4 = value;
    }

    public string Script
    {
      get => this.string_1;
      set => this.string_1 = value;
    }

    public string Success
    {
      get => this.string_3;
      set => this.string_3 = value;
    }

    public string Failure
    {
      get => this.string_2;
      set => this.string_2 = value;
    }

    public string Description
    {
      get => this.string_5;
      set => this.string_5 = value;
    }

    public string Title
    {
      get => this.string_4;
      set => this.string_4 = value;
    }

    public int Param1
    {
      get => this.int_5;
      set => this.int_5 = value;
    }

    public int Param2
    {
      get => this.int_6;
      set => this.int_6 = value;
    }

    public int Param3
    {
      get => this.int_7;
      set => this.int_7 = value;
    }

    public int Param4
    {
      get => this.int_8;
      set => this.int_8 = value;
    }

    public MissionInfo()
    {
      this.int_5 = -1;
      this.int_6 = -1;
      this.int_7 = -1;
      this.int_8 = -1;
    }

    public MissionInfo(
      int id,
      string name,
      string key,
      string description,
      int totalCount,
      int totalTurn,
      int initDelay,
      int delay,
      string title,
      int param1,
      int param2)
    {
      this.int_0 = id;
      this.string_0 = name;
      this.string_5 = description;
      this.string_2 = key;
      this.int_1 = totalCount;
      this.int_2 = totalTurn;
      this.int_3 = initDelay;
      this.int_4 = delay;
      this.string_4 = title;
      this.int_5 = param1;
      this.int_6 = param2;
      this.int_7 = -1;
      this.int_8 = -1;
    }
  }
}
