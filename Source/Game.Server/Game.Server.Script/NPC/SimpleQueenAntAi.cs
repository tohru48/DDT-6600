// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.SimpleQueenAntAi
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
  public class SimpleQueenAntAi : ABrain
  {
    private int m_attackTurn = 0;
    private int npcID = 2004;
    private int isSay = 0;
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
        if (this.Game.GetLivedLivings().Count == 9)
          this.PersonalAttack();
        else
          this.Summon();
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
      int index = this.Game.Random.Next(0, SimpleQueenAntAi.KillAttackChat.Length);
      this.Body.Say(SimpleQueenAntAi.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 0.8f;
      int index = this.Game.Random.Next(0, SimpleQueenAntAi.ShootChat.Length);
      this.Body.Say(SimpleQueenAntAi.ShootChat[index], 1, 0);
      this.Game.Random.Next(670, 880);
      this.Game.Random.Next(randomPlayer.X - 10, randomPlayer.X + 10);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, ((SimpleBoss) this.Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    private void Summon()
    {
      int index = this.Game.Random.Next(0, SimpleQueenAntAi.CallChat.Length);
      this.Body.Say(SimpleQueenAntAi.CallChat[index], 1, 600);
      this.Body.PlayMovie("call", 1700, 2000, new LivingCallBack(this.Call));
      this.Body.CallFuction(new LivingCallBack(this.Call), 2000);
    }

    private void Call()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID, this.brithPoint, 9, 3, 9, -1);
    }

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, SimpleQueenAntAi.KillPlayerChat.Length);
      this.Body.Say(SimpleQueenAntAi.KillPlayerChat[index], 1, 0, 2000);
    }

    public override void OnDiedSay()
    {
    }

    private void CreateChild()
    {
    }

    public override void OnShootedSay()
    {
      int index1 = this.Game.Random.Next(0, SimpleQueenAntAi.ShootedChat.Length);
      if (this.isSay == 0 && this.Body.IsLiving)
      {
        this.Body.Say(SimpleQueenAntAi.ShootedChat[index1], 1, 900, 0);
        this.isSay = 1;
      }
      if (this.Body.IsLiving)
        return;
      int index2 = this.Game.Random.Next(0, SimpleQueenAntAi.DiedChat.Length);
      this.Body.Say(SimpleQueenAntAi.DiedChat[index2], 1, 100, 2000);
    }
  }
}
