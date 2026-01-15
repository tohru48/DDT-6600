// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenTerrorBrotherNpc
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
  public class ThirteenTerrorBrotherNpc : ABrain
  {
    private int m_attackTurn = 0;
    private int isSay = 0;
    private int IsEixt = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private PhysicalObj wallLeft = (PhysicalObj) null;
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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 0);
      else if (this.m_attackTurn == 0)
      {
        this.Jump();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.JumpPersonalAttack();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.FallSummon();
        ++this.m_attackTurn;
      }
      else
      {
        this.Healing();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    public void JumpPersonalAttack()
    {
      this.Body.PlayMovie("walk", 0, 500);
      this.Body.JumpTo(this.Body.X, this.Body.Y - 150, "", 0, 1, new LivingCallBack(this.PersonalAttack));
      this.Body.SetRelateDemagemRect(-41, -107, 83, 100);
    }

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.SetRelateDemagemRect(-41, -107, 83, 100);
      this.Game.Random.Next(randomPlayer.X - 10, randomPlayer.Y + 20);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 54, 1000, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    public void Jump()
    {
      this.Body.PlayMovie("walk", 700, 0);
      this.Body.JumpTo(this.Body.X, this.Body.Y - 150, "", 1000, 1, new LivingCallBack(this.CreateChild));
      this.Body.SetRelateDemagemRect(-41, -107, 83, 100);
    }

    public void FallSummon()
    {
      this.Body.PlayMovie("walk", 700, 0);
      this.Body.FallFrom(this.Body.X, this.Body.Y + 150, "", 1000, 0, 50, new LivingCallBack(this.Summon));
      this.Body.SetRelateDemagemRect(-41, -107, 83, 100);
    }

    public void Summon()
    {
      this.Body.PlayMovie("call", 100, 0);
      this.wallLeft = ((PVEGame) this.Game).CreatePhysicalObj(1146, 566, "moive", "asset.game.ten.jitan", "beatA", 1, 0);
      this.Body.CallFuction(new LivingCallBack(this.Remove), 1000);
    }

    public void Remove()
    {
      if (this.m_moive != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive, true);
        this.m_moive = (PhysicalObj) null;
      }
      if (this.m_front == null)
        return;
      this.Game.RemovePhysicalObj(this.m_front, true);
      this.m_front = (PhysicalObj) null;
    }

    public void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ThirteenTerrorBrotherNpc.KillAttackChat.Length);
      this.Body.Say(ThirteenTerrorBrotherNpc.KillAttackChat[index], 1, 500);
      this.Body.PlayMovie("beatB", 2500, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 3300, (List<Player>) null);
    }

    public void Healing()
    {
      this.Body.SyncAtTime = true;
      this.Body.AddBlood(5000);
      this.Body.PlayMovie("castA", 100, 0);
      this.Body.Say("Hồi phục sức mạnh", 1, 0);
    }

    public void CreateChild()
    {
      this.Body.PlayMovie("call", 100, 0);
      this.m_moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(1146, 566, "moive", "asset.game.ten.jitan", "out", 1, 0);
      this.m_front = (PhysicalObj) ((PVEGame) this.Game).Createlayer(1146, 566, "font", "asset.game.ten.jitan", "out", 1, 0);
    }
  }
}
