// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.MarryProp
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class MarryProp
  {
    private bool WjmlCceuyQ;
    private int int_0;
    private string string_0;
    private bool bool_0;
    private int int_1;
    private bool bool_1;

    public bool IsMarried
    {
      get => this.WjmlCceuyQ;
      set => this.WjmlCceuyQ = value;
    }

    public int SpouseID
    {
      get => this.int_0;
      set => this.int_0 = value;
    }

    public string SpouseName
    {
      get => this.string_0;
      set => this.string_0 = value;
    }

    public bool IsCreatedMarryRoom
    {
      get => this.bool_0;
      set => this.bool_0 = value;
    }

    public int SelfMarryRoomID
    {
      get => this.int_1;
      set => this.int_1 = value;
    }

    public bool IsGotRing
    {
      get => this.bool_1;
      set => this.bool_1 = value;
    }
  }
}
