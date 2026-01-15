// Decompiled with JetBrains decompiler
// Type: Game.Logic.MacroDropInfo
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic
{
  public class MacroDropInfo
  {
    public int SelfDropCount { get; set; }

    public int DropCount { get; set; }

    public int MaxDropCount { get; set; }

    public MacroDropInfo(int dropCount, int maxDropCount)
    {
      this.DropCount = dropCount;
      this.MaxDropCount = maxDropCount;
    }
  }
}
