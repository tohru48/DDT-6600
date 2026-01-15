// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.UsersPetFormInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class UsersPetFormInfo : DataObject
  {
    private int int_0;
    private int int_1;
    private int int_2;
    private string ecjQpMvwdo;

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

    public int PetsID
    {
      get => this.int_2;
      set
      {
        this.int_2 = value;
        this._isDirty = true;
      }
    }

    public string ActivePets
    {
      get => this.ecjQpMvwdo;
      set
      {
        this.ecjQpMvwdo = value;
        this._isDirty = true;
      }
    }
  }
}
