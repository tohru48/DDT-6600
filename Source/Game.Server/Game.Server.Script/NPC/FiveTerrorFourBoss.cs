// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.FiveTerrorFourBoss
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
  public class FiveTerrorFourBoss : ABrain
  {
    private int m_attackTurn = 0;
    private int npcID = 5332;
    private int isSay = 0;
    private int m_maxBlood;
    private int m_blood;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private static string[] AllAttackChat = new string[3]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg1"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg2"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg3")
    };
    private static string[] ShootChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg4"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg5")
    };
    private static string[] KillPlayerChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg6"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg7")
    };
    private static string[] CallChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg8"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg9")
    };
    private static string[] JumpChat = new string[3]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg10"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg11"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg12")
    };
    private static string[] KillAttackChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg13"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg14")
    };
    private static string[] ShootedChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg15"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg16")
    };
    private static string[] DiedChat = new string[1]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.NormalQueenAntAi.msg17")
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1500 && allFightPlayer.X < this.Game.Map.Info.ForegroundWidth + 1)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(1500, this.Game.Map.Info.ForegroundWidth + 1);
      else if (this.m_attackTurn == 0)
      {
        this.BeatE();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.AllAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
        ++this.m_attackTurn;
      else if (this.m_attackTurn == 3)
      {
        this.AllAttack2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 4)
      {
        this.Dame();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 5)
      {
        this.Summon();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 6)
      {
        this.AtoB();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 7)
      {
        this.AtoB();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 8)
      {
        this.Born();
        ++this.m_attackTurn;
      }
      else
      {
        this.PersonalAttack();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, FiveTerrorFourBoss.KillAttackChat.Length);
      this.Body.Say(FiveTerrorFourBoss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void Born()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("born", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
    }

    private void BeatE()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatE", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
    }

    private void AllAttack() => this.Body.PlayMovie("beatA", 1000, 3000);

    private void AllAttack2()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatB", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
    }

    private void Dame()
    {
      this.Body.PlayMovie("beatD", 1000, 3000);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
      foreach (Player allLivingPlayer in this.Game.GetAllLivingPlayers())
      {
        allLivingPlayer.MoveTo(allLivingPlayer.X - 400, this.Body.Y, "run", 0, "", 3);
        this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(allLivingPlayer.X, allLivingPlayer.Y, "moive", "asset.game.4.tang", "out", 1, 0);
      }
    }

    private void PersonalAttack()
    {
      this.Body.PlayMovie("beatC", 3000, 5000);
      this.Body.CallFuction(new LivingCallBack(this.OnPersonalAttack), 3000);
    }

    private void OnPersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Game.Random.Next(randomPlayer.Y + 10, randomPlayer.Y + 10);
      if (this.Body.Shoot(0, randomPlayer.X, randomPlayer.Y, 66, 66, 1, 2550))
        this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(randomPlayer.X, randomPlayer.Y, "moive", "asset.game.4.guang", "out", 1, 0);
    }

    private void Summon()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      this.Body.PlayMovie("beatE", 1000, 0);
      this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.Call), 4000);
    }

    private void AtoB() => this.Body.PlayMovie(nameof (AtoB), 1700, 2000);

    public void Call() => ((SimpleBoss) this.Body).CreateChild(this.npcID, 1000, 530, 430, 1, -1);
  }
}
