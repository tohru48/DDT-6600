// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.ETT3302
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class ETT3302 : AMissionControl
  {
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleBoss m_king = (SimpleBoss) null;
    protected int m_maxBlood;
    protected int m_blood;
    private int npcID = 3302;
    private int npcID1 = 3307;
    private int npcID2 = 3305;
    private int bossId = 3308;
    private int kill = 0;
    private SimpleBoss m_boss = (SimpleBoss) null;

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
        this.npcID,
        this.npcID1,
        this.npcID2,
        this.bossId
      };
      int[] npcIds2 = new int[4]
      {
        this.npcID,
        this.npcID1,
        this.npcID2,
        this.bossId
      };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(1, "bombs/58.swf", "tank.resource.bombs.Bomb58");
      this.Game.SetMap(1123);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "3302";
      this.m_king = this.Game.CreateBoss(this.bossId, 100, 444, 1, 1, "");
      this.m_king.FallFrom(this.m_king.X, this.m_king.Y, "", 0, 0, 2000);
      this.m_king.PlayMovie("castA", 500, 0);
      this.m_king.CallFuction(new LivingCallBack(this.CreateStarGame), 2500);
    }

    public void CreateStarGame()
    {
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsHelper = true;
      config.ReduceBloodStart = 4;
      this.boss = this.Game.CreateBoss(this.npcID1, 1100, 444, -1, 10, "", config);
      this.boss.FallFrom(this.boss.X, this.boss.Y, "", 0, 0, 1000, (LivingCallBack) null);
      this.m_boss = this.Game.CreateBoss(this.npcID2, 300, 444, 1, 0, "");
      this.m_boss.FallFrom(this.m_boss.X, this.m_boss.Y, "", 0, 1, 1000, (LivingCallBack) null);
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 450, 344, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 400, 344, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 350, 344, 1, 1));
      this.Game.SendGameFocus((Physics) this.boss, 500, 3000);
      this.boss.Say(LanguageMgr.GetTranslation("Hồi máu cho tôi, tôi sẻ dẫn các cậu ra khỏi đây !"), 0, 1500, 0);
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.m_boss == null || this.m_boss.IsLiving)
        return;
      this.m_boss = this.Game.CreateBoss(this.npcID2, 300, 444, 1, 1, "");
      this.m_boss.FallFrom(this.m_boss.X, this.m_boss.Y, "", 0, 0, 1000, (LivingCallBack) null);
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 450, 344, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 400, 344, 1, 1));
      this.someNpc.Add(this.Game.CreateNpc(this.npcID, 350, 344, 1, 1));
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex != 1 || this.m_king == null || !this.m_king.IsLiving)
        return;
      this.m_king.PlayMovie("out", 0, 2000);
      this.m_king.CallFuction(new LivingCallBack(this.CreateOutGame), 1200);
    }

    public void CreateOutGame()
    {
      this.Game.RemoveLiving(this.m_king.Id);
      this.m_king.Die();
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (this.boss.Blood == this.boss.NpcInfo.Blood)
        return true;
      if (this.boss == null || this.boss.IsLiving)
        return false;
      ++this.kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.boss.Blood == this.boss.NpcInfo.Blood)
      {
        this.boss.PlayMovie("grow", 0, 1000);
        this.Game.IsWin = true;
      }
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show4.jpg", "")
      });
    }
  }
}
