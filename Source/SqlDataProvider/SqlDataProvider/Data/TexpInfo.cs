// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.TexpInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class TexpInfo : DataObject
  {
    private int iccgDiuObj;
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private int UbygpriyIv;
    private int int_5;
    private DateTime dateTime_0;

    public int ID { get; set; }

    public int UserID
    {
      get => this.iccgDiuObj;
      set
      {
        this.iccgDiuObj = value;
        this._isDirty = true;
      }
    }

    public int spdTexpExp
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int attTexpExp
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int defTexpExp
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int hpTexpExp
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int lukTexpExp
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public int texpTaskCount
    {
      get => this.UbygpriyIv;
      set
      {
        this.UbygpriyIv = value;
        this._isDirty = true;
      }
    }

    public int texpCount
    {
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public DateTime texpTaskDate
    {
      get => this.dateTime_0;
      set
      {
        this.dateTime_0 = value;
        this._isDirty = true;
      }
    }

    public bool IsValidadteTexp() => this.dateTime_0.Date < DateTime.Now.Date;
  }
}
