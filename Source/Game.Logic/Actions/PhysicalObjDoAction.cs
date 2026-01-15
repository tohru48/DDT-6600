// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.PhysicalObjDoAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class PhysicalObjDoAction : BaseAction
  {
    private PhysicalObj physicalObj_0;
    private string string_0;

    public PhysicalObjDoAction(PhysicalObj obj, string action, int delay, int movieTime)
      : base(delay, movieTime)
    {
      this.physicalObj_0 = obj;
      this.string_0 = action;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      this.physicalObj_0.CurrentAction = this.string_0;
      game.method_17(this.physicalObj_0);
      this.Finish(tick);
    }
  }
}
