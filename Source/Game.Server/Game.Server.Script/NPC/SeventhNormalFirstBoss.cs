// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SeventhNormalFirstBoss
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
  public class SeventhNormalFirstBoss : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj moive;
    private static string[] AllAttackChat = new string[1]
    {
      LanguageMgr.GetTranslation("Ddtank super là số 1")
    };
    private static string[] ShootChat = new string[1]
    {
      LanguageMgr.GetTranslation("Anh em tiến lên !")
    };
    private static string[] KillPlayerChat = new string[1]
    {
      LanguageMgr.GetTranslation("Anh em tiến lên !")
    };
    private static string[] CallChat = new string[1]
    {
      LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !")
    };
    private static string[] JumpChat = new string[1]
    {
      LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !")
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
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1344)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(1344, this.Game.Map.Info.ForegroundWidth + 1);
      else if (this.m_attackTurn == 0)
      {
        this.Summon(0);
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Shield();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Summon(1);
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.Shield();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 4)
      {
        this.Summon(2);
        ++this.m_attackTurn;
      }
      else
      {
        this.Shield();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, SeventhNormalFirstBoss.KillAttackChat.Length);
      this.Body.Say(SeventhNormalFirstBoss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    public void Summon(int type)
    {
      this.Body.PlayMovie("Ato", 100, 0);
      this.Body.SetRelateDemagemRect(-56, -122, 124, 129);
      switch (type)
      {
        case 1:
          this.Body.CallFuction(new LivingCallBack(this.PersonalAttackDame), 2500);
          break;
        case 2:
          this.Body.CallFuction(new LivingCallBack(this.AllAttack), 2500);
          break;
        default:
          this.Body.CallFuction(new LivingCallBack(this.PersonalAttack), 2500);
          break;
      }
    }

    private void AllAttack()
    {
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(0, this.Body.X, "cry", 6000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 5000);
    }

    private void GoMovie()
    {
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(allFightPlayer.X, allFightPlayer.Y, "moive", "asset.game.seven.cao", "out", 1, 0);
        this.moive.PlayMovie("in", 1000, 0);
      }
    }

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 1f;
      this.Game.Random.Next(randomPlayer.X, randomPlayer.X);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 84, 1200, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    public void Shield()
    {
      this.Body.State = 1;
      this.Body.PlayMovie("toA", 2700, 0);
      this.Body.SetRelateDemagemRect(0, 0, 124, 129);
    }

    private void PersonalAttackDame()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 1.2f;
      this.Game.Random.Next(randomPlayer.X, randomPlayer.X);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 84, 1200, 10000, 1, 3f, 2650))
        this.Body.PlayMovie("beat", 1700, 0);
    }
  }
}
