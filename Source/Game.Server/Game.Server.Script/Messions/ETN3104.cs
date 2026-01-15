// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.ETN3104
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
  public class ETN3104 : AMissionControl
  {
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_kingFront;
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss king = (SimpleBoss) null;
    private SimpleBoss m_secondKing = (SimpleBoss) null;
    private PhysicalObj[] m_leftWall = (PhysicalObj[]) null;
    private PhysicalObj[] m_rightWall = (PhysicalObj[]) null;
    private int IsSay = 0;
    private int m_kill = 0;
    private int m_state = 3116;
    private int turn = 0;
    private int firstBossID = 3116;
    private int secondBossID = 3117;
    private int npcID = 3103;
    private int npcID3 = 3118;
    private int npcID2 = 3112;
    private int npcID1 = 3113;
    private int direction;
    private static string[] ShootedChat = new string[4]
    {
      "Ta dận rồi nha!!",
      "Yếu, quá yếu...",
      "Ta né, ta né, hãy...",
      "Hỡi thần thánh, trợ giúp cho ta..."
    };
    private static string[] ShootedChatSecond = new string[4]
    {
      "Thân thể yếu ớt này mà các nguwoi không làm gì được!",
      "Yếu, quá yếu...",
      "Chọc dận ta à?...",
      "Dựa vào các nguwoi mà muốn cản nghi lễ của ta..."
    };
    private static string[] KillChat = new string[1]
    {
      "Ngươi muốn làm gì đây?<br/>A...."
    };

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
      this.Game.AddLoadingFile(1, "bombs/55.swf", "tank.resource.bombs.Bomb55");
      this.Game.AddLoadingFile(1, "bombs/54.swf", "tank.resource.bombs.Bomb54");
      this.Game.AddLoadingFile(1, "bombs/53.swf", "tank.resource.bombs.Bomb53");
      this.Game.AddLoadingFile(2, "image/game/effect/3/flame.swf", "asset.game.4.flame");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ClanLeaderAsset");
      this.Game.LoadResources(new int[6]
      {
        this.firstBossID,
        this.secondBossID,
        this.npcID,
        this.npcID2,
        this.npcID1,
        this.npcID3
      });
      this.Game.LoadNpcGameOverResources(new int[1]
      {
        this.firstBossID
      });
      this.Game.SetMap(1126);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_kingFront = (PhysicalObj) this.Game.Createlayer(700, 355, "font", "game.asset.living.ClanLeaderAsset", "out", 1, 1);
      this.m_king = this.Game.CreateBoss(this.m_state, 800, 400, -1, 1, "");
      this.m_king.FallFrom(800, 0, "fall", 0, 2, 1000, (LivingCallBack) null);
      this.m_king.SetRelateDemagemRect(this.m_king.NpcInfo.X, this.m_king.NpcInfo.Y, this.m_king.NpcInfo.Width, this.m_king.NpcInfo.Height);
      this.m_king.AddDelay(10);
      this.m_king.Say("Đến đây thôi, dám ngăn cản nghi lễ của ta, không muốn sống à!", 0, 4000);
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
      base.CanGameOver();
      if (!this.m_king.IsLiving && this.m_state == this.firstBossID)
        ++this.m_state;
      if (this.m_state == this.secondBossID && this.m_secondKing == null)
      {
        this.m_secondKing = this.Game.CreateBoss(this.m_state, this.m_king.X, this.m_king.Y, this.m_king.Direction, 2, "");
        this.king = this.Game.CreateBoss(this.npcID3, 478, 560, -1, 0, "");
        this.Game.RemoveLiving(this.m_king.Id);
        if (this.m_secondKing.Direction == 1)
          this.m_secondKing.SetRelateDemagemRect(this.m_king.NpcInfo.X, this.m_king.NpcInfo.Y, this.m_king.NpcInfo.Width, this.m_king.NpcInfo.Height);
        this.m_secondKing.SetRelateDemagemRect(this.m_king.NpcInfo.X, this.m_king.NpcInfo.Y, this.m_king.NpcInfo.Width, this.m_king.NpcInfo.Height);
        this.m_secondKing.Say(LanguageMgr.GetTranslation("Thể xác ốm yếu này, đưa ta mượn tạm xem!"), 0, 3000);
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
      if (this.m_secondKing == null || this.m_secondKing.IsLiving)
        return false;
      this.direction = this.m_secondKing.Direction;
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
      if (this.m_state == this.secondBossID && !this.m_secondKing.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show7.jpg", "")
      });
      this.m_leftWall = this.Game.FindPhysicalObjByName("wallLeft");
      this.m_rightWall = this.Game.FindPhysicalObjByName("wallRight");
      for (int index = 0; index < this.m_leftWall.Length; ++index)
        this.Game.RemovePhysicalObj(this.m_leftWall[index], true);
      for (int index = 0; index < this.m_rightWall.Length; ++index)
        this.Game.RemovePhysicalObj(this.m_rightWall[index], true);
    }

    public override void DoOther() => base.DoOther();
  }
}
