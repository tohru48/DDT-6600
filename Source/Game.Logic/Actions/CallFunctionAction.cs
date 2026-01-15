// Decompiled with JetBrains decompiler
// Type: Game.Logic.Actions.CallFunctionAction
// Assembly: Game.Logic, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 16473518-7959-4BC8-9F81-7B522E44CF86
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\Game.Logic.dll

using Game.Logic.Phy.Object;

#nullable disable
namespace Game.Logic.Actions
{
  public class CallFunctionAction : BaseAction
  {
    private LivingCallBack livingCallBack_0;

    public CallFunctionAction(LivingCallBack func, int delay)
      : base(delay)
    {
      this.livingCallBack_0 = func;
    }

    protected override void ExecuteImp(BaseGame game, long tick)
    {
      try
      {
        this.livingCallBack_0();
      }
      finally
      {
        this.Finish(tick);
      }
    }
  }
}
