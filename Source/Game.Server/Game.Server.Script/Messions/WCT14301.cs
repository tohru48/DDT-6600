// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.WCT14301
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness.Managers;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class WCT14301 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private SimpleNpc ball = (SimpleNpc) null;
    private int bossID = 14202;
    private int ballID = 14201;
    private int holdTurn = 40;

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
      int[] npcIds1 = new int[2]{ this.bossID, this.ballID };
      int[] npcIds2 = npcIds1;
      this.Game.LoadResources(npcIds1);
      this.Game.AddLoadingFile(1, "bombs/110.swf", "tank.resource.bombs.Bomb110");
      this.Game.AddLoadingFile(1, "bombs/117.swf", "tank.resource.bombs.Bomb117");
      this.Game.AddLoadingFile(2, "image/game/effect/9/biaoji.swf", "asset.game.nine.biaoji");
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.SetMap(1405);
    }

    public override void OnStartMovie()
    {
      base.OnStartMovie();
      int[] numArray = new int[3]{ 10467, 10468, 10469 };
      List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
      foreach (Player player in allFightPlayers)
      {
        if (player != null && player.IsLiving)
        {
          for (int index = 0; index < numArray.Length; ++index)
          {
            ItemInfo fromTemplate = ItemInfo.CreateFromTemplate(ItemMgr.FindItemTemplate(numArray[index]), 1, 101);
            player.PlayerDetail.AddTemplate(fromTemplate, eBageType.FightBag, 1, eGameView.OtherTypeGet);
          }
        }
      }
      if (allFightPlayers.Count > 2)
        this.holdTurn = 50;
      this.Game.PassBallActive = true;
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.boss = this.Game.CreateBoss(this.bossID, 1277, 812, -1, 1, "");
      this.boss.SetRelateDemagemRect(this.boss.NpcInfo.X, this.boss.NpcInfo.Y, this.boss.NpcInfo.Width, this.boss.NpcInfo.Height);
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsHelper = true;
      config.HasTurn = false;
      this.ball = this.Game.CreateNpc(this.ballID, 638, 926, 1, -1, config);
      this.boss.AddDelay(2500);
    }

    public override void OnShooted()
    {
      base.OnShooted();
      Player currentPlayer = this.Game.CurrentPlayer;
      if (currentPlayer == null || !currentPlayer.PassBallFail)
        return;
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsHelper = true;
      config.HasTurn = false;
      if (currentPlayer != null && !currentPlayer.LastPoint.IsEmpty)
        this.ball = this.Game.CreateNpc(this.ballID, currentPlayer.LastPoint.X, currentPlayer.LastPoint.Y, 1, -1, config);
      int x = this.ball.X + 150 * currentPlayer.Direction;
      if (x > this.Game.Map.Info.ForegroundWidth)
        x = this.Game.Map.Info.ForegroundWidth;
      if (x < 1)
        x = 1;
      this.ball.MoveTo(x, this.ball.Y, "walk", 0, "", 3);
    }

    public override void OnMoving()
    {
      base.OnMoving();
      Player currentPlayer = this.Game.CurrentPlayer;
      if (currentPlayer == null || currentPlayer.IsHoldBall || this.ball == null || currentPlayer.X >= this.ball.X + 25 || currentPlayer.X <= this.ball.X - 25)
        return;
      this.Game.TakePassBall(currentPlayer.Id);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      return this.holdTurn <= this.Game.TurnIndex || this.Game.IsMissBall;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.holdTurn;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.holdTurn <= this.Game.TurnIndex && !this.Game.IsMissBall)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer?.PlayerDetail.ClearFightBag();
      this.Game.PassBallActive = false;
    }
  }
}
