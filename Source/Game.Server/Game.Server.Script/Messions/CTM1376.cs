// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CTM1376
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
  public class CTM1376 : AMissionControl
  {
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_kingFront;
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss m_secondKing = (SimpleBoss) null;
    private PhysicalObj[] m_leftWall = (PhysicalObj[]) null;
    private PhysicalObj[] m_rightWall = (PhysicalObj[]) null;
    private int m_kill = 0;
    private int m_state = 1305;
    private int turn = 0;
    private int firstBossID = 1305;
    private int secondBossID = 1306;
    private int npcID = 1310;

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
      this.Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
      this.Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");
      this.Game.AddLoadingFile(2, "image/map/1076/objects/1076MapAsset.swf", "com.mapobject.asset.WaveAsset_01_left");
      this.Game.AddLoadingFile(2, "image/map/1076/objects/1076MapAsset.swf", "com.mapobject.asset.WaveAsset_01_right");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      this.Game.LoadResources(new int[3]
      {
        this.firstBossID,
        this.secondBossID,
        this.npcID
      });
      this.Game.LoadNpcGameOverResources(new int[1]
      {
        this.firstBossID
      });
      this.Game.SetMap(1076);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.Game.IsBossWar = "1376";
      this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_kingFront = (PhysicalObj) this.Game.Createlayer(720, 495, "font", "game.asset.living.boguoKingAsset", "out", 1, 1);
      this.m_king = this.Game.CreateBoss(this.m_state, 890, 590, -1, 0, "");
      this.m_king.FallFrom(890, 590, "fall", 0, 2, 1000);
      this.m_king.SetRelateDemagemRect(-21, -87, 72, 59);
      this.m_king.AddDelay(10);
      this.m_king.Say(LanguageMgr.GetTranslation("GameServerScript.AI.Messions.CHM1376.msg2"), 0, 3000);
      this.m_kingMoive.PlayMovie("in", 9000, 0);
      this.m_kingFront.PlayMovie("in", 9000, 0);
      this.m_kingMoive.PlayMovie("out", 13000, 0);
      this.m_kingFront.PlayMovie("out", 13400, 0);
      this.turn = this.Game.TurnIndex;
      this.Game.BossCardCount = 1;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= this.turn + 1)
        return;
      if (this.m_kingMoive != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive, true);
        this.m_kingMoive = (PhysicalObj) null;
      }
      if (this.m_kingFront != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingFront, true);
        this.m_kingFront = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver()
    {
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      base.CanGameOver();
      if (!this.m_king.IsLiving && this.m_state == this.firstBossID)
        ++this.m_state;
      if (this.m_state == this.secondBossID && this.m_secondKing == null)
      {
        this.m_secondKing = this.Game.CreateBoss(this.m_state, this.m_king.X, this.m_king.Y, this.m_king.Direction, 2, "");
        this.Game.RemoveLiving(this.m_king.Id);
        if (this.m_secondKing.Direction == 1)
          this.m_secondKing.SetRelateDemagemRect(-21, -79, 72, 51);
        this.m_secondKing.SetRelateDemagemRect(-21, -79, 72, 51);
        this.m_secondKing.Say(LanguageMgr.GetTranslation("GameServerScript.AI.Messions.CHM1376.msg3"), 0, 3000);
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
        this.m_secondKing.AddDelay(num - 2000);
        this.turn = this.Game.TurnIndex;
      }
      if (this.m_secondKing != null && !this.m_secondKing.IsLiving)
      {
        this.Game.RemoveLiving(this.m_secondKing.Id);
        if (this.Game.CreatePhysicalObj(this.m_secondKing.X, this.m_secondKing.Y, "king", "game.living.Living005", "specialDie", 1, 0).CurrentAction == "specialDie")
        {
          ++this.m_kill;
          return true;
        }
      }
      return false;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_state == this.secondBossID && !this.m_secondKing.IsLiving)
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
