// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.RRCH7204
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class RRCH7204 : AMissionControl
  {
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private PhysicalObj m_eggs = (PhysicalObj) null;
    private PhysicalObj m_out = (PhysicalObj) null;
    private SimpleBoss cage = (SimpleBoss) null;
    private SimpleBoss boss = (SimpleBoss) null;
    private PhysicalObj[] m_leftWall = (PhysicalObj[]) null;
    private PhysicalObj[] m_rightWall = (PhysicalObj[]) null;
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private int m_kill = 0;
    private int turn = 0;
    private int bossID1 = 7231;
    private int bossID2 = 7232;
    private int npcID2 = 7233;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1150)
        return 3;
      if (score > 925)
        return 2;
      return score > 700 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(1, "bombs/83.swf", "tank.resource.bombs.Bomb83");
      this.Game.AddLoadingFile(1, "bombs/84.swf", "tank.resource.bombs.Bomb84");
      this.Game.AddLoadingFile(2, "image/map/1076/objects/1076MapAsset.swf", "com.mapobject.asset.WaveAsset_01_left");
      this.Game.AddLoadingFile(2, "image/map/1076/objects/1076MapAsset.swf", "com.mapobject.asset.WaveAsset_01_right");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.choudanbenbenAsset");
      this.Game.AddLoadingFile(2, "image/game/living/living177.swf", "game.living.Living177");
      this.Game.AddLoadingFile(2, "image/game/effect/7/choud.swf", "asset.game.seven.choud");
      this.Game.AddLoadingFile(2, "image/game/effect/7/jinqucd.swf", "asset.game.seven.jinqucd");
      this.Game.AddLoadingFile(2, "image/game/effect/7/du.swf", "asset.game.seven.du");
      this.Game.LoadResources(new int[3]
      {
        this.bossID1,
        this.npcID2,
        this.bossID2
      });
      this.Game.LoadNpcGameOverResources(new int[1]
      {
        this.bossID1
      });
      this.Game.SetMap(1164);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(300, 595, "font", "game.asset.living.choudanbenbenAsset", "out", 1, 1);
      this.m_eggs = this.Game.CreatePhysicalObj(2070, 633, "eggs", "game.living.Living178", "in", 1, 0);
      this.cage = this.Game.CreateBoss(this.bossID2, 1920, 920, -1, 0, "stand");
      this.cage.SetRelateDemagemRect(this.cage.NpcInfo.X, this.cage.NpcInfo.Y, this.cage.NpcInfo.Width, this.cage.NpcInfo.Height);
      this.boss = this.Game.CreateBoss(this.bossID1, 181, 875, 1, 1, "");
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      this.boss.Say(LanguageMgr.GetTranslation("Định giải cứu gà con à ? Đừng có mơ ...."), 0, 4000);
      this.m_moive.PlayMovie("in", 9000, 0);
      this.m_front.PlayMovie("in", 9000, 0);
      this.m_moive.PlayMovie("out", 13000, 0);
      this.m_front.PlayMovie("out", 13400, 0);
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.Game.TurnIndex > 1)
        this.cage.AddDelay(-200);
      int num = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.Delay < num)
          num = allFightPlayer.Delay;
      }
      this.cage.AddDelay(num + 200);
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex > 1)
      {
        if (this.m_moive != null)
        {
          this.Game.RemovePhysicalObj(this.m_moive, true);
          this.m_moive = (PhysicalObj) null;
        }
        if (this.m_front != null)
        {
          this.Game.RemovePhysicalObj(this.m_front, true);
          this.m_front = (PhysicalObj) null;
        }
      }
      if (this.Game.TurnIndex != 1)
        return;
      this.cage.PlayMovie("standB", 1000, 0);
      this.cage.Say(LanguageMgr.GetTranslation("Chúng mình không muốn bị lây bệnh, cứu cứu...."), 0, 1000);
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (this.boss != null && !this.boss.IsLiving)
      {
        this.cage.PlayMovie("out", 1000, 0);
        this.cage.SetRelateDemagemRect(-144, this.cage.NpcInfo.Y, this.cage.NpcInfo.Width, this.cage.NpcInfo.Height);
        int num = 0;
        foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        {
          if (allFightPlayer.Delay < num)
            num = allFightPlayer.Delay;
        }
        this.cage.AddDelay(num - 200);
      }
      if (this.cage == null || this.cage.IsLiving)
        return false;
      this.Game.GetAllFightPlayers();
      this.Game.RemoveLiving(this.cage.Id);
      this.m_out = this.Game.CreatePhysicalObj(1920, 895, "movie", "game.living.Living177", "die", 1, 0);
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.cage != null && !this.cage.IsLiving)
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
  }
}
