// Decompiled with JetBrains decompiler
// Type: Game.Logic.LoadingFileInfo
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

#nullable disable
namespace Game.Logic
{
  public class LoadingFileInfo
  {
    public int Type;
    public string Path;
    public string ClassName;

    public LoadingFileInfo(int type, string path, string className)
    {
      this.Type = type;
      this.Path = path;
      this.ClassName = className;
    }
  }
}
