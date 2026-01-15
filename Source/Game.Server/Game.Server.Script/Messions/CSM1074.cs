// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CSM1074
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CSM1074 : AMissionControl
  {
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
      this.Game.SetMap(1074);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.TotalTurn = this.Game.PlayerCount * 3;
      this.Game.SendMissionInfo();
      List<ItemInfo> itemInfoList = new List<ItemInfo>();
      for (int index = 0; index < 24; ++index)
      {
        List<ItemInfo> info = (List<ItemInfo>) null;
        DropInventory.SpecialDrop(1074, 2, ref info);
        if (info != null)
        {
          foreach (ItemInfo itemInfo in info)
            itemInfoList.Add(itemInfo);
        }
      }
      this.Game.CreateBox(550, 68, "2", itemInfoList[0]);
      this.Game.CreateBox(750, 68, "2", itemInfoList[1]);
      this.Game.CreateBox(932, 68, "2", itemInfoList[2]);
      this.Game.CreateBox(1104, 68, "2", itemInfoList[3]);
      this.Game.CreateBox(451, 184, "1", itemInfoList[4]);
      this.Game.CreateBox(451, 285, "1", itemInfoList[5]);
      this.Game.CreateBox(451, 394, "1", itemInfoList[6]);
      this.Game.CreateBox(451, 499, "1", itemInfoList[7]);
      this.Game.CreateBox(643, 184, "1", itemInfoList[8]);
      this.Game.CreateBox(643, 285, "1", itemInfoList[9]);
      this.Game.CreateBox(643, 394, "1", itemInfoList[10]);
      this.Game.CreateBox(643, 499, "1", itemInfoList[11]);
      this.Game.CreateBox(830, 184, "1", itemInfoList[12]);
      this.Game.CreateBox(830, 285, "1", itemInfoList[13]);
      this.Game.CreateBox(830, 394, "1", itemInfoList[14]);
      this.Game.CreateBox(830, 499, "1", itemInfoList[15]);
      this.Game.CreateBox(1022, 184, "1", itemInfoList[16]);
      this.Game.CreateBox(1022, 285, "1", itemInfoList[17]);
      this.Game.CreateBox(1022, 394, "1", itemInfoList[18]);
      this.Game.CreateBox(1022, 499, "1", itemInfoList[19]);
      this.Game.CreateBox(1201, 184, "1", itemInfoList[20]);
      this.Game.CreateBox(1201, 285, "1", itemInfoList[21]);
      this.Game.CreateBox(1201, 394, "1", itemInfoList[22]);
      this.Game.CreateBox(1201, 499, "1", itemInfoList[23]);
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      this.Game.CurrentLiving.Seal((Player) this.Game.CurrentLiving, 0, 0);
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      ((Player) this.Game.CurrentLiving).SetBall(3);
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      return this.Game.TurnIndex > this.Game.TotalTurn - 1;
    }

    public override int UpdateUIData() => base.UpdateUIData();

    public override void OnGameOver()
    {
      base.OnGameOver();
      this.Game.IsWin = true;
      foreach (Living allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.EffectList.GetOfType(eEffectType.SealEffect)?.Stop();
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show5.jpg", "")
      });
    }
  }
}
