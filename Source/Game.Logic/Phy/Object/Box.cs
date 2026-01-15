// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.Box
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using SqlDataProvider.Data;
using System.Drawing;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class Box : PhysicalObj
  {
    private int int_5;
    private int int_6;
    private ItemInfo LagIolUumH;

    public int UserID
    {
      get => this.int_5;
      set => this.int_5 = value;
    }

    public int LiveCount
    {
      get => this.int_6;
      set => this.int_6 = value;
    }

    public ItemInfo Item => this.LagIolUumH;

    public override int Type => 1;

    public Box(int id, string model, ItemInfo item)
      : base(id, "", model, "", 1, 1)
    {
      this.int_5 = 0;
      this.m_rect = new Rectangle(-15, -15, 30, 30);
      this.LagIolUumH = item;
    }

    public override void CollidedByObject(Physics phy)
    {
      if (!(phy is SimpleBomb))
        return;
      (phy as SimpleBomb).Owner.PickBox(this);
    }
  }
}
