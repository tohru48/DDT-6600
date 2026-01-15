// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.DCSM40022Boss
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;
using System.Drawing;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class DCSM40022Boss : ABrain
  {
    private int m_attackTurn = 0;
    private Point[] brithPoint = new Point[5]
    {
      new Point(979, 630),
      new Point(1013, 630),
      new Point(1052, 630),
      new Point(1088, 630),
      new Point(1142, 630)
    };
    private static string[] AllAttackChat = new string[3]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg1"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg2"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg3")
    };
    private static string[] ShootChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg4"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg5")
    };
    private static string[] KillPlayerChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg6"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg7")
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
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1000)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (this.m_attackTurn == 0)
      {
        this.PersonalAttackC();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.PersonalAttackE();
        ++this.m_attackTurn;
      }
      else
      {
        this.KillAttack();
        this.m_attackTurn = 0;
      }
    }

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, DCSM40022Boss.KillAttackChat.Length);
      this.Body.Say(DCSM40022Boss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 100f;
      this.Body.PlayMovie("beatF", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void KillAttack()
    {
      if (this.Game.FindRandomPlayer() == null)
        return;
      int index = this.Game.Random.Next(0, DCSM40022Boss.KillAttackChat.Length);
      this.Body.Say(DCSM40022Boss.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 15f;
      this.Body.PlayMovie("beatF", 3000, 0);
      this.Body.RangeAttacking(0, this.Body.X + 1000, "cry", 5000, (List<Player>) null);
    }

    private void PersonalAttackC()
    {
      if (this.Game.FindRandomPlayer() == null)
        return;
      this.Body.CurrentDamagePlus = 5f;
      int index = this.Game.Random.Next(0, DCSM40022Boss.ShootChat.Length);
      this.Body.Say(DCSM40022Boss.ShootChat[index], 1, 0);
      this.Game.Random.Next(0, 1200);
      this.Body.PlayMovie("beatC", 1700, 0);
      this.Body.RangeAttacking(0, this.Body.X + 1000, "cry", 4000, (List<Player>) null);
    }

    private void PersonalAttackE()
    {
      if (this.Game.FindRandomPlayer() == null)
        return;
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, DCSM40022Boss.ShootChat.Length);
      this.Body.Say(DCSM40022Boss.ShootChat[index], 1, 0);
      this.Game.Random.Next(0, 1200);
      this.Body.PlayMovie("beatE", 1700, 0);
      this.Body.RangeAttacking(0, this.Body.X + 1000, "cry", 4000, (List<Player>) null);
    }
  }
}
