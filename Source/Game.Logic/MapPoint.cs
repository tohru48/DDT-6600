// Decompiled with JetBrains decompiler
// Type: Game.Logic.MapPoint
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using System.Collections.Generic;
using System.Drawing;

#nullable disable
namespace Game.Logic
{
  public class MapPoint
  {
    private List<Point> list_0;
    private List<Point> list_1;

    public List<Point> PosX
    {
      get => this.list_0;
      set => this.list_0 = value;
    }

    public List<Point> PosX1
    {
      get => this.list_1;
      set => this.list_1 = value;
    }

    public MapPoint()
    {
      this.list_0 = new List<Point>();
      this.list_1 = new List<Point>();
    }
  }
}
