// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CSM1083
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness.Managers;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CSM1083 : AMissionControl
  {
    private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();
    private PhysicalObj Tip = (PhysicalObj) null;
    private bool result = false;
    private int killCount = 0;
    private int preKillNum = 0;
    private bool canPlayMovie = false;

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
      this.Game.AddLoadingFile(2, "image/map/1086/object/Asset.swf", "com.map.trainer.TankTrainerAssetII");
      int[] npcIds = new int[2]{ 1, 2 };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1086);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      for (int index = 0; index < 4; ++index)
        this.SomeNpc.Add(this.Game.CreateNpc(201, (index + 1) * 100, 500, 1, 1));
      this.SomeNpc.Add(this.Game.CreateNpc(202, 500, 500, 1, 1));
      this.Tip = (PhysicalObj) this.Game.CreateTip(390, 120, "firstFront", "com.map.trainer.TankTrainerAssetII", "Empty", 1, 0);
    }

    public override void OnNewTurnStarted()
    {
      List<ItemTemplateInfo> itemTemplateInfoList = new List<ItemTemplateInfo>();
      List<ItemInfo> itemInfoList = new List<ItemInfo>();
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        foreach (Physics livedLiving in this.Game.GetLivedLivings())
        {
          if (livedLiving.Distance(allFightPlayer.X, allFightPlayer.Y) <= 100.0)
            this.canPlayMovie = true;
        }
      }
      if (this.Game.TurnIndex > 1 && this.Game.CurrentPlayer.Delay > this.Game.PveGameDelay)
      {
        for (int index = 0; index < 5 && this.SomeNpc.Count < 15; ++index)
          this.SomeNpc.Add(this.Game.CreateNpc(201, (index + 1) * 100, 500, 1, 1));
      }
      if (this.Game.CurrentPlayer.Delay >= this.Game.PveGameDelay)
        return;
      if (this.Tip.CurrentAction == "Empty")
        this.Tip.PlayMovie("tip1", 0, 3000);
      if (this.preKillNum < this.Game.TotalKillCount && this.killCount < 2)
        ++this.killCount;
      if (this.killCount == 2)
        this.Tip.PlayMovie("tip2", 0, 2000);
      if (this.canPlayMovie)
        this.Tip.PlayMovie("tip3", 0, 2000);
      itemTemplateInfoList.Add(ItemMgr.FindItemTemplate(10001));
      itemTemplateInfoList.Add(ItemMgr.FindItemTemplate(10003));
      itemTemplateInfoList.Add(ItemMgr.FindItemTemplate(10018));
      foreach (ItemTemplateInfo goods in itemTemplateInfoList)
        itemInfoList.Add(ItemInfo.CreateFromTemplate(goods, 1, 101));
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        allFightPlayer.CanGetProp = false;
        allFightPlayer.PlayerDetail.ClearFightBag();
        foreach (ItemInfo cloneItem in itemInfoList)
          allFightPlayer.PlayerDetail.AddTemplate(cloneItem, eBageType.FightBag, cloneItem.Count, eGameView.dungeonTypeGet);
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
