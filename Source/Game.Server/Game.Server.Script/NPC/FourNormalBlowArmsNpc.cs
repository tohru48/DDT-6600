// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FourNormalBlowArmsNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class FourNormalBlowArmsNpc : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj m_moive = (PhysicalObj) null;

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      if (this.m_attackTurn == 0)
      {
        this.MoveToGate();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.MoveToGate();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.MoveToGate();
        ++this.m_attackTurn;
      }
      else
      {
        this.MoveToExit();
        this.m_attackTurn = 0;
      }
    }

    private void MoveToGate()
    {
      this.Body.MoveTo(this.Body.X + this.Game.Random.Next(250, 300), this.Body.Y, "walk", 2000, "", 4, new LivingCallBack(this.CanDie));
    }

    private void MoveToExit()
    {
      this.Body.MoveTo(1415, this.Body.Y, "walk", 2000, "", 4, new LivingCallBack(this.BeatA));
    }

    private void CanDie()
    {
      if (this.Body.Blood <= 50)
      {
        this.Body.PlayMovie("die", 100, 0);
        this.Body.Die(1000);
      }
      else
      {
        this.Body.AddEffect((AbstractEffect) new ContinueReduceBloodEffect(2, this.Game.Random.Next(789, 1021), this.Body), 0);
        this.Body.PlayMovie("standB", 100, 0);
      }
    }

    private void BeatA()
    {
      this.Body.PlayMovie("beatA", 100, 0);
      if (this.Body.FindCount == 0)
        this.Body.CallFuction(new LivingCallBack(this.CryA), 2900);
      else if (this.Body.FindCount == 1)
        this.Body.CallFuction(new LivingCallBack(this.CryB), 2900);
      else
        this.Body.CallFuction(new LivingCallBack(this.CryC), 2900);
      this.Body.Die(3000);
    }

    private void CryA()
    {
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(1590, 750, "moive", "game.asset.Gate", "cryA", 1, 0);
      this.Body.FindCount = 3;
    }

    private void CryB()
    {
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(1590, 750, "moive", "game.asset.Gate", "cryB", 1, 0);
      this.Body.FindCount = 2;
    }

    private void CryC()
    {
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(1590, 750, "moive", "game.asset.Gate", "cryC", 1, 0);
      this.Body.FindCount = 3;
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
