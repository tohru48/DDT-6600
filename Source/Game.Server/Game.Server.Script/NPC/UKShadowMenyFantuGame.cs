// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.UKShadowMenyFantuGame
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class UKShadowMenyFantuGame : ABrain
  {
    private int m_attackTurn = 0;
    private int IntX = 0;
    private int IntY = 0;
    private PhysicalObj m_moive = (PhysicalObj) null;

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
      if (this.m_attackTurn == 0)
      {
        this.BeatB();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.BeatA();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.BeatC();
        ++this.m_attackTurn;
      }
      else
      {
        this.BeatA();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void BeatB()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.IntX = randomPlayer.X;
      this.IntY = randomPlayer.Y;
      if (this.IntX < 1000)
        this.Body.MoveTo(this.IntX + 350, this.IntY - 350, "fly", 1000, "fly", 11, new LivingCallBack(this.FlyB), 2500);
      else
        this.Body.MoveTo(this.IntX - 350, this.IntY - 350, "fly", 1000, "fly", 11, new LivingCallBack(this.FlyB), 2500);
    }

    private void FlyB()
    {
      this.Body.MoveTo(this.IntX, this.IntY - 350, "fly", 1000, "fly", 8, new LivingCallBack(this.ToBeatB));
    }

    private void ToBeatB()
    {
      this.Body.PlayMovie("beatB", 2000, 6750, new LivingCallBack(this.GoBeatB));
    }

    private void GoBeatB()
    {
      this.Body.RangeAttacking(this.IntX - 100, this.IntX + 100, "cry", 500, (List<Player>) null);
    }

    private void BeatC()
    {
      this.Body.MoveTo(this.Game.Random.Next(400, 1300), this.Game.Random.Next(300, 600), "fly", 1000, "fly", 8, new LivingCallBack(this.ToBeatC), 5000);
    }

    private void ToBeatC()
    {
      this.Body.PlayMovie("beatC", 2000, 6750, new LivingCallBack(this.GoBeatC));
    }

    private void GoBeatC()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.RangeAttacking(randomPlayer.X - 100, randomPlayer.X + 100, "cry", 500, (List<Player>) null);
    }

    private void BeatA()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.IntX = randomPlayer.X;
      this.IntY = randomPlayer.Y;
      if (this.IntX < 1000)
        this.Body.MoveTo(this.IntX + 350, this.IntY - 450, "fly", 1000, "fly", 11, new LivingCallBack(this.FlyA), 2500);
      else
        this.Body.MoveTo(this.IntX - 350, this.IntY - 450, "fly", 1000, "fly", 11, new LivingCallBack(this.FlyA), 2500);
    }

    private void FlyA()
    {
      this.Body.MoveTo(this.IntX, this.IntY - 400, "fly", 1000, "fly", 8, new LivingCallBack(this.ToBeatA));
    }

    private void ToBeatA()
    {
      this.Body.PlayMovie("beatA", 2000, 6750, new LivingCallBack(this.GoBeatA));
    }

    private void GoBeatA()
    {
      this.Body.RangeAttacking(this.IntX - 100, this.IntX + 100, "cry", 500, (List<Player>) null);
    }
  }
}
