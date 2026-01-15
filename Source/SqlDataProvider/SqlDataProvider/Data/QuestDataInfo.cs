// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.QuestDataInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class QuestDataInfo : DataObject
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
    private int int_10;
    private bool bool_0;
    private DateTime dateTime_0;
    private bool bool_1;
    private int int_11;
    private int int_12;

    public int UserID
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int QuestID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int QuestLevel
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int Condition1
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int Condition2
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int Condition3
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public int Condition4
    {
      get => this.int_6;
      set
      {
        this.int_6 = value;
        this._isDirty = true;
      }
    }

    public int Condition5
    {
      get => this.int_7;
      set
      {
        this.int_7 = value;
        this._isDirty = true;
      }
    }

    public int Condition6
    {
      get => this.int_8;
      set
      {
        this.int_8 = value;
        this._isDirty = true;
      }
    }

    public int Condition7
    {
      get => this.int_9;
      set
      {
        this.int_9 = value;
        this._isDirty = true;
      }
    }

    public int Condition8
    {
      get => this.int_10;
      set
      {
        this.int_10 = value;
        this._isDirty = true;
      }
    }

    public bool IsComplete
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public DateTime CompletedDate
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public bool IsExist
    {
      get => this.bool_1;
      set
      {
        this.bool_1 = value;
        this._isDirty = true;
      }
    }

    public int RepeatFinish
    {
      get => this.int_11;
      set
      {
        this.int_11 = value;
        this._isDirty = true;
      }
    }

    public int RandDobule
    {
      get => this.int_12;
      set
      {
        this.int_12 = value;
        this._isDirty = true;
      }
    }

    public int GetConditionValue(int index)
    {
      switch (index)
      {
        case 0:
          return this.Condition1;
        case 1:
          return this.Condition2;
        case 2:
          return this.Condition3;
        case 3:
          return this.Condition4;
        case 4:
          return this.Condition5;
        case 5:
          return this.Condition6;
        case 6:
          return this.Condition7;
        case 7:
          return this.Condition8;
        default:
          throw new Exception("Quest condition index out of range.");
      }
    }

    public int GetConditionNum()
    {
      int conditionNum = 0;
      if (this.Condition1 > 0)
        ++conditionNum;
      if (this.Condition2 > 0)
        ++conditionNum;
      if (this.Condition3 > 0)
        ++conditionNum;
      if (this.Condition4 > 0)
        ++conditionNum;
      if (this.Condition5 > 0)
        ++conditionNum;
      if (this.Condition6 > 0)
        ++conditionNum;
      if (this.Condition7 > 0)
        ++conditionNum;
      if (this.Condition8 > 0)
        ++conditionNum;
      return conditionNum;
    }

    public QuestDataInfo Clone(int num)
    {
      QuestDataInfo questDataInfo = new QuestDataInfo();
      questDataInfo.QuestID = this.int_1;
      questDataInfo.UserID = this.int_0;
      switch (num)
      {
        case 1:
          questDataInfo.Condition1 = this.int_3;
          break;
        case 2:
          questDataInfo.Condition1 = this.int_4;
          break;
        case 3:
          questDataInfo.Condition1 = this.int_5;
          break;
        case 4:
          questDataInfo.Condition1 = this.int_6;
          break;
        case 5:
          questDataInfo.Condition1 = this.int_7;
          break;
        case 6:
          questDataInfo.Condition1 = this.int_8;
          break;
        case 7:
          questDataInfo.Condition1 = this.int_9;
          break;
        case 8:
          questDataInfo.Condition1 = this.int_10;
          break;
      }
      questDataInfo.RandDobule = this.int_12;
      questDataInfo.CompletedDate = this.dateTime_0;
      questDataInfo.IsComplete = this.bool_0;
      questDataInfo.bool_1 = this.bool_1;
      questDataInfo.QuestLevel = this.int_2;
      questDataInfo.RepeatFinish = this.int_11;
      return questDataInfo;
    }

    public void SaveConditionValue(int index, int value)
    {
      switch (index)
      {
        case 0:
          this.Condition1 = value;
          break;
        case 1:
          this.Condition2 = value;
          break;
        case 2:
          this.Condition3 = value;
          break;
        case 3:
          this.Condition4 = value;
          break;
        case 4:
          this.Condition5 = value;
          break;
        case 5:
          this.Condition6 = value;
          break;
        case 6:
          this.Condition7 = value;
          break;
        case 7:
          this.Condition8 = value;
          break;
        default:
          throw new Exception("Quest condition index out of range.");
      }
    }
  }
}
