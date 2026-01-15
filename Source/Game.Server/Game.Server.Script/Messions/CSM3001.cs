// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CSM3001
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CSM3001 : AMissionControl
  {
    private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();
    private SimpleBoss boss = (SimpleBoss) null;
    private PhysicalObj Tip = (PhysicalObj) null;
    private bool result = false;
    private int killCount = 0;
    private int preKillNum = 0;
    private bool canPlayMovie = false;
    public int turnCount;

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
      this.Game.AddLoadingFile(1, "bombs/51.swf", "tank.resource.bombs.Bomb51");
      this.Game.AddLoadingFile(1, "bombs/17.swf", "tank.resource.bombs.Bomb17");
      this.Game.AddLoadingFile(1, "bombs/18.swf", "tank.resource.bombs.Bomb18");
      this.Game.AddLoadingFile(1, "bombs/19.swf", "tank.resource.bombs.Bomb19");
      this.Game.AddLoadingFile(1, "bombs/67.swf", "tank.resource.bombs.Bomb67");
      int[] npcIds = new int[4]{ 3001, 3003, 3004, 3005 };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1089);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.boss = this.Game.CreateBoss(3005, 2000, 1200, -1, 1, "");
      this.boss.SetRelateDemagemRect(-42, -200, 84, 194);
      this.turnCount = 1;
    }

    public override void OnNewTurnStarted()
    {
      List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
      List<ItemInfo> itemInfoList = new List<ItemInfo>();
      if (this.Game.TurnIndex <= 1 || this.Game.CurrentPlayer.Delay <= this.Game.PveGameDelay)
        return;
      for (int index = 0; index < 3 && this.SomeNpc.Count < 7; ++index)
      {
        if (this.turnCount % 2 == 0)
          this.SomeNpc.Add(this.Game.CreateNpc(3003, (index + 1) * 50, this.boss.Y - 50, 1, 1));
        else
          this.SomeNpc.Add(this.Game.CreateNpc(3003, (index + 1) * 50 + 500, this.boss.Y - 50, 1, 1));
        ++this.turnCount;
      }
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (this.Game.TurnIndex > 99)
        return true;
      this.result = false;
      foreach (Physics physics in this.SomeNpc)
      {
        if (physics.IsLiving)
          this.result = true;
      }
      return !this.result && this.SomeNpc.Count == 15;
    }

    public override int UpdateUIData()
    {
      this.preKillNum = this.Game.TotalKillCount;
      return this.Game.TotalKillCount;
    }

    public override void OnGameOver()
    {
      if (this.result)
        return;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.CanGetProp = true;
      this.Game.IsWin = true;
    }
  }
}
