// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.LanternriddlesInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;
using System.Collections.Generic;

#nullable disable
namespace SqlDataProvider.Data
{
  public class LanternriddlesInfo
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int int_5;
    private int int_6;
    private int int_7;
    private int int_8;
    private int int_9;
    private bool bool_0;
    private bool bool_1;
    private DateTime dateTime_0;
    private Dictionary<int, LightriddleQuestInfo> dictionary_0;

    public int PlayerID
    {
      get => this.int_0;
      set => this.int_0 = value;
    }

    public int QuestionIndex
    {
      get => this.int_1;
      set => this.int_1 = value;
    }

    public int QuestionView
    {
      get => this.int_2;
      set => this.int_2 = value;
    }

    public int DoubleFreeCount
    {
      get => this.int_3;
      set => this.int_3 = value;
    }

    public int DoublePrice
    {
      get => this.int_4;
      set => this.int_4 = value;
    }

    public int HitFreeCount
    {
      get => this.int_5;
      set => this.int_5 = value;
    }

    public int HitPrice
    {
      get => this.int_6;
      set => this.int_6 = value;
    }

    public int MyInteger
    {
      get => this.int_7;
      set => this.int_7 = value;
    }

    public int QuestionNum
    {
      get => this.int_8;
      set => this.int_8 = value;
    }

    public int Option
    {
      get => this.int_9;
      set => this.int_9 = value;
    }

    public bool IsHint
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public bool IsDouble
    {
      get => this.bool_1;
      set => this.bool_1 = value;
    }

    public DateTime EndDate
    {
      get => this.dateTime_0;
      set => this.dateTime_0 = value;
    }

    public Dictionary<int, LightriddleQuestInfo> QuestViews
    {
      get => this.dictionary_0;
      set => this.dictionary_0 = value;
    }

    public int GetQuestionID
    {
      get => this.dictionary_0 != null ? this.dictionary_0[this.int_1].QuestionID : 1;
    }

    public LightriddleQuestInfo GetCurrentQuestion
    {
      get => this.dictionary_0 != null ? this.dictionary_0[this.int_1] : this.dictionary_0[1];
    }

    public bool CanNextQuest => this.int_1 <= this.int_2 - 1;
  }
}
