// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.ETN3101
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class ETN3101 : AMissionControl
  {
    private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();
    private SimpleBoss boss = (SimpleBoss) null;
    private int redTotalCount = 0;
    private int redNpcID = 3101;
    private int blueNpcID = 3104;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 600)
        return 3;
      if (score > 520)
        return 2;
      return score > 450 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds = new int[2]
      {
        this.blueNpcID,
        this.redNpcID
      };
      this.Game.AddLoadingFile(1, "bombs/58.swf", "tank.resource.bombs.Bomb58");
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1122);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "3101";
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      for (int index = 0; index < 4; ++index)
      {
        ++this.redTotalCount;
        if (index < 1)
          this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 444, 1, -1));
        else if (index < 2)
          this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 444, 1, -1));
        else
          this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 444, 1, -1));
      }
      ++this.redTotalCount;
      this.boss = this.Game.CreateBoss(this.blueNpcID, 1300, 444, -1, 1, "");
      this.boss.FallFrom(this.boss.X, this.boss.Y, "", 0, 0, 1000, (LivingCallBack) null);
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.Game.GetLivedLivings().Count == 0)
        this.Game.PveGameDelay = 0;
      if (this.Game.TurnIndex <= 1 || this.Game.GetLivedLivings().Count >= 4)
        return;
      for (int index = 0; index < 4; ++index)
      {
        if (this.redTotalCount < 15)
        {
          ++this.redTotalCount;
          if (index < 1)
            this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 900 + (index + 1) * 100, 444, -1, 1));
          else if (index < 2)
            this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 920 + (index + 1) * 100, 444, -1, 1));
          else
            this.SomeNpc.Add(this.Game.CreateNpc(this.redNpcID, 1000 + (index + 1) * 100, 444, -1, 1));
        }
      }
      if (this.redTotalCount >= 15 || this.boss.IsLiving)
        return;
      ++this.redTotalCount;
      this.boss = this.Game.CreateBoss(this.blueNpcID, 1300, 444, -1, 1, "");
      this.boss.FallFrom(this.boss.X, this.boss.Y, "", 0, 0, 1000, (LivingCallBack) null);
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (this.Game.GetLivedLivings().Count != 0 || this.boss.IsLiving || this.Game.TotalKillCount != 15)
        return false;
      this.Game.IsWin = true;
      return this.Game.TurnIndex <= this.Game.MissionInfo.TotalTurn - 1 || true;
    }

    public override int UpdateUIData() => this.Game.TotalKillCount;

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.Game.GetLivedLivings().Count == 0 && this.boss != null && !this.boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show2.jpg", "")
      });
    }
  }
}
