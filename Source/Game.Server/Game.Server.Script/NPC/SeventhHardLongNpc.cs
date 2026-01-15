// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SeventhHardLongNpc
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
  public class SeventhHardLongNpc : ABrain
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
        if (allFightPlayer.IsLiving && allFightPlayer.X < 870)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, this.Body.X + 100);
      else if (this.m_attackTurn == 0)
      {
        this.AllAttack();
        ++this.m_attackTurn;
      }
      else
      {
        this.Move();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void Move()
    {
      this.Body.MoveTo(this.Game.Random.Next(600, 750), this.Body.Y, "walk", 1200, "", 3);
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 1f;
      this.Body.PlayMovie("beatB", 2000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3000, (List<Player>) null);
    }

    private void AllAttack()
    {
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 6000, (List<Player>) null);
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
  }
}
