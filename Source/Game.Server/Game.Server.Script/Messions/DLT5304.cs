// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.DLT5304
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class DLT5304 : AMissionControl
  {
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss king = (SimpleBoss) null;
    private SimpleBoss m_preKing = (SimpleBoss) null;
    private PhysicalObj m_kingMoive;
    private PhysicalObj kingMoive;
    private PhysicalObj m_kingFront;
    private int turn = 0;
    private int m_kill = 0;
    private int IsSay = 0;
    private int bossID = 5331;
    private int bossID2 = 5333;
    private int npcID = 5332;
    private int npcID2 = 5334;
    private static string[] KillChat = new string[2]
    {
      "Địa ngục là điểm đến duy nhất của bạn!",
      "Quá dễ bị tổn thương."
    };
    private static string[] ShootedChat = new string[3]
    {
      "Oh ~ bạn chơi tốt một điều đau khổ!<br/>Ah ha ha ha ha!",
      "Bạn sẽ chỉ có khả năng này? !",
      "Có một chút có nghĩa là"
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
      int[] npcIds = new int[4]
      {
        this.npcID,
        this.npcID2,
        this.bossID,
        this.bossID2
      };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/effect/5/guang.swf", "asset.game.4.guang");
      this.Game.AddLoadingFile(2, "image/game/effect/5/tang.swf", "asset.game.4.tang");
      this.Game.AddLoadingFile(2, "image/game/effect/5/ruodian.swf", "asset.game.4.ruodian");
      this.Game.AddLoadingFile(2, "image/game/effect/5/jinqudan.swf", "asset.game.4.jinqudan");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.xieyanjulongAsset");
      this.Game.AddLoadingFile(2, "image/game/living/living156.swf", "game.living.Living156");
      this.Game.SetMap(1154);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 0);
      this.m_kingFront = (PhysicalObj) this.Game.Createlayer(1300, 280, "font", "game.asset.living.xieyanjulongAsset", "out", 1, 0);
      LivingConfig config = this.Game.BaseLivingConfig();
      config.IsFly = true;
      this.m_king = this.Game.CreateBoss(this.bossID, 1702, 470, -1, 0, "", config);
      this.king = this.Game.CreateBoss(this.bossID2, 200, 200, 1, 0, "");
      this.m_king.SetRelateDemagemRect(-100, -79, 172, 100);
      this.king.Say("Có ta ở đây đừng sợ!", 3000, 0);
      this.m_kingMoive.PlayMovie("in", 9000, 0);
      this.m_kingFront.PlayMovie("in", 9000, 0);
      this.m_kingMoive.PlayMovie("out", 10000, 0);
      this.m_kingFront.PlayMovie("out", 10400, 0);
      this.turn = this.Game.TurnIndex;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.IsSay = 0;
      this.kingMoive = (PhysicalObj) this.Game.Createlayer(1710, 480, "kingmoive", "asset.game.4.ruodian", "out", 1, 0);
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
      if (this.kingMoive != null)
      {
        this.Game.RemovePhysicalObj(this.kingMoive, true);
        this.kingMoive = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver()
    {
      if (!this.m_king.IsLiving)
      {
        ++this.m_kill;
        return true;
      }
      return this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1;
    }

    public override int UpdateUIData() => this.m_kill;

    public override void OnGameOver()
    {
      base.OnGameOver();
      bool flag = true;
      foreach (Physics allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving)
          flag = false;
      }
      if (!this.m_king.IsLiving && !flag)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void DoOther()
    {
      base.DoOther();
      if (this.m_king == null)
        return;
      int index = this.Game.Random.Next(0, DLT5304.KillChat.Length);
      this.m_king.Say(DLT5304.KillChat[index], 0, 0);
    }

    public override void OnShooted()
    {
      if (!this.m_king.IsLiving || this.IsSay != 0)
        return;
      int index = this.Game.Random.Next(0, DLT5304.ShootedChat.Length);
      this.m_king.Say(DLT5304.ShootedChat[index], 0, 1500);
      this.IsSay = 1;
    }
  }
}
