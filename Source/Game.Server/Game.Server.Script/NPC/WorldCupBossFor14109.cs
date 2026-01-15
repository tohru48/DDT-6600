// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.WorldCupBossFor14109
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
  public class WorldCupBossFor14109 : ABrain
  {
    private int m_attackTurn = 0;
    private int isSay = 0;
    private PhysicalObj moive;
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
    private int npcID = 14108;
    private SimpleNpc arbiNpc = (SimpleNpc) null;

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
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1155 && allFightPlayer.X < 1571)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
      {
        this.KillAttack(0, this.Game.Map.Info.ForegroundWidth + 1);
      }
      else
      {
        if (!this.Body.Config.IsShield && this.Body.Blood > 1)
          return;
        this.arbiNpc = this.Game.FindHelper();
        if (this.m_attackTurn == 0)
        {
          this.AttackB(0, this.Game.Map.Info.ForegroundWidth + 1);
          ++this.m_attackTurn;
        }
        else if (this.m_attackTurn == 1)
        {
          this.AttackA(0, this.Game.Map.Info.ForegroundWidth + 1);
          ++this.m_attackTurn;
        }
        else if (this.m_attackTurn == 2)
        {
          this.AttackC(0, this.Game.Map.Info.ForegroundWidth + 1);
          ++this.m_attackTurn;
        }
        else if (this.m_attackTurn == 3)
        {
          this.GoOutGoal();
          ++this.m_attackTurn;
        }
        else
        {
          this.ComeBackGoal();
          this.m_attackTurn = 0;
        }
      }
    }

    private void GoOutGoal()
    {
      this.Body.MoveTo(1152, 861, "walk", 1000, "", 3, new LivingCallBack(this.OnDown));
    }

    private void OnDown()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.Body, 0, 2000);
      this.Body.SetRelateDemagemRect(-15, -35, 35, 35);
      this.Body.PlayMovie("cryB", 2000, 0);
      ((TurnedLiving) this.Body).AddDelay(1000);
      this.Body.Config.IsDown = true;
    }

    private void ComeBackGoal()
    {
      this.Body.MoveTo(1223, 861, "walk", 1000, "", 3, new LivingCallBack(this.OnUp));
    }

    private void OnUp()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Body.PlayMovie("standB", 2000, 0);
      this.Body.AddBlood(((SimpleBoss) this.Body).NpcInfo.Blood);
      this.Body.Config.IsShield = true;
      ((PVEGame) this.Game).CanBeginNextProtect = true;
      this.Body.Config.IsDown = false;
      this.Body.SetRelateDemagemRect(((SimpleBoss) this.Body).NpcInfo.X, ((SimpleBoss) this.Body).NpcInfo.Y, ((SimpleBoss) this.Body).NpcInfo.Width, ((SimpleBoss) this.Body).NpcInfo.Height);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, WorldCupBossFor14109.KillAttackChat.Length);
      this.Body.Say(WorldCupBossFor14109.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 100f;
      this.Body.PlayMovie("beatD", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void AttackA(int fx, int tx)
    {
      if (this.Game.FindRandomPlayer() == null)
        return;
      this.Body.CurrentDamagePlus = 1.3f;
      int index = this.Game.Random.Next(0, WorldCupBossFor14109.ShootChat.Length);
      this.Body.Say(WorldCupBossFor14109.ShootChat[index], 1, 0);
      this.Game.Random.Next(0, 1200);
      this.Body.PlayMovie("beatA", 1700, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void AttackB(int fx, int tx)
    {
      if (this.Game.FindRandomPlayer() == null)
        return;
      this.Body.CurrentDamagePlus = 1.7f;
      int index = this.Game.Random.Next(0, WorldCupBossFor14109.ShootChat.Length);
      this.Body.Say(WorldCupBossFor14109.ShootChat[index], 1, 0);
      this.Game.Random.Next(0, 1200);
      this.Body.PlayMovie("beatB", 1900, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
      this.Body.CallFuction(new LivingCallBack(this.GoMovie), 4000);
    }

    private void GoMovie()
    {
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        this.moive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(allFightPlayer.X, allFightPlayer.Y, "moive", "asset.game.zero.294b", "out", 1, 0);
    }

    private void AttackC(int fx, int tx)
    {
      if (this.arbiNpc == null)
        return;
      this.Body.CurrentDamagePlus = 200f;
      this.Body.PlayMovie("beatE", 1300, 0);
      this.Body.CallFuction(new LivingCallBack(this.RangeAttackingNPC), 2000);
    }

    private void RangeAttackingNPC()
    {
      List<Living> livingById = this.Game.FindLivingByID(this.npcID);
      this.Body.RangeAttackingNPC("movie", 2000, livingById);
      ((PVEGame) this.Game).SendGameFocus((Physics) this.arbiNpc, 0, 1000);
      if (((PVEGame) this.Game).TotalKillCount > livingById.Count)
        this.Body.CallFuction(new LivingCallBack(this.CallYellowCard), 3200);
      else
        this.Body.CallFuction(new LivingCallBack(this.CallRedCard), 3200);
    }

    private void CallYellowCard()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.arbiNpc, 0, 1000);
      this.arbiNpc.PlayMovie("beatA", 2000, 0);
      this.arbiNpc.CallFuction(new LivingCallBack(this.RemoveProtect), 2200);
    }

    private void CallRedCard()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.Body, 0, 2000);
      this.Body.Say("Bye nhóc thua rồi nhé.", 1, 0, 2000);
      this.arbiNpc.CallFuction(new LivingCallBack(this.EndGame), 2200);
    }

    private void EndGame()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.arbiNpc, 0, 170);
      this.arbiNpc.PlayMovie("beatC", 1700, 0);
      this.arbiNpc.Say("Quá kém cỏi, thẻ đỏ rời sân ngay.", 1, 0, 2000);
      ((PVEGame) this.Game).IsMissBall = true;
    }

    private void RemoveProtect()
    {
      ((PVEGame) this.Game).SendGameFocus((Physics) this.Body, 0, 1700);
      this.Body.PlayMovie("beatD", 1700, 0);
      this.Body.Config.IsShield = false;
    }

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, WorldCupBossFor14109.KillPlayerChat.Length);
      this.Body.Say(WorldCupBossFor14109.KillPlayerChat[index], 1, 0, 2000);
    }

    public override void OnShootedSay()
    {
      int index1 = this.Game.Random.Next(0, WorldCupBossFor14109.ShootedChat.Length);
      if (this.isSay == 0 && this.Body.IsLiving)
      {
        this.Body.Say(WorldCupBossFor14109.ShootedChat[index1], 1, 900, 0);
        this.isSay = 1;
      }
      if (this.Body.IsLiving)
        return;
      int index2 = this.Game.Random.Next(0, WorldCupBossFor14109.DiedChat.Length);
      this.Body.Say(WorldCupBossFor14109.DiedChat[index2], 1, 100, 2000);
    }
  }
}
