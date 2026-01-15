// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.PetEquipDataInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

using System;

#nullable disable
namespace SqlDataProvider.Data
{
  public class PetEquipDataInfo : DataObject
  {
    private ItemTemplateInfo itemTemplateInfo_0;
    private int int_0;
    private int int_1;
    private int int_2;
    private int int_3;
    private int int_4;
    private DateTime dateTime_0;
    private int int_5;
    private bool bool_0;

    public ItemTemplateInfo Template => this.itemTemplateInfo_0;

    public int ID
    {
      get => this.int_0;
      set
      {
        this.int_0 = value;
        this._isDirty = true;
      }
    }

    public int UserID
    {
      get => this.int_1;
      set
      {
        this.int_1 = value;
        this._isDirty = true;
      }
    }

    public int PetID
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public int eqTemplateID
    {
      get => this.int_3;
      set
      {
        this.int_3 = value;
        this._isDirty = true;
      }
    }

    public int eqType
    {
      get => this.int_4;
      set
      {
        this.int_4 = value;
        this._isDirty = true;
      }
    }

    public DateTime startTime
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
      get => this.int_5;
      set
      {
        this.int_5 = value;
        this._isDirty = true;
      }
    }

    public bool IsExit
    {
      get => this.bool_0;
      set
      {
        this.bool_0 = value;
        this._isDirty = true;
      }
    }

    public PetEquipDataInfo(ItemTemplateInfo temp) => this.itemTemplateInfo_0 = temp;

    public PetEquipDataInfo addTempalte(ItemTemplateInfo Template)
    {
      return new PetEquipDataInfo(Template)
      {
        int_0 = this.int_0,
        int_1 = this.int_1,
        int_2 = this.int_2,
        int_4 = this.int_4,
        int_3 = this.int_3,
        int_5 = this.int_5,
        dateTime_0 = this.dateTime_0,
        bool_0 = this.bool_0
      };
    }

    public bool IsValidate()
    {
      return this.int_5 == 0 || DateTime.Compare(this.dateTime_0.AddDays((double) this.int_5), DateTime.Now) > 0;
    }
  }
}
