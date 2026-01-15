// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CSM1076
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
  public class CSM1076 : AMissionControl
  {
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_kingFront;
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss m_secondKing = (SimpleBoss) null;
    private PhysicalObj[] m_leftWall = (PhysicalObj[]) null;
    private PhysicalObj[] m_rightWall = (PhysicalObj[]) null;
    private int m_kill = 0;
    private int m_state = 1005;
    private int turn = 0;
    private int IsSay = 0;
    private int firstBossID = 1005;
    private int secondBossID = 1006;
    private int npcID = 1010;
    private static string[] KillChat = new string[3]
    {
      "马迪亚斯不要再控制我！",
      "这就是挑战我的下场！",
      "不！！这不是我的意愿… "
    };
    private static string[] ShootedChat = new string[2]
    {
      "哎呀~~你们为什么要攻击我？<br/>我在干什么？",
      "噢~~好痛!我为什么要战斗？<br/>我必须战斗…"
    };

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
      this.Game.LoadNpcGameOverResources(new int[2]
      {
        this.firstBossID,
        this.npcID
      });
      this.Game.SetMap(1076);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_kingFront = (PhysicalObj) this.Game.Createlayer(610, 380, "font", "game.asset.living.boguoKingAsset", "out", 1, 0);
      this.m_king = this.Game.CreateBoss(this.m_state, 750, 668, -1, 0, "");
      this.m_king.FallFrom(750, 640, "fall", 0, 2, 1000);
      this.m_king.SetRelateDemagemRect(-21, -79, 72, 51);
      this.m_king.AddDelay(10);
      this.m_king.Say("你们这些低等的庶民，竟敢来到我的王国放肆！", 0, 3000);
      this.m_kingMoive.PlayMovie("in", 9000, 0);
      this.m_kingFront.PlayMovie("in", 9000, 0);
      this.m_kingMoive.PlayMovie("out", 13000, 0);
      this.m_kingFront.PlayMovie("out", 13400, 0);
      this.turn = this.Game.TurnIndex;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.IsSay = 0;
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
      base.CanGameOver();
      if (this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1)
        return true;
      if (!this.m_king.IsLiving && this.m_state == this.firstBossID)
        ++this.m_state;
      if (this.m_state == this.secondBossID && this.m_secondKing == null)
      {
        this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
        this.m_secondKing = this.Game.CreateBoss(this.m_state, this.m_king.X, this.m_king.Y, this.m_king.Direction, 1, "");
        this.Game.RemoveLiving(this.m_king.Id);
        if (this.m_secondKing.Direction == -1)
        {
          this.m_secondKing.SetRectBomb(24, -159, 66, 38);
          this.m_secondKing.SetRelateDemagemRect(58, -142, 5, 3);
        }
        else
        {
          this.m_secondKing.SetRectBomb(-90, -159, 66, 38);
          this.m_secondKing.SetRelateDemagemRect(-63, -142, 5, 3);
        }
        this.m_secondKing.Say("<span class='red'>你们把我激怒了，我饶不了你们！</span>", 0, 3000);
        this.m_kingMoive.PlayMovie("in", 5000, 0);
        this.m_secondKing.PlayMovie("weakness", 6100, 0);
        this.m_kingMoive.PlayMovie("out", 12000, 0);
        List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
        int delay = this.Game.FindRandomPlayer().Delay;
        foreach (Player player in allFightPlayers)
        {
          if (player.Delay < delay)
            delay = player.Delay;
        }
        this.m_secondKing.AddDelay(delay - 2000);
        this.turn = this.Game.TurnIndex;
      }
      if (this.m_secondKing == null || this.m_secondKing.IsLiving)
        return false;
      this.m_leftWall = this.Game.FindPhysicalObjByName("wallLeft", false);
      this.m_rightWall = this.Game.FindPhysicalObjByName("wallRight", false);
      if (this.m_leftWall != null)
        this.Game.RemovePhysicalObj(this.m_leftWall[0], true);
      if (this.m_rightWall != null)
        this.Game.RemovePhysicalObj(this.m_rightWall[0], true);
      ++this.m_kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_state == 6 && !this.m_secondKing.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show7.jpg", "")
      });
    }

    public override void DoOther()
    {
      base.DoOther();
      if (this.m_king == null)
        return;
      if (this.m_king.IsLiving)
      {
        int index = this.Game.Random.Next(0, CSM1076.KillChat.Length);
        this.m_king.Say(CSM1076.KillChat[index], 0, 0);
      }
      else
      {
        int index = this.Game.Random.Next(0, CSM1076.KillChat.Length);
        this.m_king.Say(CSM1076.KillChat[index], 0, 0);
      }
    }

    public override void OnShooted()
    {
      if (this.IsSay != 0)
        return;
      if (this.m_king.IsLiving)
      {
        int index = this.Game.Random.Next(0, CSM1076.ShootedChat.Length);
        this.m_king.Say(CSM1076.ShootedChat[index], 0, 1500);
      }
      else
      {
        int index = this.Game.Random.Next(0, CSM1076.ShootedChat.Length);
        this.m_secondKing.Say(CSM1076.ShootedChat[index], 0, 1500);
      }
      this.IsSay = 1;
    }
  }
}
