// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.DLN5102
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class DLN5102 : AMissionControl
  {
    private SimpleBoss m_boss;
    private int m_kill = 0;
    private SimpleBoss boss;
    private SimpleBoss king;
    private PhysicalObj m_moive;
    private PhysicalObj m_moive1;
    private PhysicalObj m_moive2;
    private PhysicalObj m_moive3;
    private PhysicalObj m_front;
    private PhysicalObj[] m_leftWall = (PhysicalObj[]) null;
    private PhysicalObj[] m_rightWall = (PhysicalObj[]) null;
    private PhysicalObj m_wallRight = (PhysicalObj) null;
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private PhysicalObj m_NPC;
    private PhysicalObj n_NPC;
    private PhysicalObj npc = (PhysicalObj) null;
    private PhysicalObj npc2 = (PhysicalObj) null;
    private int IsEixt = 0;
    private int IsEixt2 = 0;
    private int bossID = 5114;
    private int bossID2 = 5113;
    private int bossID3 = 5112;
    private int npcID = 5116;
    private int npcID2 = 5117;
    private int npcID3 = 5111;
    private static string[] KillChat = new string[2]
    {
      "送你回老家！",
      "就凭你还妄想能够打败我？"
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呦！很痛…",
      "我还顶的住…"
    };

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
      this.Game.AddLoadingFile(2, "image/game/effect/5/mubiao.swf", "asset.game.4.mubiao");
      this.Game.AddLoadingFile(2, "image/game/effect/5/xiaopao.swf", "asset.game.4.xiaopao");
      this.Game.AddLoadingFile(2, "image/game/effect/5/zao.swf", "asset.game.4.zao");
      this.Game.AddLoadingFile(2, "image/game/living/living144.swf", "game.living.Living144");
      this.Game.AddLoadingFile(2, "image/game/living/living152.swf", "game.living.Living152");
      this.Game.AddLoadingFile(2, "image/game/living/living154.swf", "game.living.Living154");
      this.Game.AddLoadingFile(2, "image/game/living/living147.swf", "game.living.Living147");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.gebulinzhihuiguanAsset");
      int[] npcIds = new int[6]
      {
        this.bossID,
        this.bossID2,
        this.bossID3,
        this.npcID,
        this.npcID2,
        this.npcID3
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1152);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1100, 395, "font", "game.asset.living.gebulinzhihuiguanAsset", "out", 1, 0);
      this.m_wallRight = this.Game.CreatePhysicalObj(1460, 580, "wallLeft", "asset.game.4.zao", "1", 1, 0);
      this.m_wallRight.SetRect(-75, -159, 100, 130);
      this.m_boss = this.Game.CreateBoss(this.bossID, 1480, 610, -1, 1, "");
      this.king = this.Game.CreateBoss(this.bossID2, 1617, 544, -1, 1, "");
      this.boss = this.Game.CreateBoss(this.bossID3, 1300, 650, -1, 1, "");
      this.boss.FallFrom(1300, 650, "", 0, 0, 1000);
      this.m_NPC = (PhysicalObj) this.Game.Createlayer(1550, 650, "NPC", "game.living.Living154", "stand", 1, 0);
      this.n_NPC = (PhysicalObj) this.Game.Createlayer(1367, 845, "NPC", "game.living.Living147", "stand", 1, 0);
      this.king.SetRelateDemagemRect(-34, -35, 50, 40);
      this.boss.SetRelateDemagemRect(-34, -35, 50, 40);
      this.m_boss.SetRelateDemagemRect(-34, -35, 50, 40);
      this.m_moive.PlayMovie("in", 3000, 0);
      this.m_front.PlayMovie("in", 3000, 0);
      this.m_moive.PlayMovie("out", 4000, 0);
      this.m_front.PlayMovie("out", 4000, 0);
      this.m_moive1 = (PhysicalObj) this.Game.Createlayer(1617, 530, "moive", "asset.game.4.mubiao", "out", 1, 0);
      this.m_moive2 = (PhysicalObj) this.Game.Createlayer(1300, 635, "moive", "asset.game.4.mubiao", "out", 1, 0);
      this.m_moive3 = (PhysicalObj) this.Game.Createlayer(1480, 595, "moive", "asset.game.4.mubiao", "out", 1, 0);
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.boss == null || this.boss.IsLiving || this.king == null || this.king.IsLiving)
        return;
      this.m_leftWall = this.Game.FindPhysicalObjByName("wallLeft", false);
      this.m_rightWall = this.Game.FindPhysicalObjByName("wallRight", false);
      this.m_wallRight.SetRect(0, 0, 0, 0);
      foreach (PhysicalObj phy in this.m_leftWall)
      {
        if (phy != null)
          this.Game.RemovePhysicalObj(phy, true);
      }
      foreach (PhysicalObj phy in this.m_rightWall)
      {
        if (phy != null)
          this.Game.RemovePhysicalObj(phy, true);
      }
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= 1)
        return;
      if (this.m_moive != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive, true);
        this.m_moive = (PhysicalObj) null;
      }
      if (this.m_moive1 != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive1, true);
        this.m_moive1 = (PhysicalObj) null;
      }
      if (this.m_moive2 != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive2, true);
        this.m_moive2 = (PhysicalObj) null;
      }
      if (this.m_moive3 != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive3, true);
        this.m_moive3 = (PhysicalObj) null;
      }
      if (this.m_front != null)
      {
        this.Game.RemovePhysicalObj(this.m_front, true);
        this.m_front = (PhysicalObj) null;
      }
      if (this.m_NPC != null)
      {
        this.Game.RemovePhysicalObj(this.m_NPC, true);
        this.m_NPC = (PhysicalObj) null;
      }
      if (this.n_NPC == null)
        return;
      this.Game.RemovePhysicalObj(this.n_NPC, true);
      this.n_NPC = (PhysicalObj) null;
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (this.m_boss != null && !this.m_boss.IsLiving)
      {
        ++this.m_kill;
        return true;
      }
      return this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_boss != null && !this.m_boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.m_leftWall = this.Game.FindPhysicalObjByName("wallLeft");
      this.m_rightWall = this.Game.FindPhysicalObjByName("wallRight");
      for (int index = 0; index < this.m_leftWall.Length; ++index)
        this.Game.RemovePhysicalObj(this.m_leftWall[index], true);
      for (int index = 0; index < this.m_rightWall.Length; ++index)
        this.Game.RemovePhysicalObj(this.m_rightWall[index], true);
    }

    private void OnDie()
    {
      if (!this.king.IsLiving && this.IsEixt == 0)
      {
        this.npc = (PhysicalObj) this.Game.Createlayer(this.king.X, this.king.Y, "", "game.living.Living144", "standB", 1, 0);
        this.IsEixt = 1;
      }
      if (this.boss.IsLiving || this.IsEixt2 != 0)
        return;
      this.npc2 = (PhysicalObj) this.Game.Createlayer(this.boss.X, this.boss.Y, "", "game.living.Living152", "standB", 1, 0);
      this.IsEixt2 = 1;
    }

    public override void OnShooted()
    {
      if (!this.king.IsLiving)
        this.king.CallFuction(new LivingCallBack(this.OnDie), 8000);
      if (this.boss.IsLiving)
        return;
      this.boss.CallFuction(new LivingCallBack(this.OnDie), 8000);
    }
  }
}
