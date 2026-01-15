// Decompiled with JetBrains decompiler
// Type: SqlDataProvider.Data.BallInfo
// Assembly: SqlDataProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 391B44B0-7156-4E7E-BFB9-FB413BF28D88
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\SqlDataProvider.dll

#nullable disable
namespace SqlDataProvider.Data
{
  public class BallInfo
  {
    public int ID { get; set; }

    public string Name { get; set; }

    public string Crater { get; set; }

    public int AttackResponse { get; set; }

    public double Power { get; set; }

    public int Radii { get; set; }

    public int Amount { get; set; }

    public string FlyingPartical { get; set; }

    public string BombPartical { get; set; }

    public bool IsSpin { get; set; }

    public int Mass { get; set; }

    public double SpinVA { get; set; }

    public int SpinV { get; set; }

    public int Wind { get; set; }

    public int DragIndex { get; set; }

    public int Weight { get; set; }

    public bool Shake { get; set; }

    public int Delay { get; set; }

    public string ShootSound { get; set; }

    public string BombSound { get; set; }

    public int ActionType { get; set; }

    public bool HasTunnel { get; set; }

    public bool IsSpecial()
    {
      int id = this.ID;
      if (id <= 64)
      {
        if (id <= 16)
        {
          switch (id - 1)
          {
            case 0:
            case 2:
            case 4:
              return true;
            case 1:
            case 3:
              break;
            default:
              if (id == 16)
                return true;
              break;
          }
        }
        else if (id == 59 || id == 64)
          return true;
      }
      else if (id <= 110)
      {
        switch (id - 97)
        {
          case 0:
          case 1:
            return true;
          default:
            if (id == 110)
              return true;
            break;
        }
      }
      else
      {
        if (id == 117)
          return true;
        switch (id - 10001)
        {
          case 0:
          case 1:
          case 2:
          case 3:
          case 4:
          case 5:
          case 6:
          case 7:
          case 8:
          case 9:
          case 10:
          case 11:
          case 12:
          case 13:
          case 14:
          case 15:
          case 16:
          case 17:
          case 18:
          case 19:
            return true;
        }
      }
      return false;
    }
  }
}
