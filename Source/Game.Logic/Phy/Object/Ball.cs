// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.Ball
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System.Drawing;

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class Ball : PhysicalObj
  {
    private int int_5;

    public int LiveCount
    {
      get => this.int_5;
      set => this.int_5 = value;
    }

    public override int Type => 2;

    public Ball(int id, string action)
      : base(id, "", "asset.game.six.ball", action, 1, 1)
    {
      this.m_rect = new Rectangle(-15, -15, 30, 30);
    }

    public override void CollidedByObject(Physics phy)
    {
      if (!(phy is SimpleBomb))
        return;
      (phy as SimpleBomb).Owner.PickBall(this);
    }
  }
}
