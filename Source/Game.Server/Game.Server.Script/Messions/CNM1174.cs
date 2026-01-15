// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CNM1174
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
  public class CNM1174 : AMissionControl
  {
    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 2045)
        return 3;
      if (score > 2035)
        return 2;
      return score > 2025 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.SetMap(1074);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      List<ItemInfo> itemInfoList = new List<ItemInfo>();
      for (int index = 0; index < 54; ++index)
      {
        List<ItemInfo> info = (List<ItemInfo>) null;
        if (index > 9)
          DropInventory.SpecialDrop(this.Game.MissionInfo.Id, 1, ref info);
        else
          DropInventory.SpecialDrop(this.Game.MissionInfo.Id, 2, ref info);
        if (info != null)
        {
          foreach (ItemInfo itemInfo in info)
            itemInfoList.Add(itemInfo);
        }
        else
          itemInfoList.Add((ItemInfo) null);
      }
      this.Game.CreateBox(455, 88, "2", itemInfoList[0]);
      this.Game.CreateBox(555, 88, "2", itemInfoList[1]);
      this.Game.CreateBox(655, 88, "2", itemInfoList[2]);
      this.Game.CreateBox(755, 88, "2", itemInfoList[3]);
      this.Game.CreateBox(855, 88, "2", itemInfoList[4]);
      this.Game.CreateBox(955, 88, "2", itemInfoList[5]);
      this.Game.CreateBox(1055, 88, "2", itemInfoList[6]);
      this.Game.CreateBox(1155, 88, "2", itemInfoList[7]);
      this.Game.CreateBox(1255, 88, "2", itemInfoList[8]);
      this.Game.CreateBox(450, 184, "1", itemInfoList[9]);
      this.Game.CreateBox(450, 259, "1", itemInfoList[10]);
      this.Game.CreateBox(450, 335, "1", itemInfoList[11]);
      this.Game.CreateBox(450, 420, "1", itemInfoList[12]);
      this.Game.CreateBox(450, 504, "1", itemInfoList[13]);
      this.Game.CreateBox(550, 184, "1", itemInfoList[14]);
      this.Game.CreateBox(550, 259, "1", itemInfoList[15]);
      this.Game.CreateBox(550, 335, "1", itemInfoList[16]);
      this.Game.CreateBox(550, 420, "1", itemInfoList[17]);
      this.Game.CreateBox(550, 504, "1", itemInfoList[18]);
      this.Game.CreateBox(650, 184, "1", itemInfoList[19]);
      this.Game.CreateBox(650, 259, "1", itemInfoList[20]);
      this.Game.CreateBox(650, 335, "1", itemInfoList[21]);
      this.Game.CreateBox(650, 420, "1", itemInfoList[22]);
      this.Game.CreateBox(650, 504, "1", itemInfoList[23]);
      this.Game.CreateBox(750, 184, "1", itemInfoList[24]);
      this.Game.CreateBox(750, 259, "1", itemInfoList[25]);
      this.Game.CreateBox(750, 335, "1", itemInfoList[26]);
      this.Game.CreateBox(750, 420, "1", itemInfoList[27]);
      this.Game.CreateBox(750, 504, "1", itemInfoList[28]);
      this.Game.CreateBox(850, 184, "1", itemInfoList[29]);
      this.Game.CreateBox(850, 259, "1", itemInfoList[30]);
      this.Game.CreateBox(850, 335, "1", itemInfoList[31]);
      this.Game.CreateBox(850, 420, "1", itemInfoList[32]);
      this.Game.CreateBox(850, 504, "1", itemInfoList[33]);
      this.Game.CreateBox(950, 184, "1", itemInfoList[34]);
      this.Game.CreateBox(950, 259, "1", itemInfoList[35]);
      this.Game.CreateBox(950, 335, "1", itemInfoList[36]);
      this.Game.CreateBox(950, 420, "1", itemInfoList[37]);
      this.Game.CreateBox(950, 504, "1", itemInfoList[38]);
      this.Game.CreateBox(1050, 184, "1", itemInfoList[39]);
      this.Game.CreateBox(1050, 259, "1", itemInfoList[40]);
      this.Game.CreateBox(1050, 335, "1", itemInfoList[41]);
      this.Game.CreateBox(1050, 420, "1", itemInfoList[42]);
      this.Game.CreateBox(1050, 504, "1", itemInfoList[43]);
      this.Game.CreateBox(1150, 184, "1", itemInfoList[44]);
      this.Game.CreateBox(1150, 259, "1", itemInfoList[45]);
      this.Game.CreateBox(1150, 335, "1", itemInfoList[46]);
      this.Game.CreateBox(1150, 420, "1", itemInfoList[47]);
      this.Game.CreateBox(1150, 504, "1", itemInfoList[48]);
      this.Game.CreateBox(1250, 189, "1", itemInfoList[49]);
      this.Game.CreateBox(1250, 259, "1", itemInfoList[50]);
      this.Game.CreateBox(1250, 335, "1", itemInfoList[51]);
      this.Game.CreateBox(1250, 420, "1", itemInfoList[52]);
      this.Game.CreateBox(1250, 504, "1", itemInfoList[53]);
      this.Game.BossCardCount = 1;
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
        new LoadingFileInfo(2, "image/map/show4.jpg", "")
      });
    }
  }
}
