// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.WorldBatKing
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class WorldBatKing : ABrain
  {
    private int m_attackTurn = 0;
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
      if (this.Body.State == 10)
        this.KillAttack(0, this.Game.Map.Info.ForegroundWidth + 1);
      else if (this.m_attackTurn == 0)
      {
        this.AttackA();
        ++this.m_attackTurn;
      }
      else
      {
        this.AttackB(0, this.Game.Map.Info.ForegroundWidth + 1);
        this.m_attackTurn = 0;
      }
    }

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, WorldBatKing.KillAttackChat.Length);
      this.Body.Say(WorldBatKing.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 100f;
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void AttackA()
    {
      this.Body.MoveTo(this.Game.Random.Next(173, 1439), this.Game.Random.Next(150, 700), "fly", 3000, "", 12, new LivingCallBack(this.AllAttackA));
    }

    private void AllAttackA()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, WorldBatKing.ShootChat.Length);
      this.Body.Say(WorldBatKing.ShootChat[index], 1, 0);
      this.Body.PlayMovie("beatA", 1700, 0);
      this.Body.RangeAttacking(0, this.Game.Map.Info.ForegroundWidth + 1, "cry", 4000, (List<Player>) null);
    }

    private void AttackB(int fx, int tx)
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 15f;
      int index = this.Game.Random.Next(0, WorldBatKing.ShootChat.Length);
      this.Body.Say(WorldBatKing.ShootChat[index], 1, 0);
      this.Body.PlayMovie("beatB", 1900, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 4000);
    }

    private void GoMovie()
    {
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        ;
      this.Body.CallFuction(new LivingCallBack(this.ShowIn), 2000);
    }

    private void ShowIn() => this.Body.PlayMovie("in", 100, 0);

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, WorldBatKing.KillPlayerChat.Length);
      this.Body.Say(WorldBatKing.KillPlayerChat[index], 1, 0, 2000);
    }
  }
}
