// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirteenSimpleBrotherNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Effects;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirteenSimpleBrotherNpc : ABrain
  {
    private int m_attackTurn = 0;
    private PhysicalObj m_moive;
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
      if (this.m_attackTurn == 0)
      {
        this.CallBuff();
        ++this.m_attackTurn;
      }
      else
      {
        this.PersonalAttack();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void PersonalAttack()
    {
      bool flag = false;
      Player[] allPlayers = this.Game.GetAllPlayers();
      List<Player> players = new List<Player>();
      foreach (Player player in allPlayers)
      {
        if (player.X > 990 && player.X < 1315 && player.Y < 606)
        {
          flag = true;
          players.Add(player);
          break;
        }
      }
      if (flag)
      {
        foreach (Player player in allPlayers)
        {
          player.AddEffect((AbstractEffect) new DamageEffect(2), 0);
          player.AddEffect((AbstractEffect) new GuardEffect(2), 0);
        }
      }
      this.Body.RangeAttacking(920, 1370, "cry", 1000, players);
      this.Body.PlayMovie("call", 1000, 1000);
      this.Body.CallFuction(new LivingCallBack(this.Remove), 1000);
    }

    public void CallBuff()
    {
      this.Body.JumpTo(this.Body.X, this.Body.Y - 300, "walk", 2000, -1);
      this.Body.PlayMovie("call", 1000, 1000);
      this.Body.CallFuction(new LivingCallBack(this.CreateMovie), 1000);
    }

    public void Remove()
    {
      if (this.m_moive == null)
        return;
      this.m_moive.PlayMovie("beatA", 1000, 1000);
    }

    public void CreateMovie()
    {
      this.m_moive = ((PVEGame) this.Game).CreatePhysicalObj(1146, 566, "moiveA", "asset.game.ten.jitan", "born", 1, 0);
    }
  }
}
