// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.BufferInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class BufferInfo : DataObject
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private DateTime dateTime_0;
    private int int_3;
    private int int_4;
    private string string_0;
    private bool bool_0;
    private int int_5;

    public int UserID
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int Type
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int Value
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public DateTime BeginDate
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public int ValidDate
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int ValidCount
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public string Data
    {
      get => this.string_0;
      set
      {
        this.string_0 = value;
        this._isDirty = true;
      }
    }

    public bool IsExist
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public int TemplateID
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public DateTime GetEndDate() => this.dateTime_0.AddMinutes((double) this.int_3);

    public bool IsValid() => this.dateTime_0.AddMinutes((double) this.int_3) > DateTime.Now;
  }
}
