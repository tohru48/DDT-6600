// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdHardFagNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirdHardFagNpc : ABrain
  {
    private Player m_target = (Player) null;
    private int m_targetDis = 0;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      foreach (Living allLivingPlayer in this.Game.GetAllLivingPlayers())
        allLivingPlayer.AddEffect((AbstractEffect) new ReduceStrengthEffect(2, 50), 0);
    }

    public override void OnStopAttacking()
    {
      base.OnStopAttacking();
      foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
      {
        this.Body.Say("Haha, tôi là đầy sức mạnh!", 1, 0);
        allLivingPlayer.EffectList.Remove((AbstractEffect) null);
      }
    }
  }
}
