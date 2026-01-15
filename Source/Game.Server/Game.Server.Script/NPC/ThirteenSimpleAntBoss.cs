// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenSimpleAntBoss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirteenSimpleAntBoss : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj moive;
    private PhysicalObj k_moive;
    private PhysicalObj m_moive;
    private int isSay = 0;
    private static string[] AllAttackChat = new string[3]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg1"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg2"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg3")
    };
    private static string[] ShootChat = new string[2]
    {
      LanguageMgr.GetTranslation("Nén nhẹ mũi tên của ta đây !"),
      LanguageMgr.GetTranslation("Hãy nén thử mũi tên băng này đi !")
    };
    private static string[] KillPlayerChat = new string[2]
    {
      LanguageMgr.GetTranslation("Nén nhẹ mũi tên của ta đây !"),
      LanguageMgr.GetTranslation("Đón nhận mũi tên thần kì !")
    };
    private static string[] CallChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg8"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg9")
    };
    private static string[] JumpChat = new string[3]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg10"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg11"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg12")
    };
    private static string[] KillAttackChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg13"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg14")
    };
    private static string[] ShootedChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg15"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg16")
    };
    private static string[] DiedChat = new string[1]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg17")
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.isSay = 0;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1169 && allFightPlayer.X < this.Game.Map.Info.ForegroundWidth + 1)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(1169, this.Game.Map.Info.ForegroundWidth + 1);
      else if (this.m_attackTurn == 0)
      {
        this.PersonalAttack2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Healing();
        this.Plain();
        ++this.m_attackTurn;
      }
      else
      {
        this.PersonalAttack();
        this.m_attackTurn = 0;
      }
    }

    private void Healing()
    {
      this.Body.SyncAtTime = true;
      if (this.Game.GetDiedBossCount() != 0)
        return;
      this.Body.AddBlood(15000);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, ThirteenSimpleAntBoss.KillAttackChat.Length);
      this.Body.Say(ThirteenSimpleAntBoss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3000, (List<Player>) null);
    }

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 2.8f;
      int index = this.Game.Random.Next(0, ThirteenSimpleAntBoss.KillPlayerChat.Length);
      this.Body.Say(ThirteenSimpleAntBoss.KillPlayerChat[index], 1, 0);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 51, 1400, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    private void Plain()
    {
      int index = this.Game.Random.Next(0, ThirteenSimpleAntBoss.ShootChat.Length);
      this.Body.Say(ThirteenSimpleAntBoss.ShootChat[index], 1, 0);
      this.Body.CurrentDamagePlus = 1.8f;
      Player[] allPlayers = this.Game.GetAllPlayers();
      int num = 0;
      foreach (Player player in allPlayers)
      {
        if (player != null && this.Body.ShootPoint(player.X, player.Y, 99, 1000, 10000, 1, 2.7f, 3000))
          this.Body.PlayMovie("beatD", 1500, 0);
        ++num;
        if (num == 2)
          break;
      }
    }

    private void PersonalAttack2()
    {
      int index = this.Game.Random.Next(0, ThirteenSimpleAntBoss.KillPlayerChat.Length);
      this.Body.Say(ThirteenSimpleAntBoss.KillPlayerChat[index], 1, 0);
      this.Body.PlayMovie("beatC", 3500, 0);
      this.Body.CallFuction(new LivingCallBack(this.GoShoot), 4000);
    }

    private void GoShoot()
    {
      this.Body.CurrentDamagePlus = 4.8f;
      foreach (Player allPlayer in this.Game.GetAllPlayers())
      {
        this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(allPlayer.X, allPlayer.Y, "moive", "asset.game.ten.jianyu", "out", 1, 1);
        this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 1000, (List<Player>) null);
      }
      this.Body.CallFuction(new LivingCallBack(this.GoOut), 2000);
    }

    private void GoOut()
    {
      if (this.moive == null)
        return;
      this.Game.RemovePhysicalObj(this.moive, true);
      this.moive = (PhysicalObj) null;
    }

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, ThirteenSimpleAntBoss.KillPlayerChat.Length);
      this.Body.Say(ThirteenSimpleAntBoss.KillPlayerChat[index], 1, 0, 2000);
    }

    private void CreateChild()
    {
    }

    public override void OnShootedSay()
    {
      int index1 = this.Game.Random.Next(0, ThirteenSimpleAntBoss.ShootedChat.Length);
      if (this.isSay == 0 && this.Body.IsLiving)
      {
        this.Body.Say(ThirteenSimpleAntBoss.ShootedChat[index1], 1, 900, 0);
        this.isSay = 1;
      }
      if (this.Body.IsLiving)
        return;
      int index2 = this.Game.Random.Next(0, ThirteenSimpleAntBoss.DiedChat.Length);
      this.Body.Say(ThirteenSimpleAntBoss.DiedChat[index2], 1, 100, 2000);
    }
  }
}
