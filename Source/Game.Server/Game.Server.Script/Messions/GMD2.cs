// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.GMD2
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
  public class GMD2 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private List<SimpleBoss> someBoss = new List<SimpleBoss>();
    private int npcID = 2104;
    private int npcID2 = 77009;
    private int bossID = 77008;
    private int bossID2 = 77010;
    private SimpleNpc npclobo = (SimpleNpc) null;
    private SimpleBoss boss2 = (SimpleBoss) null;
    private int IsSay = 0;
    private int kill = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
    private static string[] KillChat = new string[3]
    {
      "www.SystemGames.net",
      "Seu fracote!",
      "Curta nossa pagina no facebook"
    };
    private static string[] ShootedChat = new string[1]
    {
      "Fique por dentro dos eventos"
    };

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1750)
        return 3;
      if (score > 1675)
        return 2;
      return score > 1600 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds1 = new int[4]
      {
        this.bossID,
        this.bossID2,
        this.npcID,
        this.npcID2
      };
      int[] npcIds2 = new int[2]
      {
        this.bossID,
        this.bossID2
      };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/51.swf", "tank.resource.bombs.Bomb51");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.AntQueenAsset");
      this.Game.SetMap(15002);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1131, 150, "font", "game.asset.living.AntQueenAsset", "out", 1, 1);
      this.boss = this.Game.CreateBoss(this.bossID2, 1000, 50, -1, 1, "");
      this.someBoss.Add(this.boss);
      this.boss.SetRelateDemagemRect(-42, -200, 84, 194);
      this.boss.Say(LanguageMgr.GetTranslation("www.SystemGames.net"), 0, 200, 0);
      this.npclobo = this.Game.CreateNpc(this.npcID2, 1000, 500, -1, 1);
      this.m_moive.PlayMovie("in", 6000, 0);
      this.m_front.PlayMovie("in", 6100, 0);
      this.m_moive.PlayMovie("out", 10000, 1000);
      this.m_front.PlayMovie("out", 9900, 0);
    }

    public override void OnNewTurnStarted()
    {
      if (!this.boss.IsLiving)
      {
        this.boss = this.Game.CreateBoss(this.bossID, 1000, 300, -1, 1, "");
        this.someBoss.Add(this.boss);
      }
      if (this.npclobo.IsLiving)
        return;
      this.npclobo = this.Game.CreateNpc(this.npcID2, 1000, 500, -1, 1);
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
      if (this.m_front != null)
      {
        this.Game.RemovePhysicalObj(this.m_front, true);
        this.m_front = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver()
    {
      this.kill = 0;
      bool flag = true;
      base.CanGameOver();
      foreach (Physics physics in this.someBoss)
      {
        if (physics.IsLiving)
          flag = false;
        else
          ++this.kill;
      }
      return flag && this.kill == this.Game.MissionInfo.TotalCount;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.kill == this.Game.MissionInfo.TotalCount)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void DoOther()
    {
      base.DoOther();
      int index = this.Game.Random.Next(0, GMD2.KillChat.Length);
      this.boss.Say(GMD2.KillChat[index], 0, 0);
    }

    public override void OnShooted()
    {
      if (!this.boss.IsLiving || this.IsSay != 0)
        return;
      int index = this.Game.Random.Next(0, GMD2.ShootedChat.Length);
      this.boss.Say(GMD2.ShootedChat[index], 0, 1500);
      this.IsSay = 1;
    }
  }
}
