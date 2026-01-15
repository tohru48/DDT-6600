// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.DataObject
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class DataObject
  {
    protected bool _isDirty;

    public bool IsDirty
    {
      get => this._isDirty;
      set => this._isDirty = value;
    }
  }
}
