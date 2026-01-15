// Decompiled with JetBrains decompiler
// Type: Game.Logic.Phy.Object.CanShootInfo
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic.Phy.Object
{
  public class CanShootInfo
  {
    private bool bool_0;
    private int int_0;
    private int int_1;

    public bool CanShoot => this.bool_0;

    public int Force => this.int_0;

    public int Angle => this.int_1;

    public CanShootInfo(bool canShoot, int force, int angle)
    {
      this.bool_0 = canShoot;
      this.int_0 = force;
      this.int_1 = angle;
    }
  }
}
