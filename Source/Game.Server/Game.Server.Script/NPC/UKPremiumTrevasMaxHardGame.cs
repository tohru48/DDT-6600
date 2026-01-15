// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.UKPremiumTrevasMaxHardGame
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class UKPremiumTrevasMaxHardGame : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj m_wallRight = (PhysicalObj) null;
    private PhysicalObj m_wallLeft = (PhysicalObj) null;
    private int npcID = 14208;
    private PhysicalObj m_moive = (PhysicalObj) null;
    private static string[] BeatOneKillChat = new string[3]
    {
      "O inicio do tempo se incia, a grande chegada do fim de vocês",
      "O tempo aniquilará todos vocês...eu sou o rei do tempo ninguem pode contra eu, posso controlar tudo.",
      "Oh, senhor do espaço e tempo, peço que puna esses deliquentes!"
    };
    private static string[] ShootChat = new string[3]
    {
      "O inicio do tempo se incia, a grande chegada do fim de vocês",
      "O tempo aniquilará todos vocês...eu sou o rei do tempo ninguem pode contra eu, posso controlar tudo.",
      "Oh, senhor do espaço e tempo, peço que puna esses deliquentes!"
    };
    private static string[] ShootedChat = new string[3]
    {
      "O inicio do tempo se incia, a grande chegada do fim de vocês",
      "O tempo aniquilará todos vocês...eu sou o rei do tempo ninguem pode contra eu, posso controlar tudo.",
      "Oh, senhor do espaço e tempo, peço que puna esses deliquentes!"
    };
    private static string[] AddBooldChat = new string[3]
    {
      "O inicio do tempo se incia, a grande chegada do fim de vocês",
      "O tempo aniquilará todos vocês...eu sou o rei do tempo ninguem pode contra eu, posso controlar tudo.",
      "Oh, senhor do espaço e tempo, peço que puna esses deliquentes!"
    };
    private static string[] KillAttackChat = new string[3]
    {
      "O inicio do tempo se incia, a grande chegada do fim de vocês",
      "O tempo aniquilará todos vocês...eu sou o rei do tempo ninguem pode contra eu, posso controlar tudo.",
      "Oh, senhor do espaço e tempo, peço que puna esses deliquentes!"
    };

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
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        return;
      if (this.m_attackTurn == 0)
      {
        this.BeatE();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.CallNpc();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Body.MoveTo(this.Game.Random.Next(400, 1300), 600, "fly", 0, "", 10, new LivingCallBack(this.AllAttack));
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.BeatE();
        ++this.m_attackTurn;
      }
      else
      {
        this.CallNpc();
        this.m_attackTurn = 0;
      }
    }

    private void BeatE()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.MoveTo(this.Game.Random.Next(randomPlayer.X - 50, randomPlayer.X + 50), this.Game.Random.Next(randomPlayer.Y - 100, randomPlayer.Y - 100), "fly", 1000, "", 10, new LivingCallBack(this.BeatOneKill));
    }

    private void BeatOneKill()
    {
      int index = this.Game.Random.Next(0, UKPremiumTrevasMaxHardGame.BeatOneKillChat.Length);
      this.Body.Say(UKPremiumTrevasMaxHardGame.BeatOneKillChat[index], 1, 0);
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatE", 3000, 0);
      this.Body.RangeAttacking(this.Body.X - 100, this.Body.X + 100, "cry", 5000, (List<Player>) null);
    }

    private void CallNpc()
    {
      this.Body.MoveTo(this.Game.Random.Next(500, 1200), this.Game.Random.Next(400, 600), "fly", 1000, "", 10, new LivingCallBack(this.CallMohang));
    }

    private void CallMohang()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatB", 3300, 4000);
      this.Body.CallFuction(new LivingCallBack(this.GoCallMohang), 3500);
    }

    private void GoCallMohang()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      int x = this.Game.Random.Next(700, 1300);
      if (this.Game.GetLivedLivings().Count <= 1)
        ((SimpleBoss) this.Body).CreateChild(this.npcID, x, 680, -1, 1, 1);
      if (this.Game.GetLivedLivings().Count <= 1)
        return;
      ((SimpleBoss) this.Body).CreateChild(this.npcID, x, 680, -1, 100, 2);
    }

    private void AllAttack()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("beatA", 3200, 0);
      this.Body.CallFuction(new LivingCallBack(this.In), 3400);
    }

    private void In()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.m_moive = ((PVEGame) this.Game).CreatePhysicalObj(1000, 400, "moive", "asset.game.4.zap", "out", 2, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Out), 2500);
    }

    private void ProtectingWall()
    {
      this.m_wallLeft = ((PVEGame) this.Game).CreatePhysicalObj(this.Body.X - 40, 600, "wallLeft", "com.mapobject.asset.WaveAsset_01_left", "1", 1, 0);
      this.m_wallRight = ((PVEGame) this.Game).CreatePhysicalObj(this.Body.X + 40, 600, "wallLeft", "com.mapobject.asset.WaveAsset_01_right", "1", 1, 0);
      this.m_wallLeft.SetRect(-165, -169, 3, 330);
      this.m_wallRight.SetRect(128, 165, 3, 330);
    }

    private void Out()
    {
      this.m_moive.CanPenetrate = true;
      this.Game.RemovePhysicalObj(this.m_moive, true);
    }
  }
}
