// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.AC30001
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
  public class AC30001 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private int npcID = 30001;
    private int bossID = 30002;
    private LivingConfig config;
    private List<SimpleNpc> someNpc = new List<SimpleNpc>();
    private int[] birthX = new int[10]
    {
      443,
      515,
      683,
      723,
      800,
      606,
      785,
      842,
      910,
      1075
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
      int[] npcIds1 = new int[2]{ this.npcID, this.bossID };
      int[] npcIds2 = new int[1]{ this.npcID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/effect/0/294b.swf", "asset.game.zero.294b");
      this.Game.SetMap(1244);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.createNPC();
      this.config = this.Game.BaseLivingConfig();
      this.config.IsFly = true;
      this.config.IsWorldBoss = true;
    }

    private void createNPC()
    {
      foreach (int x in this.birthX)
        this.someNpc.Add(this.Game.CreateNpc(this.npcID, x, this.Game.Random.Next(478, 674), 0, 1, this.config));
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
      if (this.Game.GetLivedLivings().Count >= 3)
        return;
      this.createNPC();
    }

    public override void OnBeginNewTurn() => base.OnBeginNewTurn();

    public override bool CanGameOver()
    {
      if (this.Game.TotalKillCount > 15 && this.boss == null)
      {
        this.Game.ClearAllChild();
        this.boss = this.Game.CreateBoss(this.bossID, 944, 481, -1, 0, "", this.config);
        this.boss.SetRelateDemagemRect(-200, -179, 272, 200);
        this.boss.Say(LanguageMgr.GetTranslation("GameServerScript.AI.Messions.DCSM2002.msg1"), 0, 200, 0);
        List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
        Player randomPlayer = this.Game.FindRandomPlayer();
        int num = 0;
        if (randomPlayer != null)
          num = randomPlayer.Delay;
        foreach (Player player in allFightPlayers)
        {
          if (player.Delay < num)
            num = player.Delay;
        }
        this.boss.State = 10;
      }
      return false;
    }

    public override int UpdateUIData() => this.Game.TotalKillCount;

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.Game.TotalKillCount > 100)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
        allFightPlayer.PlayerDetail.UpdatePveResult("worldboss", allFightPlayer.TotalDameLiving, this.Game.IsWin);
    }
  }
}
